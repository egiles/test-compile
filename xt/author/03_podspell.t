#!perl -w

use strict;
use warnings;
use Test::Spelling;
use utf8;

add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
all_pod_files_spelling_ok('lib');

__DATA__
API
CPAN
Grünauer
Marcel
behaviour
chomps
github
init
op
pipe's
ref
segment's
unshifts
