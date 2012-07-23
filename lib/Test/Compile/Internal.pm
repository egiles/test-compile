package Test::Compile::Internal;

use 5.006;
use warnings;
use strict;

use Test::Builder;
use File::Spec;
use UNIVERSAL::require;

our $VERSION = '0.19';

=head1 NAME

Test::Compile::Internal - Internal workings for Test::Compile

=head1 SYNOPSIS

    use Test::Compile::Internal;
    my $tci = Test::Compile::Internal->new();
    $tci->all_files_ok();
    $tci->done_testing();

=head1 DESCRIPTION

Don't use this module directly, it is BETA software, and subject to change

=head1 METHODS

=over 4

=item C<new()>

A basic constructor, nothing special.
=cut

sub new {
    my ($class,%self) = @_;
    my $self = \%self;

    $self->{test} ||= Test::Builder->new();

    bless ($self, $class);
    return $self;
}

=item C<all_files_ok([@dirs])>

Checks all the perl files it can find for compilation errors.

=cut
sub all_files_ok {
    my ($self,@queue) = @_;

    my $test = $self->{test};

    for my $file ( $self->all_pl_files(@queue) ) {
        my $ok = $self->_pl_file_compiles($file);
        $test->ok($ok,"$file compiles");
    }

    for my $file ( $self->all_pm_files(@queue) ) {
        my $ok = $self->_pm_file_compiles($file);
        $test->ok($ok,"$file compiles");
    }
}

=item C<done_testing()>

Calls Test::Builder::done_testing

=cut

sub done_testing {
    my ($self) = @_;
    my $test = $self->{test};
    $test->done_testing();
}

=item C<all_pm_files([@dirs])>

Returns a list of all the perl module files - that is, files ending in F<.pm>
- in I<$dir> and in directories below. If no directories are passed, it
defaults to F<blib> if F<blib> exists, or else F<lib> if not. Skips any files
in C<CVS> or C<.svn> directories.

The order of the files returned is machine-dependent. If you want them
sorted, you'll have to sort them yourself.
=cut

sub all_pm_files {
    my ($self,@queue) = @_;

    @queue = @queue ? @queue : _pm_starting_points();

    my @pm;
    for my $file ( $self->_find_files(@queue) ) {
        if (-f $file) {
            push @pm, $file if $file =~ /\.pm$/;
        }
    }
    return @pm;
}

=item C<all_pl_files([@files/@dirs])>

Returns a list of all the perl script files - that is, files ending in F<.pl>
or with no extension. Directory arguments are searched recursively . If
arguments are passed, it defaults to F<script> if F<script> exists, or else
F<bin> if F<bin> exists. Skips any files in C<CVS> or C<.svn> directories.

The order of the files returned is machine-dependent. If you want them
sorted, you'll have to sort them yourself.

=back
=cut

sub all_pl_files {
    my ($self,@queue) = @_;

    @queue = @queue ? @queue : _pl_starting_points();

    my @pl;
    for my $file ( $self->_find_files(@queue) ) {
        if (defined($file) && -f $file) {
            # Only accept files with no extension or extension .pl
            push @pl, $file if $file =~ /(?:^[^.]+$|\.pl$)/;
        }
    }
    return @pl;
}

sub _pl_file_compiles {
    my ($self,$file) = @_;
    my $ok = $self->_run_in_subprocess(sub{$self->_check_syntax($file,0)});
}
sub _pm_file_compiles {
    my ($self,$file) = @_;
    my $ok = $self->_run_in_subprocess(sub{$self->_check_syntax($file,1)});
}

sub _run_in_subprocess {
    my ($self,$closure,$verbose) = @_;

    my $pid = fork();
    if ( ! defined($pid) ) {
        return 0;
    } elsif ( $pid ) {
        wait();
        return ($? ? 0 : 1);
    } else {
        if ( !$verbose ) {
            open STDERR, '>', File::Spec->devnull;
        }
        my $rv = $closure->();
        exit ($rv ? 0 : 1);
    }
}

sub _check_syntax {
    my ($self,$file,$require) = @_;

    if (-f $file) {
        if ( $require ) {
            my $module = $file;
            $module =~ s!^(blib[/\\])?lib[/\\]!!;
            $module =~ s![/\\]!::!g;
            $module =~ s/\.pm$//;
    
            $module->use;
            return ($@ ? 0 : 1);
        } else {
            my @perl5lib = split(':', ($ENV{PERL5LIB}||""));
            my $taint = $self->_is_in_taint_mode($file);
            unshift @perl5lib, 'blib/lib';
            system($^X, (map { "-I$_" } @perl5lib), "-c$taint", $file);
            return ($? ? 0 : 1);
        }
    }
}

sub _find_files {
    my ($self,@queue) = @_;

    for my $file (@queue) {
        if (defined($file) && -d $file) {
            local *DH;
            opendir DH, $file or next;
            my @newfiles = readdir DH;
            closedir DH;
            @newfiles = File::Spec->no_upwards(@newfiles);
            @newfiles = grep { $_ ne "CVS" && $_ ne ".svn" } @newfiles;
            for my $newfile (@newfiles) {
                my $filename = File::Spec->catfile($file, $newfile);
                if (-f $filename) {
                    push @queue, $filename;
                } else {
                    push @queue, File::Spec->catdir($file, $newfile);
                }
            }
        }
    }
    return @queue;
}

sub _pm_starting_points {
    return 'blib' if -e 'blib';
    return 'lib';
}

sub _pl_starting_points {
    return 'script' if -e 'script';
    return 'bin'    if -e 'bin';
}

sub _is_in_taint_mode {
    my ($self,$file) = @_;

    open(my $f, "<", $file) or die "could not open $file";
    my $shebang = <$f>;
    my $taint = "";
    if ($shebang =~ /^#![\/\w]+\s+\-w?([tT])/) {
        $taint = $1;
    }
    return $taint;
}

1;
__END__


=head1 AUTHORS

Sagar R. Shah C<< <srshah@cpan.org> >>,
Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>,
Evan Giles, C<< <egiles@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2012 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Test::LoadAllModules> just handles modules, not script files, but has more
fine-grained control.

=cut
