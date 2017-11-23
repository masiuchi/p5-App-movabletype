package App::movabletype::MT;
use strict;
use warnings;

use Cwd            ();
use File::Basename ();
use File::Spec     ();

use App::movabletype::Registry;
use App::movabletype::Registry::Cli;

use constant DEFAULT_CONFIG => 'mt-config.cgi';

our $MT;

sub instance {
    my $class = shift;
    my $options = shift || {};

    return $MT if $MT;

    $ENV{MT_HOME} ||= $options->{mt_home};
    $ENV{MT_CONFIG} ||= $options->{mt_config} || DEFAULT_CONFIG;

    _search_home() or return;
    _use_mt()      or return;

    require MT::App;
    $MT = MT::App->instance;

    my $registry = App::movabletype::Registry->registry;
    _expand_handlers($registry);
    $MT->component('core')->registry( 'commands', $registry );

    $MT;
}

sub commands_registry {
    if ( instance() ) {
        $MT->registry('commands');
    }
    else {
        +{ cli => App::movabletype::Registry::Cli->registry };
    }
}

sub _use_mt {
    unshift @INC, "$ENV{MT_HOME}/lib", "$ENV{MT_HOME}/extlib";
    eval { require MT } or return;
    1;
}

sub _search_home {
    unless ( $ENV{MT_HOME} ) {
        $ENV{MT_HOME} = Cwd::getcwd();
        $ENV{MT_HOME} = File::Basename::dirname( $ENV{MT_HOME} )
            until _is_root( $ENV{MT_HOME} )
            || _is_valid_settings( $ENV{MT_HOME}, $ENV{MT_CONFIG} );
    }
    $ENV{MT_HOME} =~ s/\/$// unless _is_root( $ENV{MT_HOME} );
    _is_valid_settings( $ENV{MT_HOME}, $ENV{MT_CONFIG} );
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

