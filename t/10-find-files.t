#! /usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Compile;

sub test_all_pl_files {
  # GIVEN

  # WHEN
  my @files = sort (all_pl_files('t/scripts'));

  # THEN
  is(scalar @files,4,"Found correct number of scripts");
  like($files[0],qr/failure.pl/,"Found the failure script");
  like($files[1],qr/lib.pl/,"Found the lib script");
  like($files[2],qr/success.pl/,"Found the success script");
  like($files[3],qr/taint.pl/,"Found the tainted script");
}

sub test_all_pm_files {
  my @files = sort (all_pm_files('t/scripts'));
  is(scalar @files,2,"Found correct number of modules");
  like($files[0],qr/Module.pm/,"Found the module file");
  like($files[1],qr/Module2.pm/,"Found the module2 file");
}

test_all_pl_files();
test_all_pm_files();
done_testing();
