package App::movabletype::Registry::Plugin;
use strict;
use warnings;

use Text::Table;

sub registry {
    {   help => 'Plugins.',
        list => {
            code => \&_list,
            help => 'Get plugin list',
        },
    };
}

sub _list {
    my ( $app, $args ) = @_;

    my @plugins;
    {
        no warnings 'once';
        @plugins = sort { $a->{key} cmp $b->{key} }
            map { +{ key => $_, %{ $MT::Plugins{$_} } } }
            keys %MT::Plugins;
    }

    my $table = Text::Table->new;

    for my $p (@plugins) {
        next if $p->{object} && !$p->{object}->isa('MT::Plugin');
        my $name   = $p->{object} ? $p->{object}->label : $p->{key};
        my $status = $p->{object} ? 'enabled'           : 'disabled';
        $table->add( $name, $status );
    }

    print $table;
}

1;

