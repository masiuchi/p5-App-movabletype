package App::movabletype::Registry::TemplateTag;
use strict;
use warnings;

use Text::Table;

sub registry {
    {   help => 'Template tags.',
        list => {
            code => \&_list,
            help => 'Get template tag list.',
        },
        modifier => {
            code => \&_modifier,
            help => 'Get template tag modifier list.',
        },
    };
}

sub _list {
    my ( $app, $args ) = @_;

    my $block_flag       = $args->{params}{block};
    my $conditional_flag = $args->{params}{conditional};
    my $function_flag    = $args->{params}{function};

    my $no_flag = !$block_flag && !$conditional_flag && !$function_flag;

    my $select_block       = $no_flag || $block_flag;
    my $select_conditional = $no_flag || $conditional_flag;
    my $select_function    = $no_flag || $function_flag;

    my $search_str = $args->{arguments}->[0];
    my $regex
        = defined $search_str && $search_str ne '' ? qr/$search_str/i : qr/./;

    my $table = Text::Table->new;

    if ($select_block) {
        my @block_tags = sort
            grep {/$regex/}
            map  {"MT$_"}
            grep { $_ !~ /\?$/ }
            keys %{ $app->registry( 'tags', 'block' ) };
        $table->load( map { [ $_, 'block' ] } @block_tags );
    }
    if ($select_conditional) {
        my @conditional_tags = sort
            grep {/$regex/}
            map { my ($t) = /^([^\?]+)\?$/; "MT$t" }
            grep { $_ =~ /\?$/ }
            keys %{ $app->registry( 'tags', 'block' ) };
        $table->load( map { [ $_, 'conditional' ] } @conditional_tags );
    }
    if ($select_function) {
        my @function_tags = sort
            grep {/$regex/}
            map  {"MT$_"}
            keys %{ $app->registry( 'tags', 'function' ) };
        $table->load( map { [ $_, 'function' ] } @function_tags );
    }

    print $table;
}

sub _modifier {
    my ( $app, $args ) = @_;

    my $search_str = $args->{arguments}->[0];
    my $regex
        = defined $search_str && $search_str ne '' ? qr/$search_str/i : qr/./;

    for my $mod (
        sort grep {/$regex/}
        keys %{ $app->registry( 'tags', 'modifier' ) }
        )
    {
        print $mod . "\n";
    }
}

1;

