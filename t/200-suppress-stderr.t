#! /usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Compile;

# Make sure that calling 'pm_file_ok' on different modules
# that redefine the same function does NOT produce warnings
# ..because those warnings look like errors

# Given
pm_file_ok('t/scripts/Module.pm', 'Module compiles');

# When
my $warnings = 0;
{
    local $SIG{__WARN__} = sub {
        $warnings++;
    };
    pm_file_ok('t/scripts/Module2.pm', 'Module2 compiles');
}

# Then
is($warnings,0,"no warnings produced");

