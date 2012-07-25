#!perl

use strict;
use warnings;

use Test::More;
use Test::Compile::Internal;

my $internal = Test::Compile::Internal->new();

my $yes = $internal->pm_file_compiles('t/scripts/Module.pm');
is($yes,1,"Module.pm should compile");

my $no = $internal->pm_file_compiles('t/scripts/CVS/Ignore.pm');
is($no,0,"Ignore.pm should not compile");


done_testing();
