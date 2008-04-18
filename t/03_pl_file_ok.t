#!perl -w

use strict;
use warnings;

use Test::More tests => 1;
use Test::Compile;

pl_file_ok('t/scripts/success.pl', 'success.pl compiles');

# TODO: Testing failure of test methods is a little harder
#       perhaps I could copy the approach in Test::Simple's t/fail-like.t ?
#ok(not pl_file_ok('t/scripts/failure.pl'), 'failure.pl does not compile');

