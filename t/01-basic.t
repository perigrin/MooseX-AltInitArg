#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 28;
use Test::Moose;

{

    package MyTest;
    use Moose;
    use MooseX::AltInitArg;

    has foo => (
        is            => 'ro',
        traits        => ['AltInitArg'],
        alt_init_args => ['bar'],
    );

    has baz => (
        is            => 'rw',
        traits        => ['AltInitArg'],
        init_arg      => undef,
        alt_init_args => ['quux'],
    );
}

with_immutable {
    my $test1 = MyTest->new( foo => 'foo', baz => 'baz' );
    is( $test1->foo, 'foo', 'Attribute set with default init_arg' );
    is( $test1->baz, undef, 'Attribute set with default init_arg (undef)' );

    my $test2 = MyTest->new( bar => 'bar', quux => 'quux' );
    is( $test2->foo, 'bar', 'Attribute set with default init_arg' );
    is( $test2->baz, undef, 'Attribute set with default init_arg (undef)' );
}
'MyTest';
