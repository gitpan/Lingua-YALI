use Test::More tests => 2;
use Test::Exception;
use File::Basename;


BEGIN { use_ok('Lingua::YALI::Builder') };
my $builder = Lingua::YALI::Builder->new(ngrams=>[2,3,4]);

open(my $fh_a, "<:bytes", dirname(__FILE__) . "/../Identifier/aaa01.txt") or croak $!;

is($builder->train_handler($fh_a), 1, "training on input");
