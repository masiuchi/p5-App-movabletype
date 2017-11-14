package App::movabletype::Registry::Entry;
use strict;
use warnings;

sub registry {
    {   help  => 'manipulate entries.',
        count => {
            code => sub {
                my ( $app, $args ) = @_;
                print "entry count\n";
            },
            help => 'the number of entries.',
        },
        list => {
            code => sub {
                my ( $app, $args ) = @_;
                print "entry list\n";
            },
            help => 'show entries.',
        },
        show => {
            code => sub {
                my ( $app, $args ) = @_;
                print "entry show\n";
            },
            help => 'show one entries.',
        },
    };
}

1;

