use inc::Module::Install;
name 'Test-Compile';
all_from 'lib/Test/Compile.pm';

build_requires 'Test::More';

use_standard_tests;
auto_include;
WriteAll;
