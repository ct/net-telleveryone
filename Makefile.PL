use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Net::TellEveryone',
    AUTHOR              => 'Chris Thompson <cthom@cpan.org>',
    VERSION_FROM        => 'lib/Net/TellEveryone.pm',
    ABSTRACT_FROM       => 'lib/Net/TellEveryone.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-TellEveryone-*' },
);
