requires 'perl', '5.008001';

requires 'Class::Accessor::Fast';
requires 'Class::Method::Modifiers';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

