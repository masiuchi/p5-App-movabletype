package App::movabletype::Registry::Task;
use strict;
use warnings;

use Text::Table;

sub registry {
    {   help => 'Schedule tasks.',
        list => {
            code => \&_list,
            help => 'Get all task list.',
        },
        run => {
            code => \&_run,
            help => 'Run specified task.',
        },
    };
}

sub _list {
    my ( $app, $args ) = @_;

    require MT::Task;
    require MT::TaskMgr;

    MT::TaskMgr->instance;
    my $tasks;
    {
        no warnings 'once';
        $tasks = \%MT::TaskMgr::Tasks;
    }

    my $table = Text::Table->new;

    for my $key ( sort keys %$tasks ) {
        my $task = $tasks->{$key} or next;
        if ( ref $task eq 'HASH' ) {
            $task = MT::Task->new($task);
        }
        $table->add( $key, $task->label, $task->frequency,
            $task->{plugin}->id );
    }

    print $table;
}

sub _run {
    my ( $app, $args ) = @_;

    my @tasks = @{ $args->{arguments} };

    $app->run_tasks(@tasks);
}

1;

