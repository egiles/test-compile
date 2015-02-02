#!perl

use strict;
use warnings;

use Test::More;

plan skip_all => 'unset AUTOMATED_TESTING to run this test'
    if $ENV{AUTOMATED_TESTING};
plan skip_all => 'Test::Pod required'
    unless eval 'use Test::Pod; 1';

all_pod_files_ok();
