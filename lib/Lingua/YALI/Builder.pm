package Lingua::YALI::Builder;

use strict;
use warnings;
use Moose;
use Carp;
use Lingua::YALI;

# ABSTRACT: Returns information about languages.

has 'ngrams' => ( is => 'ro', isa => 'ArrayRef' );
has '_max_ngram' => ( is => 'rw', isa => 'Int' );
has '_dict' => ( is => 'rw', isa => 'HashRef' );

sub BUILD
{
    my $self = shift;
    my @sorted = sort { $b <=> $a } @{$self->{ngrams}};
    $self->{_max_ngram} = $sorted[0];
}

sub get_ngrams
{
    my $self = shift;
    return $self->ngrams;
}


sub train_file
{
    my ( $self, $file ) = @_;
    my $fh = Lingua::YALI::_open($file);

    return $self->train_handler($fh);
}

sub train_string
{
    my ( $self, $string ) = @_;
    open(my $fh, "<", \$string) or croak $!;

    my $result = $self->train_handler($fh);

    close($fh);

    return $result;
}

sub train_handler
{
    my ($self, $fh, $verbose) = @_;
    my %actRes = ();

#    my $padding = $self->{_padding};
    my @ngrams = @{$self->ngrams};
    my $padding = "";
    my $subsub = "";
    my $sub = "";    
    
    while ( <$fh> ) {
        chomp;
        s/ +/ /g;
        s/^ +//g;
        s/ +$//g;
        if ( ! $_ ) {
            next;
        }

        $_ = $padding . $_ . $padding;

        {
            use bytes;
            for my $i (0 .. bytes::length($_) - $self->{_max_ngram}) {
                $sub = substr($_, $i, $self->{_max_ngram});
                for my $j (@ngrams) {
                    $subsub = bytes::substr($sub, 0, $j);
#                   if ( $subsub =~ /[[:digit:][:punct:]]/ ) {
#                       next;
#                   }

                    $self->{_dict}->{$j}{$subsub}++;
                    $self->{_dict}->{$j}{___total___}++;
                }
            }
        }
    }

    return 1;
}

sub store
{
    my ($self, $file, $ngram, $lines) = @_;

    if ( ! defined($self->{_dict}->{$ngram}) ) {
        croak("$ngram-grams were not counted.");
    }

    open(my $fhModel, ">:gzip:bytes", $file) or die $!;
    
    print $fhModel $ngram . "\n";

    {
        no warnings;

        for my $k (sort { $self->{_dict}->{$ngram}{$b} <=> $self->{_dict}->{$ngram}{$a} } keys %{$self->{_dict}->{$ngram}}) {
            print $fhModel "$k\t$self->{_dict}->{$ngram}{$k}\n";
        }
    }

    close($fhModel);
}
1;

__END__
=pod

=head1 NAME

Lingua::YALI::Builder - Returns information about languages.

=head1 VERSION

version 0.003

=head1 METHODS

=head2 BUILD

Bla bla

=head2 get_ngrams

Bla bla

=head2 train_file($file)

Bla bla

=head2 train_string($string)

Bla bla

=head2 train_handler($fh)

Bla bla

=head2 store($file, $ngram, $lines)

Bla bla

=head1 AUTHOR

Martin Majlis <martin@majlis.cz>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Martin Majlis.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

