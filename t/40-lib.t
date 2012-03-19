#!perl -w

use strict;
use warnings;

use Test::Compile;

use Test::More ;
plan skip_all => "Distribution hasn't been built yet" unless -d "blib/lib";

pl_file_ok('t/scripts/lib.pl', 'lib.pl compiles', "verbose");
done_testing();
