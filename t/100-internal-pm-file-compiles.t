#!perl

use strict;
use warnings;

use Test::More;
use Test::Compile::Internal;

my $internal = Test::Compile::Internal->new();

my $yes = $internal->pm_file_compiles('t/scripts/Module.pm');
ok($yes, "Module.pm should compile");

my $no = $internal->pm_file_compiles('t/scripts/CVS/Ignore.pm');
ok(!$no, "Ignore.pm should not compile");

my $notfound = $internal->pm_file_compiles('t/scripts/NotFound.pm');
ok(!$notfound, "NotFound.pm should not compile");


done_testing();
