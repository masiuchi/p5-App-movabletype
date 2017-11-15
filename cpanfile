## -*- mode: perl; coding: utf-8 -*-

requires 'perl', '5.008001';

requires 'Class::Accessor::Fast';
requires 'Class::Method::Modifiers';
requires 'Text::Table';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

on 'develop' => sub {
    requires 'Test::Perl::Critic';
};

