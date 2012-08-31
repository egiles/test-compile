package Test::Compile;

use 5.006;
use warnings;
use strict;

use Test::Builder;
use UNIVERSAL::require;
use Test::Compile::Internal;

our $VERSION = '0.21';
my $Test = Test::Compile::Internal->new();

=head1 NAME

Test::Compile - Check whether Perl files compile correctly.

=head1 SYNOPSIS

    use Test::Compile;
    all_pm_files_ok();

=head1 DESCRIPTION

C<Test::Compile> lets you check the whether your perl modules and scripts
compile properly, and report its results in standard C<Test::Simple> fashion.

The basic useage - as shown above, will find all pm files and test that they
all compile.

You can explicitly specify the list of directories to check, using
the C<all_pm_files()> function supplied:

    my @pmdirs = qw(blib script);
    all_pm_files_ok(all_pm_files(@pmdirs));

=cut

sub import {
    my $self   = shift;
    my $caller = caller;
    for my $func (
        qw(
        pm_file_ok pl_file_ok all_pm_files all_pl_files all_pm_files_ok
        all_pl_files_ok
        )
      ) {
        no strict 'refs';
        *{ $caller . "::" . $func } = \&$func;
    }
    $Test->exported_to($caller);
    $Test->plan(@_);
}

=head1 FUNCTIONS

=over 4

=item C<all_pm_files_ok(@files)>

Checks all the files in C<@files> for compilation. It runs L</all_pm_files()>
on each file/directory, and calls the C<plan()> function for you (one test for
each module), so you can't have already called C<plan>.

If C<@files> is empty or not passed, the function finds all Perl module files
in the F<blib> directory if it exists, or the F<lib> directory if not. A Perl
module file is one that ends with F<.pm>.

Returns true if all Perl module files are ok, or false if any fail.

Module authors can include the following in a F<t/00_compile.t> file
and have C<Test::Compile> automatically find and check all Perl module files
in a module distribution:

    #!perl -w
    use strict;
    use warnings;
    use Test::More;
    eval "use Test::Compile";
    Test::More->builder->BAIL_OUT(
        "Test::Compile required for testing compilation") if $@;
    all_pm_files_ok();

=cut

sub all_pm_files_ok {
    my @files = @_ ? @_ : all_pm_files();
    $Test->plan(tests => scalar @files);
    my $ok = 1;
    for (@files) {
        pm_file_ok($_) or undef $ok;
    }
    $ok;
}

=item C<all_pl_files_ok(@files)>

Checks all the files in C<@files> for compilation. It runs L<pl_file_ok()>
on each file, and calls the C<plan()> function for you (one test for
each script), so you can't have already called C<plan>.

If C<@files> is empty or not passed, the function uses all_pl_files() to find
scripts to test.

Returns true if all Perl module files are ok, or false if any fail.

Module authors can include the following in a F<t/00_compile_scripts.t> file
and have C<Test::Compile> automatically find and check all Perl module files
in a module distribution:

    #!perl -w
    use strict;
    use warnings;
    use Test::More;
    eval "use Test::Compile";
    plan skip_all => "Test::Compile required for testing compilation"
      if $@;
    all_pl_files_ok();

=cut

sub all_pl_files_ok {
    my @files = @_ ? @_ : all_pl_files();
    $Test->skip_all("no pl files found") unless @files;
    $Test->plan(tests => scalar @files);
    my $ok = 1;
    for (@files) {
        pl_file_ok($_) or undef $ok;
    }
    $ok;
}

=item C<pm_file_ok($filename,$testname)>

C<pm_file_ok()> will okay the test if $filename compiles as a perl module.

The optional second argument C<$testname> is the name of the test. If it is
omitted, C<pm_file_ok()> chooses a default test name C<Compile test for
$filename>.

=cut
sub pm_file_ok {
    my ($file,$name) = @_;

    $name ||= "Compile test for $file";

    my $ok = $Test->pm_file_compiles($file);

    $Test->ok($ok, $name);
    $Test->diag("$file does not compile") unless $ok;
    return $ok;
}

=item C<pl_file_ok($filename,$testname)>

C<pl_file_ok()> will okay the test if $filename compiles as a perl script. You
need to give the path to the script relative to this distribution's base
directory. So if you put your scripts in a 'top-level' directory called script
the argument would be C<script/filename>.

The optional second argument C<$testname> is the name of the test. If it is
omitted, C<pl_file_ok()> chooses a default test name C<Compile test for
$filename>.
=cut

sub pl_file_ok {
    my ($file,$name) = @_;

    $name ||= "Compile test for $file";

    # don't "use Devel::CheckOS" because Test::Compile is included by
    # Module::Install::StandardTests, and we don't want to have to ship
    # Devel::CheckOS with M::I::T as well.
    if (Devel::CheckOS->require) {

        # Exclude VMS because $^X doesn't work. In general perl is a symlink to
        # perlx.y.z but VMS stores symlinks differently...
        unless (Devel::CheckOS::os_is('OSFeatures::POSIXShellRedirection')
            and Devel::CheckOS::os_isnt('VMS')) {
            $Test->skip('Test not compatible with your OS');
            return;
        }
    }

    my $ok = $Test->pl_file_compiles($file);

    $Test->ok($ok, $name);
    $Test->diag("$file does not compile") unless $ok;
    return $ok;
}

=item C<all_pm_files(@dirs)>

Returns a list of all the perl module files - that is, files ending in F<.pm>
- in I<@dirs> and in directories below. If no directories are passed, it
defaults to F<blib> if F<blib> exists, or else F<lib> if not. Skips any files
in C<CVS> or C<.svn> directories.

The order of the files returned is machine-dependent. If you want them
sorted, you'll have to sort them yourself.

=cut

sub all_pm_files {
    return $Test->all_pm_files(@_);
}

=item C<all_pl_files(@dirs)>

Returns a list of all the perl script files - that is, files ending in F<.pl>
or with no extension. Directory arguments are searched recursively . If
I<@dirs> is undefined, it defaults to F<script> if F<script> exists, or else
F<bin> if F<bin> exists. Skips any files in C<CVS> or C<.svn> directories.

The order of the files returned is machine-dependent. If you want them
sorted, you'll have to sort them yourself.

=back
=cut

sub all_pl_files {
    return $Test->all_pl_files(@_);
}

1;

=head1 AUTHORS

Sagar R. Shah C<< <srshah@cpan.org> >>,
Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>,
Evan Giles, C<< <egiles@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2012 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Test::Compile::Internal> provides an object oriented interface to the
Test::Compile functionality.
L<Test::Strict> proveds functions to ensure your perl files comnpile, with
added bonus that it will check you have used strict in all your files.
L<Test::LoadAllModules> just handles modules, not script files, but has more
fine-grained control.


=cut
