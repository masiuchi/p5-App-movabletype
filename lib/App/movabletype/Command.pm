package App::movabletype::Command;
use strict;
use warnings;

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_wo_accessors(qw/ args registry /);

use Class::Method::Modifiers;

use App::movabletype::MT;

around 'new' => sub {
    my $orig = shift;
    my $self = $orig->(@_);
    $self->_search_command or return;
    $self;
};

sub run {
    my $self = shift;

    return $self->print_help if $self->_is_parent_command;

    my $code = _to_coderef_if_needed( $self->{registry}{code} );
    unless ( ref $code eq 'CODE' ) {
        print "Error: invalid code property\n";
        return;
    }

    $code->( $self->{args} );
}

sub print_help {
    my $self = shift;
    if ( $self->_is_parent_command ) {
        print $self->_help_subcommands . "\n";
    }
    else {
        print $self->_help_command . "\n";
    }
}

sub _search_command {
    my $self = shift;
    my $r    = $self->{registry};
    return unless _is_hash($r);
    for my $p ( @{ $self->{args}->commands } ) {
        $r = $r->{$p} or return;
    }
    return unless _is_hash($r);
    $self->{registry} = $r;
    1;
}

sub _is_parent_command {
    my $self = shift;
    !exists $self->{registry}{code};
}

sub _help_command {
    my $self = shift;
    _evaluate( $self->{registry}{help} );
}

sub _help_subcommands {
    my $self = shift;

    my $cmd  = $self->{args}->command_string;
    my $help = "usage: $cmd <command> [arguments]\n";
    $help .= "\n";
    $help .= "commands:\n";

    my $help_table = $self->_help_table;
    my @names      = sort keys %{$help_table};
    my $max_length = _max_length(@names);
    for my $name (@names) {
        $help .= "    $name";
        $help .= " " x ( $max_length - length $name );
        $help .= "\t$help_table->{$name}\n";
    }
    $help;
}

sub _help_table {
    my $self = shift;
    my %table;
    my $r = $self->{registry};
    for my $name ( keys %{$r} ) {
        next if $name eq 'plugin' || $name eq 'help';
        $table{$name} = _evaluate( $r->{$name}{help} );
    }
    \%table;
}

sub _is_hash {
    my $hash = shift;
    ref $hash eq 'HASH';
}

sub _max_length {
    my @array = @_;
    my $max   = 0;
    for my $p (@array) {
        $max = length $p if $max < length $p;
    }
    $max;
}

sub _to_coderef_if_needed {
    my $handler = shift || '';
    if ( !ref $handler && $handler =~ /^(?:sub\s+\{|\$)/ ) {
        $handler
            = App::movabletype::MT->instance->handler_to_coderef($handler);
    }
    $handler;
}

sub _evaluate {
    my $handler = shift;
    $handler = _to_coderef_if_needed($handler);
    $handler eq 'CODE' ? $handler->() : $handler;
}

1;

