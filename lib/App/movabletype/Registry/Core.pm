package App::movabletype::Registry::Core;
use strict;
use warnings;

sub registry {
    {   help    => 'Get MT core information.',
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
    print $MT::MT_DIR . "\n";
}

sub _schema_version {
    print $MT::SCHEMA_VERSION . "\n";
}

sub _version {
    print $MT::PRODUCT_VERSION . "\n";
}

1;

