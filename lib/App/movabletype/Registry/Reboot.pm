package App::movabletype::Registry::Reboot;
use strict;
use warnings;

sub registry {
    {   code => \&_code,
        help => 'Reboot FastCGI/PSGI process.',
    };
}

sub _code {
    my ( $app, $args ) = @_;
    $app->do_reboot;
    print "rebooting...\n";
}

1;
