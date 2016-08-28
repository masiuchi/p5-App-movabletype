package App::movabletype;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use File::Basename ();

use App::movabletype::Arguments;
use App::movabletype::Command;
use App::movabletype::MT;

sub run {
    my $class = shift;

    my @argv = @_ || @ARGV;
    my $args = App::movabletype::Arguments->new( { argv => \@argv } );

    my $mt_home   = $args->params->{mt_home};
    my $mt_config = $args->params->{mt_config};
    if ( $mt_home or $mt_config ) {
        App::movabletype::MT->instance(
            { mt_home => $mt_home, mt_config => $mt_config } );
    }

    my $registry = App::movabletype::MT->commands_registry;
    my $command
        = App::movabletype::Command->new(
        { args => $args, registry => $registry } );

    return _no_command( $args->commands ) unless $command;

    $command->run;
}

sub _no_command {
    my $commands = shift;
    my $command_str = join ' ', @{$commands};
    print "no command: \"$command_str\"\n";
}

1;
__END__

=encoding utf-8

=head1 NAME

App::movabletype - A command line interface for Movable Type.

=head1 SYNOPSIS

    # cd (your movable type directory)
    $ mt core version

=head1 DESCRIPTION

App::movabletype is a command line interface for Movable Type.
It can be extended by MT registry.

=head1 LICENSE

Copyright (C) Masahiro Iuchi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masahiro Iuchi E<lt>masahiro.iuchi@gmail.comE<gt>

=cut

