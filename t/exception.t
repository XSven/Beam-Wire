
use strict;
use warnings;
use Test::More;
use Test::Deep;
use Test::Exception;
use FindBin qw( $Bin );
use Path::Tiny qw( path );
my $SHARE_DIR = path( $Bin, 'share' );

use Beam::Wire;

subtest 'config file does not exist' => sub {
    throws_ok { Beam::Wire->new( file => 'DOES_NOT_EXIST.yml' ) } 'Beam::Wire::Exception::Constructor';
    like $@, qr{\QContainer file 'DOES_NOT_EXIST.yml' does not exist}, 'stringifies';
};

subtest "get a service that doesn't exist" => sub {
    my $wire = Beam::Wire->new;
    throws_ok { $wire->get( 'foo' ) } 'Beam::Wire::Exception::NotFound';
    is $@->name, 'foo';
    like $@, qr{\QService 'foo' not found}, 'stringifies';

    subtest 'not found with file shows file name' => sub {
        my $path = $SHARE_DIR->child( 'file.yml' )->stringify;
        my $wire = Beam::Wire->new( file => $path );
        throws_ok { $wire->get( 'does_not_exist' ) } 'Beam::Wire::Exception::NotFound';
        is $@->name, 'does_not_exist';
        like $@, qr{\QService 'does_not_exist' not found in file '$path'}, 'stringifies';
    };
};

subtest "extend a service that doesn't exist" => sub {
    my $wire = Beam::Wire->new(
        config => {
            foo => {
                extends => 'bar',
            },
        },
    );
    throws_ok { $wire->get( 'foo' ) } 'Beam::Wire::Exception::NotFound';
    is $@->name, 'bar';
    like $@, qr{\QService 'bar' not found}, 'stringifies';
};

subtest "service with both value and class/extends" => sub {
    subtest "class + value" => sub {
        my $wire;
        lives_ok {
            $wire = Beam::Wire->new(
                config => {
                    foo => {
                        class => 'My::ArgsTest',
                        value => 'foo',
                    }
                }
            );
        };
        throws_ok { $wire->get( 'foo' ) } 'Beam::Wire::Exception::InvalidConfig';
        is $@->name, 'foo';
        like $@, qr{\QInvalid config for service 'foo': "value" cannot be used with "class" or "extends"}, 'stringifies';
    };
    subtest "extends + value" => sub {
        my $wire;
        lives_ok {
            $wire = Beam::Wire->new(
                config => {
                    bar => {
                        value => 'bar',
                    },
                    foo => {
                        extends => 'bar',
                        value => 'foo',
                    }
                }
            );
        };
        throws_ok { $wire->get( 'foo' ) } 'Beam::Wire::Exception::InvalidConfig';
        is $@->name, 'foo';
        like $@, qr{\QInvalid config for service 'foo': "value" cannot be used with "class" or "extends"}, 'stringifies';
    };
    subtest "value in extended service" => sub {
        my $wire;
        lives_ok {
            $wire = Beam::Wire->new(
                config => {
                    bar => {
                        value => 'bar',
                    },
                    foo => {
                        extends => 'bar',
                        class => 'foo',
                    }
                }
            );
        };
        throws_ok { $wire->get( 'foo' ) } 'Beam::Wire::Exception::InvalidConfig';
        is $@->name, 'foo';
        like $@, qr{\QInvalid config for service 'foo': "value" cannot be used with "class" or "extends"}, 'stringifies';
    };

    subtest "exception shows file name" => sub {
        my $path = $SHARE_DIR->child( 'file.yml' )->stringify;
        my $wire;
        lives_ok {
            $wire = Beam::Wire->new(
                file => $path,
                config => {
                    bar => {
                        value => 'bar',
                    },
                    foo => {
                        extends => 'bar',
                        class => 'foo',
                    }
                }
            );
        };
        throws_ok { $wire->get( 'foo' ) } 'Beam::Wire::Exception::InvalidConfig';
        is $@->name, 'foo';
        like $@, qr{\QInvalid config for service 'foo': "value" cannot be used with "class" or "extends" in file '$path'}, 'stringifies';
    };
};

done_testing;