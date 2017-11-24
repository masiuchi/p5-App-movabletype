package App::movabletype::Registry::Database;
use strict;
use warnings;

sub registry {
    {   help   => 'Database commands.',
        create => {
            code => \&_create,
            help => 'Create database.',
        },
        drop => {
            code => \&_drop,
            help => 'Drop database.',
        },
        reset => {
            code => \&_reset,
            help => 'Drop and create database.',
        },
    };
}

sub _create {
    my ( $app, $args ) = @_;

    my $commands = _generate_common_command_array($app);
    my $database = $app->config->Database;
    push @$commands,
        qq{-e "create database if not exists $database character set utf8;"};

    my $command = join ' ', @$commands;
    `$command`;

    print "created database: $database\n";
}

sub _drop {
    my ( $app, $args ) = @_;

    my $commands = _generate_common_command_array($app);
    my $database = $app->config->Database;
    push @$commands, qq{-e "drop database if exists $database"};

    my $command = join ' ', @$commands;
    `$command`;

    print "drop database $database\n";
}

sub _reset {
    _drop(@_);
    _create(@_);
}

sub _generate_common_command_array {
    my ($app) = @_;

    my $dbhost = $app->config->DBHost;
    my $dbuser = $app->config->DBUser;
    my $dbpass = $app->config->DBPass;

    my @commands = ('mysql');
    push @commands, "-h $dbhost" if $dbhost ne 'localhost';
    push @commands, "-u $dbuser";
    push @commands, "-p $dbpass" if defined $dbpass && $dbpass ne '';

    return \@commands;
}

1;
