use strict;
use warnings;
package Lingua::YALI;
# ABSTRACT: YALI - Yet Another Language Identifier.



sub _open
{
    my ($f) = @_;

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
1;

__END__
=pod

=head1 NAME

Lingua::YALI - YALI - Yet Another Language Identifier.

=head1 VERSION

version 0.005

=head1 SYNOPSIS

The YALI package contains several modules:

=over

=item * L<Lingua::YALI::Examples|Lingua::YALI::Examples> - contains examples.

=item * L<Lingua::YALI::LanguageIdentifier|Lingua::YALI::LanguageIdentifier> - is module for language identification capable of identifying 122 languages.

=item * L<Lingua::YALI::Identifier|Lingua::YALI::Identifier> - allows to use own models for identification.

=item * It is based on published L<algorithm|http://ufal.mff.cuni.cz/~majlis/yali/>.

=back

=head1 WHY TO USE YALI

=over

=item * Contains pretrained models for identifying 122 languages.

=item * Allows to create own models, trained on texts from specific domain, which outperforms the pretrained ones.

=item * 

=back

=head1 COMPARISON WITH OTHERS

=over

=item * L<Lingua::Lid|Lingua::Lid> can recognize 45 languages and returns only the most probable result without any weight.

=item * L<Lingua::Ident|Lingua::Ident> requires training files, so it is similar to L<Lingua::YALI::LanguageIdentifier|Lingua::YALI::LanguageIdentifier>, 
but it does not provide any options for constructing models.

=item * L<Lingua::Identify|Lingua::Identify> can recognize 33 languages but it does not allows you to use different models. 

=back

=head1 AUTHOR

Martin Majlis <martin@majlis.cz>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Martin Majlis.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

