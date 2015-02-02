#!perl

use strict;
use warnings;

use Test::More;

plan skip_all => 'unset AUTOMATED_TESTING to run this test'
    if $ENV{AUTOMATED_TESTING};
plan skip_all => 'Test::Synopsis required'
    unless eval 'use Test::Synopsis; 1';

all_synopsis_ok('lib');
