use inc::Module::Install;
include 'Module::AutoInstall';

name 'Test-Compile';
all_from 'lib/Test/Compile.pm';
perl_version '5.006';

requires 'UNIVERSAL::require';
requires 'Devel::CheckOS' => '1.42';

test_requires 'Test::More' => '0.70';
extra_tests;

auto_install;
auto_include;
WriteAll;
