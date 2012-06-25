use Test::More tests => 2;
use Time::HiRes;

BEGIN { use_ok('Lingua::YALI::Builder') };

my $builder = Lingua::YALI::Builder->new(ngrams=>[2,3,4]);

my $ngrams = $builder->get_ngrams();
is((scalar @$ngrams), 3, "3 different n-grams");