package App::movabletype::Registry::Permission;
use strict;
use warnings;

sub registry {
    {   help => 'Permissions.',
        list => {
            code => \&_list,
            help => 'Get all permission list.',
        },
        actions => {
            code => \&_actions,
            help => 'Show permitted actions of specified permission.',
        },
    };
}

sub _list {
    my ( $app, $args ) = @_;
    for my $p ( sort keys %{ $app->registry('permissions') } ) {
        print $p . "\n";
    }
}

sub _actions {
    my ( $app, $args ) = @_;
    my ($permission_name) = @{ $args->{arguments} };
    unless ($permission_name) {
        print "require permission name.\n";
        return;
    }
    my $permission = $app->registry( 'permissions', $permission_name );
    unless ($permission) {
        print qq{"$permission_name" does not exist.\n};
        return;
    }
    my $actions = $permission->{permitted_action};
    for my $action_name ( sort keys %$actions ) {
        if ( $action_name eq 'plugin' && $actions->{$action_name} ne '1' ) {
            next;
        }
        print $action_name . "\n";
    }
}

1;

