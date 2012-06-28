
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  'ABSTRACT' => 'YALI - Yet Another Language Identifier.',
  'AUTHOR' => 'Martin Majlis <martin@majlis.cz>',
  'BUILD_REQUIRES' => {
    'English' => '1.04',
    'Test::Command' => '0.08',
    'Test::Exception' => '0.31',
    'Test::More' => '0.98',
    'Time::HiRes' => '1.9725'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31',
    'File::ShareDir::Install' => '0.03'
  },
  'DISTNAME' => 'Lingua-YALI',
  'EXE_FILES' => [
    'bin/yali-builder',
    'bin/yali-identifier',
    'bin/yali-language-identifier'
  ],
  'LICENSE' => 'bsd',
  'NAME' => 'Lingua::YALI',
  'PREREQ_PM' => {
    'Carp' => '1.26',
    'File::Basename' => '2.83',
    'File::Glob' => '1.13',
    'File::ShareDir' => '1.03',
    'Getopt::Long' => '2.38',
    'List::MoreUtils' => '0.33',
    'Moose' => '2.0602',
    'Moose::Util::TypeConstraints' => '2.0602',
    'POSIX' => '1.26',
    'PerlIO::gzip' => '0.18',
    'Pod::Usage' => '1.51',
    'bytes' => '1.04',
    'strict' => '1.04',
    'warnings' => '1.12'
  },
  'VERSION' => '0.009_02',
  'test' => {
    'TESTS' => 't/*.t t/Builder/*.t t/Examples/*.t t/Identifier/*.t t/LanguageIdentifier/*.t t/yali-builder/*.t t/yali-language-identifier/*.t'
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

package
MY;
use File::ShareDir::Install qw(postamble);


