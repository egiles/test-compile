#!perl

use strict;
use warnings;

use Test::More;
use Test::Compile::Internal;

my $internal = Test::Compile::Internal->new();

my @files;

@files = sort $internal->all_pl_files();
is(scalar @files,0,'Found correct number of scripts in default location');

@files = sort $internal->all_pl_files('t/scripts');
is(scalar @files,4,'Found correct number of scripts in t/scripts');
is($files[0],'t/scripts/failure.pl','Found script: failure.pl');
is($files[1],'t/scripts/lib.pl','Found script: lib.pl');
is($files[2],'t/scripts/subdir/success.pl','Found script: success.pl');
is($files[3],'t/scripts/taint.pl','Found script: taint.pl');

$internal->done_testing();
