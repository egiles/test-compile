use inc::Module::Install;
include 'Module::AutoInstall';

name 'Test-Compile';
all_from 'lib/Test/Compile.pm';
perl_version '5.006';

requires 'UNIVERSAL::require';
requires 'Devel::CheckOS' => '1.42';

build_requires 'Test::More' => '0.70';
build_requires 'Test::Pod';
build_requires 'Test::Pod::Coverage';

process_templates(
    first_year => 2007,
    rest_from  => "$ENV{HOME}/.mitlib/standard_pod",
    start_tag  => '{%',
    end_tag    => '%}',
    other_authors => [
        'Sagar R. Shah C<< <srshah@cpan.org> >>',
    ],
);

auto_install;
auto_include;
WriteAll;
