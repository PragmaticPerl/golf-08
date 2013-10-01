use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'golf-08',
    AUTHOR              => q{Vladimir Lettiev <crux@cpan.org>},
    VERSION             => '0.01',
    ABSTRACT            => 'Golf 08',
	BUILD_REQUIRES => {
        'Capture::Tiny' => '0.12',
	},
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => { 'digits.pl' },
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'golf-08-*' },
);
