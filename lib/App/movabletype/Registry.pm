package App::movabletype::Registry;
use strict;
use warnings;

my $prefix = '$Core::App::movabletype::Registry';

sub registry {
    {   cli     => "${prefix}::Cli::registry",
        config  => "${prefix}::Config::registry",
        core    => "${prefix}::Core::registry",
        entry   => "${prefix}::Entry::registry",
        site    => "${prefix}::Site::registry",
        task    => "${prefix}::Task::registry",
        tmpltag => "${prefix}::TemplateTag::registry",
    };
}

1;

