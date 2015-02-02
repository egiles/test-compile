#!perl

use strict;
use warnings;

use Test::More;

plan skip_all => 'unset AUTOMATED_TESTING to run this test'
    if $ENV{AUTOMATED_TESTING};
plan skip_all => 'Test::Portability::Files required'
    unless eval 'use Test::Portability::Files; 1';

run_tests();
