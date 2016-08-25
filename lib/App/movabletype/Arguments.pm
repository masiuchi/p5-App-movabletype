package App::movabletype::Arguments;
use strict;
use warnings;

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_wo_accessors(qw/ argv /);

sub commands {
    my $self = shift;
    $self->_parse unless $self->{commands};
    $self->{commands};
}

sub params {
    my $self = shift;
    $self->_parse unless $self->{params};
    $self->{params};
}

sub command_string {
    my $self   = shift;
    my $script = $0;
    $script =~ s/^\.\///;
    join ' ', ( $script, @{ $self->commands } );
}

sub _parse {
    my $self = shift;
    my ( @commands, %params );

    my @argv = @{ $self->{argv} || [] };

    # commands
    until ( @argv == 0 or $argv[0] =~ /^-/ ) {
        push @commands, shift(@argv);
    }

    # params
    my $key;
    for my $p (@argv) {
        if ( $p =~ /^--[^-]/ ) {

            # key

            # previous key
            if ($key) {
                $params{$key} = 1;
                $key = undef;
            }

            $p =~ s/^--//;
            if ( $p =~ /=/ ) {

                # key and value
                my ( $k, $v ) = split /=/, $p;
                $params{$k} = $v;
            }
            else {
                # only key
                $key = $p;
            }
        }
        elsif ( $p =~ /^-[^-]/ ) {

            # key
            if ($key) {
                $params{$key} = 1;
                $key = undef;
            }
            $p =~ s/^-//;
            $params{$p} = 1;
        }
        else {
            # value
            $params{$key} = $p if $key;
        }
    }

    $params{$key} = 1 if $key;

    $self->{commands} = \@commands;
    $self->{params}   = \%params;
}

1;

