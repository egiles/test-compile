#!perl

use strict;
use warnings;

use Test::Compile;
use Test::Compile::Internal;

use Test::More ;

my $internal = Test::Compile::Internal->new();

my $TAINT = $internal->_is_in_taint_mode('t/scripts/taint.pl');
is($TAINT,"T","Found taint flag");

my $taint = $internal->_is_in_taint_mode('t/scripts/CVS/taint2.pl');
is($taint,"t","Found taint warning flag");

my $not = $internal->_is_in_taint_mode('t/scripts/subdir/success.pl');
is($not,"","No taint found in notaint.pl");

done_testing();
