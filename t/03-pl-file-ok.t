#!perl -w
use strict;
use warnings;
use Test::More tests => 2;
use Test::Compile;
pl_file_ok('t/scripts/subdir/success.pl', 'success.pl compiles');
pl_file_ok('t/scripts/taint.pl', 'taint.pl compiles');
