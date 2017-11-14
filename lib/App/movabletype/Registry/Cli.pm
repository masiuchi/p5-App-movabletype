package App::movabletype::Registry::Cli;
use strict;
use warnings;

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
    my ($app, $args) = @_;
    print "App::movabletype $App::movabletype::VERSION\n";
}

sub _perl_version {
    my ($app, $args) = @_;
    print "Perl $^V\n";
}

1;

