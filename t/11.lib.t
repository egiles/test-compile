#!perl -w
use strict;
use warnings;
use Test::More tests => 1;
use Test::Compile;
pl_file_ok('t/scripts/lib.pl', 'lib.pl compiles');

