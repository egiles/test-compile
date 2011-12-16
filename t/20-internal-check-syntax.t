#! /usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Compile;

my ($ok1,$msg1) = Test::Compile::_check_syntax('t/scripts/subdir/success.pl');
is($ok1,1,"success.pl compiles");

my ($ok2,$msg2) = Test::Compile::_check_syntax('t/scripts/failure.pl');
is($ok2,0,"failure.pl does not compile");
like($msg2,qr/does not compile/,"reasonable failure message");

my ($ok3,$msg3) = Test::Compile::_check_syntax('t/scripts/Module.pm',1);
is($ok3,1,"Module.pm compiles");

done_testing();
