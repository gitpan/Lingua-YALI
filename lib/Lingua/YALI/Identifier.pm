package Lingua::YALI::Identifier;

use strict;
use warnings;
use Moose;

# ABSTRACT: Returns information about languages.



has '_model_file' => ( is => 'rw', isa => 'HashRef' );
has '_frequency' => ( is => 'rw', isa => 'HashRef' );
has '_models_loaded' => ( is => 'rw', isa => 'HashRef' );
has '_ngram' => ( is => 'rw', isa => 'Int' );

sub BUILD
{
    my $self = shift;
    my %frequency = ();
    my %models_loaded = ();
    $self->{_frequency} = \%frequency;
    $self->{_models_loaded} = \%models_loaded;

    return;
}


sub add_class
{
    my ( $self, $class, $file ) = @_;

    if ( defined( $self->{_model_file}->{$class} ) ) {
        return 0;
    }

    if ( !-r $file ) {
        croak("Model $file is not readable.");
    }

    $self->{_model_file}->{$class} = $file;

    $self->_load_model($class);

    return 1;
}


sub remove_class
{
    my ( $self, $class, $file ) = @_;

    if ( defined( $self->{_model_file}->{$class} ) ) {
        delete( $self->{_model_file}->{$class} );

        $self->_unload_model($class);

        return 1;
    }

    return 0;
}

sub get_classes
{
    my $self    = shift;
    my @classes = keys %{ $self->{_model_file} };

    return \@classes;
}

sub identify_file
{
    my ( $self, $file ) = @_;
    my $fh = $self->_open($file);

    return $self->identify_handler($fh);
}

sub identify_string
{
    my ( $self, $string ) = @_;
    open(my $fh, "<", \$string) or croak $!;

    my $result = $self->identify_handler($fh);

    close($fh);

    return $result;
}

sub identify_handler
{
    my ($self, $fh, $verbose) = @_;
    my %actRes = ();

#    my $padding = $self->{_padding};
    my $ngram = $self->{_ngram};

    while ( <$fh> ) {
        chomp;
        s/ +/ /g;
        s/^ +//g;
        s/ +$//g;
        if ( ! $_ ) {
            next;
        }

#        $_ = $padding . $_ . $padding;

        {
            use bytes;
            for my $i (0 .. bytes::length($_) - $ngram) {
                my $w = substr($_, $i, $ngram);

                if ( defined($self->{_frequency}->{$w}) ) {
                    for my $lang (keys %{$self->{_frequency}->{$w}}) {
#                       print STDERR "$w - $lang - $frequency{$w}{$lang}\n";
                        $actRes{$lang} += $self->{_frequency}->{$w}{$lang};
#                       print STDERR "Lang: $lang - $actRes{$lang}\n";
                    }
                }
            }
        }

    }

    my @allLanguages = @ { $self->get_classes() };

    my $sum = 0;
    for my $l (@allLanguages) {
        my $score = 0;
        if ( defined($actRes{$l}) ) {
            $score = $actRes{$l};
        }
        $sum += $score;
    }

    my @res = ();
    if ( $sum > 0 ) {
        for my $l (@allLanguages) {
            my $score = 0;
            if ( defined($actRes{$l}) ) {
                $score = $actRes{$l};
            }
            my @pair = ($l, $score / $sum);
            push(@res, \@pair);
        }
    }

#    print STDERR "\nX\n" . $res[0] . "\nX\n";
#    print STDERR "\nX\n\t" . $res[0]->[0] . "\nX\n";
#    print STDERR "\nX\n\t" . $res[0]->[1] . "\nX\n";
#    print STDERR "\nY\n" . $res[1] . "\nY\n";
#    print STDERR "\nY\n\t" . $res[1]->[0] . "\nY\n";
#    print STDERR "\nY\n\t" . $res[1]->[1] . "\nY\n";

    my @sortedRes = sort { $b->[1] <=> $a->[1] } @res;

    return \@sortedRes;
}

sub _open
{
    my ($self, $f) = @_;

    croak("Not found: $f") if !-e $f;

    my $opn;
    my $hdl;
    my $ft = qx(file '$f');

    # file might not recognize some files!
    if ( $f =~ /\.gz$/ || $ft =~ /gzip compressed data/ ) {
        $opn = "zcat $f |";
    }
    elsif ( $f =~ /\.bz2$/ || $ft =~ /bzip2 compressed data/ ) {
        $opn = "bzcat $f |";
    }
    else {
        $opn = "$f";
    }
    open($hdl,"<:bytes", $opn) or croak ("Can't open '$opn': $!");
    binmode $hdl, ":bytes";
    return $hdl;
}


sub _load_model
{
    my ($self, $class) = @_;

    if ( $self->{_models_loaded}->{$class} ) {
        return;
    }

    my $file = $self->{_model_file}->{$class};

    open(my $fh, "<:gzip:bytes", $file) or croak($!);
    my $ngram = <$fh>;
    if ( ! defined($self->{_ngram}) ) {
        $self->{_ngram} = $ngram;
    } else {
        if ( $ngram != $self->{_ngram} ) {
            croak("Incompatible model for '$class'. Expected $self->{_ngram}-grams, but was $ngram-gram.");
        }
    }

    my $sum = 0;
    while ( <$fh> ) {
        chomp;
        my @p = split(/\t/, $_);
        my $word = $p[0];
        $self->{_frequency}->{$word}{$class} = $p[1];
        $sum += $p[1];
    }

    for my $word (keys %{$self->{_frequency}}) {
        if ( defined($self->{_frequency}->{$word}{$class}) ) {
            $self->{_frequency}->{$word}{$class} /= $sum;
        }
    }

    close($fh);

    return;
}

sub _unload_model
{
    my ($self, $class) = @_;

    if ( ! $self->{_models_loaded}->{$class} ) {
        return;
    }

    delete($self->{_models_loaded}->{$class});

    return;
}

1;

__END__
=pod

=head1 NAME

Lingua::YALI::Identifier - Returns information about languages.

=head1 VERSION

version 0.001

=head1 METHODS

=head2 BUILD

Initializes internal variables.

=head2 add_class($label, $model)

Adds model stored in file $model with label $label.

=head4 Returns $iso

=head2 remove_class($label)

Removes model for label $label.

=head4 Returns $iso

=head2 get_classes

Returns all registered classes.

=head4 Returns \@classes

=head2 identify_file($file)

Identifies class of file $file. Returns reference to array of pairs with values [class, score] 
sorted descendently according to score, so the first result is the most probable one. 

=head4 Returns [ ['lbl1', score1], ['lbl2', score2], ...]

=head2 identify_string($string)

Identifies class of string $string. Returns reference to array of pairs with values [class, score] 
sorted descendently according to score, so the first result is the most probable one. 

=head4 Returns [ ['lbl1', score1], ['lbl2', score2], ...]

=head2 identify_handler($fh)

Identifies class of file handler $fh. Returns reference to array of pairs with values [class, score] 
sorted descendently according to score, so the first result is the most probable one. 

=head4 Returns [ ['lbl1', score1], ['lbl2', score2], ...]

=head1 AUTHOR

Martin Majlis <martin@majlis.cz>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Martin Majlis.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

