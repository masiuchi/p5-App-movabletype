package App::movabletype::Registry::Cli;
use strict;
use warnings;

use App::movabletype;

sub registry {
    {   help    => 'cli commands.',
        version => {
            code => \&_version,
            help => 'Get App::movabletype version.',
        },
        perl_version => {
            code => \&_perl_version,
            help => 'Get Perl version.',
        },
    };
}

sub _version {
    print "App::movabletype $App::movabletype::VERSION\n";
}

sub _perl_version {
    print "Perl $^V\n";
}

1;

