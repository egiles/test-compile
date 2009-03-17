#!perl -w

use strict;
use warnings;
use Test::Spelling;
use utf8;

add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
all_pod_files_spelling_ok('lib');

__DATA__
AOP
API
Achim
Adam
AspectJ
CPAN
Conway
Coro
Damian
DateTime
Eilam
Ekker
Florian
Grünauer
Heinz
Helmberger
Hofstetter
MVC
Marcel
Mark
Miyagawa
OO
OOP
PARC
Ran
ShipIt
Spiffy
Takesako
Tatsuhiko
W3CDTF
YAML
behaviour
blog
blogs
callback
chomps
configurator
configurators
crosscutting
distname
github
init
op
pipe's
placeholders
pointcut
pointcuts
redispatch
ref
san
segment's
shipit
tokenizes
unshifts
username
whitelist
whitelists
wormhole
yml
