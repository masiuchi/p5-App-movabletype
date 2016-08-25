package App::movabletype::MT;
use strict;
use warnings;

use Cwd            ();
use File::Basename ();
use File::Spec     ();

use App::movabletype::Registry;

use constant DEFAULT_CONFIG => 'mt-config.cgi';

our ( $HOME, $CONFIG, $MT );

sub instance {
    my $class = shift;
    my $options = shift || {};

    return $MT if $MT;

    $HOME = $options->{mt_home} || $ENV{MT_HOME};
    $CONFIG = $options->{mt_config} || $ENV{MT_CONFIG} || DEFAULT_CONFIG;

    _search_home() or return;
    _use_mt()      or return;

    $MT = MT->instance;

    my $registry = App::movabletype::Registry->registry;
    _expand_handlers($registry);
    $MT->component('core')->registry( 'commands', $registry );

    $MT;
}

sub commands_registry {
    instance() or return;
    $MT->registry('commands') || {};
}

sub _use_mt {
    eval "use lib '$HOME/lib'; 1"    or return;
    eval "use lib '$HOME/extlib'; 1" or return;
    eval "use MT; 1"                 or return;
    1;
}

sub _search_home {
    unless ($HOME) {
        $HOME = Cwd::getcwd();
        $HOME = File::Basename::dirname($HOME)
            until _is_root($HOME) || _is_valid_settings( $HOME, $CONFIG );
    }
    $HOME =~ s/\/$// unless _is_root($HOME);
    _is_valid_settings( $HOME, $CONFIG );
}

sub _expand_handlers {
    my $registry = shift;
    for my $key ( keys %{$registry} ) {
        if ( !ref $registry->{$key} && $registry->{$key} =~ /^\$/ ) {
            $registry->{$key}
                = $MT->handler_to_coderef( $registry->{$key} )->();
        }
    }
}

sub _is_root {
    my $dir = shift;
    $dir eq '/';
}

sub _is_valid_settings {
    my ( $dir, $file ) = @_;
    -f _config_path( $dir, $file ) && !_is_root($dir);
}

sub _config_path {
    my ( $dir, $file ) = @_;
    File::Spec->catfile( $dir, $file );
}

1;

