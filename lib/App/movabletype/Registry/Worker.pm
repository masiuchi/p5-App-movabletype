package App::movabletype::Registry::Worker;
use strict;
use warnings;

use Text::Table;

sub registry {
    {   help => 'Task workers.',
        list => {
            code => \&_list,
            help => 'Get all task workers.',
        },
    };
}

sub _list {
    my ( $app, $args ) = @_;

    my $table = Text::Table->new;

    my $workers = $app->registry('task_workers');
    for my $key ( sort keys %$workers ) {
        my $label = $workers->{$key}{label};
        $label = $label->() if ref $label eq 'CODE';
        $table->add( $key, $label );
    }

    print $table;
}

1;

