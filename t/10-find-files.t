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
  is(scalar @files,3,"Found correct number of scripts");
  like($files[0],qr/failure.pl/,"Found the failure script");
  like($files[1],qr/success.pl/,"Found the success script");
  like($files[2],qr/tainted.pl/,"Found the tainted script");
}

sub test_all_pm_files {
  my @files = sort (all_pm_files('t/scripts'));
  is(scalar @files,1,"Found correct number of modules");
  like($files[0],qr/Module.pm/,"Found the module file");
}

test_all_pl_files();
test_all_pm_files();
done_testing();
