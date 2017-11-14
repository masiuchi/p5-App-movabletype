package App::movabletype::Registry::Site;
use strict;
use warnings;

sub registry {
    {   help => 'site help',
        list => {
            code => sub {
                my ( $app, $args ) = @_;
                print "123\n";
            },
            help => 'uuu',
        },
    };
}

1;

