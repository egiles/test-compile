#! /usr/bin/perl

use strict;
use warnings;

use Test::Compile::Internal;

my $internal = Test::Compile::Internal->new();
$internal->all_files_ok();
$internal->done_testing();
