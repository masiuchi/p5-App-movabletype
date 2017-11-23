use strict;
use Test::More 0.98;

use_ok $_ for qw(
    App::movabletype
    App::movabletype::Arguments
    App::movabletype::Command
    App::movabletype::MT
    App::movabletype::Registry
    App::movabletype::Registry::App
    App::movabletype::Registry::Cli
    App::movabletype::Registry::Config
    App::movabletype::Registry::Core
    App::movabletype::Registry::Entry
    App::movabletype::Registry::Permission
    App::movabletype::Registry::Plugin
    App::movabletype::Registry::Site
    App::movabletype::Registry::Task
    App::movabletype::Registry::TemplateTag
    App::movabletype::Registry::Worker
);

done_testing;

