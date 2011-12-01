#! /usr/bin/perl

use strict;
use warnings;

use Module::Build;

my $repo = "github.com/egiles/test-compile";
my $meta1 = "http://$repo";
my $meta2 = {
    type => "git",
    web => $meta1,
    url => "git://$repo.git",
};

my $build = Module::Build->new (
     module_name => 'Test::Compile',
     abstract_from => 'lib/Test/Compile.pm',
     dist_author => 'Evan Giles <egiles@cpan.org>',
     license  => 'perl',
     requires => {
        'perl'               => '5.6.0',
        'UNIVERSAL::require' => 0,
     },
     create_makefile_pl => 'traditional',
     meta_merge     => {
       resources => {
         repository => Module::Build->can("metafile2") ? $meta2 : $meta1,
       }
     },
     add_to_cleanup => [ 'Makefile.PL', 'META.yml' ],
);
$build->create_build_script;

