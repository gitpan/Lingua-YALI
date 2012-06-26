package Lingua::YALI::LanguageIdentifier;
use strict;
use warnings;


# ABSTRACT: Returns information about languages.


use File::ShareDir;
use File::Glob;
use Carp;
use Moose;

extends 'Lingua::YALI::Identifier';



has '_languages' => (is => 'rw', isa => 'ArrayRef');

has '_language_model' => (is => 'rw', isa => 'HashRef');


sub add_language
{
    my ($self, @languages) = @_;

    # lazy loading
    if ( ! defined($self->_languages) ) {
        $self->get_available_languages();
    }

    my $added_languages = 0;
    for my $lang (@languages) {
        if ( ! defined($self->{_language_model}->{$lang}) ) {
            croak("Unknown language $lang");
        }
        $added_languages += $self->add_class($lang, $self->{_language_model}->{$lang});
    }

    return $added_languages;
}

sub remove_language
{
    my ($self, @languages) = @_;

    # lazy loading
    if ( ! defined($self->_languages) ) {
        $self->get_available_languages();
    }

    my $added_languages = 0;
    for my $lang (@languages) {
        if ( ! defined($self->{_language_model}->{$lang}) ) {
            croak("Unknown language $lang");
        }
        $added_languages += $self->remove_class($lang);
    }

    return $added_languages;
}

sub get_languages
{
    my $self = shift;
    return $self->get_classes();
}


sub get_available_languages
{
    my $self = shift;
    # Get a module's shared files directory

    if ( ! defined($self->_languages) ) {

        my $dir = File::ShareDir::dist_dir('Lingua-YALI');
#        print STDERR "\n\n" . $dir . "\n\n";

        my @languages = ();
        #$self->_language_model = ();

        for my $file (File::Glob::bsd_glob($dir . "/*.yali.gz")) {
            my $language = $file;
            $language =~ s/\Q$dir\E.//;
            $language =~ s/.yali.gz//;
            push(@languages, $language);

            $self->{_language_model}->{$language} = $file;

        }
        $self->_languages(\@languages);
#        print STDERR join("\t", @languages), "\n";
    }

    return $self->_languages;
}

1;

__END__
=pod

=head1 NAME

Lingua::YALI::LanguageIdentifier - Returns information about languages.

=head1 VERSION

version 0.003_01

=head1 METHODS

=head2 add_language(@languages)

Registres new languages @languages for identification.

=head4 Returns number of newly added languages.

=head2 remove_language(@languages)

Remove languages @languages for identification.

=head4 Returns number of removed languages.

=head2 get_languages

Returns registered languages.

=head4 Returns \@languages

=head2 get_available_languages

Returns all available languages that could be identified.

=head4 Returns \@all_languages

=encoding utf8

=head1 AUTHOR

Martin Majlis <martin@majlis.cz>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Martin Majlis.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

