package App::movabletype::Registry::App;
use strict;
use warnings;

sub registry {
    {   help   => 'App commands.',
        reboot => {
            code => \&_reboot,
            help => 'Reboot FastCGI/PSGI process.',
        },
    };
}

sub _reboot {
    my ( $app, $args ) = @_;
    $app->do_reboot;
    print "rebooting...\n";
}

1;

