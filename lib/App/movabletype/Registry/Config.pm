package App::movabletype::Registry::Config;
use strict;
use warnings;

use Data::Dumper::Concise;
use Text::Table;

sub registry {
    {   help => 'Config settings.',
        list => {
            code => \&_list,
            help => 'Get config_settings list.',
        },
    };
}

sub _list {
    my ( $app, $args ) = @_;

    my $table = Text::Table->new;

    my $key_regex_str = $args->{params}{key};
    my $key_regex     = defined $key_regex_str
        && $key_regex_str ne '' ? qr/$key_regex_str/i : qr/./;

    my $value_regex_str = $args->{params}{value};
    my $value_regex     = defined $value_regex_str
        && $value_regex_str ne '' ? qr/$value_regex_str/s : qr/./;

    my $settings = $app->registry('config_settings');
    for my $key ( sort grep {/$key_regex/} keys %$settings ) {
        my $value = $app->config($key);

        if ( !defined $value ) {
            $value = 'undef';
        }
        elsif ( $value eq '' ) {
            $value = '""';
        }
        elsif ( $value && ref $value eq 'HASH' ) {
            $value = Dumper($value);
        }

        next unless $value =~ /$value_regex/;

        $table->add( $key, $value );
    }

    print $table;
}

1;

