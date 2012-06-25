
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Returns information about languages.',
  'AUTHOR' => 'Martin Majlis <martin@majlis.cz>',
  'BUILD_REQUIRES' => {
    'English' => '0',
    'File::Basename' => '0',
    'Test::Exception' => '0',
    'Test::More' => '0',
    'Time::HiRes' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Lingua-YALI',
  'EXE_FILES' => [],
  'LICENSE' => 'bsd',
  'NAME' => 'Lingua::YALI',
  'PREREQ_PM' => {
    'Carp' => '0',
    'File::Glob' => '0',
    'File::ShareDir' => '0',
    'Moose' => '0',
    'PerlIO::gzip' => '0',
    'bytes' => '0',
    'strict' => '0',
    'warnings' => '0'
  },
  'VERSION' => '0.003',
  'test' => {
    'TESTS' => 't/*.t t/Builder/*.t t/Identifier/*.t t/LanguageIdentifier/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



