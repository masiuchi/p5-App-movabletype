package App::movabletype::Registry;
use strict;
use warnings;

my $prefix = '$Core::App::movabletype::Registry';

sub registry {
    {   cli        => "${prefix}::Cli::registry",
        config     => "${prefix}::Config::registry",
        core       => "${prefix}::Core::registry",
        db         => "${prefix}::Database::registry",
        entry      => "${prefix}::Entry::registry",
        permission => "${prefix}::Permission::registry",
        'plug-in'  => "${prefix}::Plugin::registry",
        reboot     => "${prefix}::Reboot::registry",
        site       => "${prefix}::Site::registry",
        task       => "${prefix}::Task::registry",
        tmpltag    => "${prefix}::TemplateTag::registry",
        worker     => "${prefix}::Worker::registry",
    };
}

1;
