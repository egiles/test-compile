#! /usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Compile;

my $ok1 = Test::Compile::_check_syntax('t/scripts/subdir/success.pl');
is($ok1,1,"success.pl compiles");

# This is going to produce perl errors (which we don't want to see)
# - so we'll call it differently to suppress that STDERR output
my $ok2 = Test::Compile::_run_in_subprocess(
    sub{Test::Compile::_check_syntax('t/scripts/failure.pl')}
);
is($ok2,0,"failure.pl does not compile");

my $ok3 = Test::Compile::_check_syntax('t/scripts/Module.pm',1);
is($ok3,1,"Module.pm compiles");

done_testing();
