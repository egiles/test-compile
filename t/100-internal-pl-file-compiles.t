#!perl

use strict;
use warnings;

use Config;
use Test::More;
use Test::Compile::Internal;

my $internal = Test::Compile::Internal->new();
$internal->verbose(0);

# Is this perl capable of checking taint?
my $perl_can_check_taint = $Config{taint_disabled} ? 0 : 1;

# Given (success.pl)
# When
my $yes = $internal->pl_file_compiles('t/scripts/subdir/success.pl');
# Then
is($yes, 1, "success.pl should compile");

# Given (taint.pl - script has -t in shebang)
# When
my $taint = $internal->pl_file_compiles('t/scripts/taint.pl');
# Then
is($taint, $perl_can_check_taint, "taint.pl should compile, with -T");

# Given (taint2.pl - script has -T in shebang)
# When
my $taint2 = $internal->pl_file_compiles('t/scripts/CVS/taint2.pl');
# Then
is($taint2, $perl_can_check_taint, "taint2.pl should compile, with -t");

# Given (failure.pl doesn't compile)
# When
my $failure = $internal->pl_file_compiles('t/scripts/failure.pl');
# Then
is($failure, 0, "failure.pl should not compile");

# Given (no_file_here.pl doesn't exist)
# When
my $not_found = $internal->pl_file_compiles('t/scripts/no_file_here.pl');
# Then
is($not_found, 0, "no_file_here.pl should not compile");


done_testing();
