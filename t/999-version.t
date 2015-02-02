#! perl

use strict;
use warnings;

use Test::More;

plan skip_all => 'unset AUTOMATED_TESTING to run this test'
    if $ENV{AUTOMATED_TESTING};
plan skip_all => "Test::ConsistentVersion required for checking versions"
    unless eval "use Test::ConsistentVersion; 1";

Test::ConsistentVersion::check_consistent_versions(no_readme => 1, no_pod =>1);

