#!perl

use strict;
use warnings;

use Test::More;

plan skip_all => 'unset AUTOMATED_TESTING to run this test'
    if $ENV{AUTOMATED_TESTING};
plan skip_all => 'Test::HasVersion required'
    unless eval 'use Test::HasVersion; 1';

all_pm_version_ok();
