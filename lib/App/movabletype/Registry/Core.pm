package App::movabletype::Registry::Core;
use strict;
use warnings;

sub registry {
    {   help => 'Get MT core information.',
        path => {
            code => \&_path,
            help => 'Get installed path.',
        },
        schema_version => {
            code => \&_schema_version,
            help => 'Get schema version.',
        },
        version => {
            code => \&_version,
            help => 'Get MT version.',
        },
    };
}

sub _path {
    my ( $app, $args ) = @_;
    print $ENV{MT_HOME} . "\n";
}

sub _schema_version {
    my ( $app, $args ) = @_;
    print $app->schema_version . "\n";
}

sub _version {
    my ( $app, $args ) = @_;
    print $app->product_version . "\n";
}

1;

