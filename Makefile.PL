use inc::Module::Install;
name 'Test-Compile';
all_from 'lib/Test/Compile.pm';
perl_version '5.006';

requires 'UNIVERSAL::require';

build_requires 'Test::More' => '0.70';

use_standard_tests;
auto_include;
WriteAll;
