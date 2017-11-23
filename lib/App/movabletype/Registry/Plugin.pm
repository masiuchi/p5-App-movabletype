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
        enable => {
            code => \&_enable,
            help => 'Enable specified plugin',
        },
        disable => {
            code => \&_disable,
            help => 'Disable specified plugin',
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
        my $key    = $p->{key};
        my $name   = $p->{object} ? $p->{object}->label : $p->{key};
        my $status = $p->{object} ? 'enabled' : 'disabled';
        $table->add( $key, $name, $status );
    }

    print $table;
}

sub _enable {
    my ( $app, $args ) = @_;
    my ($plugin_key) = @{ $args->{arguments} };
    unless ($plugin_key) {
        print "plugin key is required.\n";
        return;
    }
    my $plugin = $MT::Plugins{$plugin_key};
    unless ($plugin) {
        print qq{"$plugin_key" does not exist.\n};
        return;
    }
    my $cfg = $app->config;
    $cfg->PluginSwitch( "$plugin_key=1", 1 );
    $cfg->save_config;
    $app->reboot;
    print qq{Enabled "$plugin_key".\n};
}

sub _disable {
    my ( $app, $args ) = @_;
    my ($plugin_key) = @{ $args->{arguments} };
    unless ($plugin_key) {
        print "plugin key is required.\n";
        return;
    }
    my $plugin = $MT::Plugins{$plugin_key};
    unless ($plugin) {
        print qq{"$plugin_key" does not exist.\n};
        return;
    }
    my $cfg = $app->config;
    $cfg->PluginSwitch( "$plugin_key=0", 1 );
    $cfg->save_config;
    $app->reboot;
    print qq{Disabled "$plugin_key".\n};
}

1;

