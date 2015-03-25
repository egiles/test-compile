#!perl -w
use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Compile;
Test::Compile::_verbose(0);

my @METHODS = qw(
    pm_file_ok
    pl_file_ok

    all_files_ok
    all_pm_files_ok
    all_pl_files_ok

    all_pm_files
    all_pl_files
);

plan tests => 2 * @METHODS + 2;

# try to use the methods, despite not exporting them
for my $m (@METHODS) {
    is(__PACKAGE__->can($m), undef, "$m not auto-imported");
} 

# now run (inherited) import by hand with specified method
Test::Compile->import('pl_file_ok');

lives_ok {
    pl_file_ok('t/scripts/subdir/success.pl', 'success.pl compiles');
} 'pl_file_ok imported correctly';

# finally use the "all" tag to import all methods and check if it worked
Test::Compile->import(':all');
for my $m (@METHODS) {
    is(__PACKAGE__->can($m), \&{ $m }, "$m imported via 'all' tag");
} 
