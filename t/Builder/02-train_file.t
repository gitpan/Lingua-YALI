use Test::More tests => 2;
use Test::Exception;
use File::Basename;


BEGIN { use_ok('Lingua::YALI::Builder') };
my $builder = Lingua::YALI::Builder->new(ngrams=>[2,3,4]);

is($builder->train_file(dirname(__FILE__) . "/../Identifier/aaa01.txt"), 1, "training on input");
