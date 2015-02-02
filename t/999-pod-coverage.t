#!perl

use strict;
use warnings;

use Test::More;

plan skip_all => 'unset AUTOMATED_TESTING to run this test'
    if $ENV{AUTOMATED_TESTING};
plan skip_all => 'Test::Pod::Coverage required'
    unless eval 'use Test::Pod::Coverage; 1';

# Pod::Find doesn't use require() but traverses @INC manually. *sigh*
BEGIN { unshift @INC, @Devel::SearchINC::inc if @Devel::SearchINC::inc }
all_pod_coverage_ok();
