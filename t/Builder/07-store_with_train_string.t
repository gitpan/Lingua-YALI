use Test::More tests => 12;
use Test::Exception;
use File::Basename;
use Carp;

my $rm_cmd ="rm -f " . dirname(__FILE__) . "/tmp.*";
`$rm_cmd`;

BEGIN { use_ok('Lingua::YALI::Builder') };
my $builder = Lingua::YALI::Builder->new(ngrams=>[2,3,4]);

open(my $fh_a, "<:bytes", dirname(__FILE__) . "/../Identifier/aaa01.txt") or croak $!;
my $a_string = "";
while ( <$fh_a> ) {
    $a_string .= $_;
}
is($builder->train_string($a_string), 1, "training on input");

my $file1W = dirname(__FILE__) . "/tmp.1.20.txt.gz";
dies_ok { $builder->store($file1W, 1, 20) } "asdadasd";
ok(! -f $file1W, "file $file1W was created");

my $file2W = dirname(__FILE__) . "/tmp.2.20.txt.gz";
my $file2E = dirname(__FILE__) . "/sol.2.20.txt.gz";
$builder->store($file2W, 2, 20);
ok(-f $file2W, "file $file2W was not created");

my $cmd_diff2 = "bash -c 'diff <(zcat $file2W) <(zcat $file2E) | wc -l'";
my $line2 = int(`$cmd_diff2`);
is ( $line2, 0, "Created file $file2W is different from $file2E");


my $file3W = dirname(__FILE__) . "/tmp.3.20.txt.gz";
my $file3E = dirname(__FILE__) . "/sol.3.20.txt.gz";
$builder->store($file3W, 3, 20);
ok(-f $file3W, "file $file3W was not created");

my $cmd_diff3 = "bash -c 'diff <(zcat $file3W) <(zcat $file3E) | wc -l'";
my $line3 = int(`$cmd_diff3`);
is ( $line3, 0, "Created file $file3W is different from $file3E");

my $file4W = dirname(__FILE__) . "/tmp.4.20.txt.gz";
my $file4E = dirname(__FILE__) . "/sol.4.20.txt.gz";
$builder->store($file4W, 4, 20);
ok(-f $file4W, "file $file4W was not created");

my $cmd_diff4 = "bash -c 'diff <(zcat $file4W) <(zcat $file4E) | wc -l'";
my $line4 = int(`$cmd_diff4`);
is ( $line4, 0, "Created file $file4W is different from $file4E");

my $file5W = dirname(__FILE__) . "/tmp.5.20.txt.gz";
dies_ok { $builder->store($file5W, 5, 20) } "file $file5W was created";
ok(! -f $file5W, "file $file5W was created");

`$rm_cmd`;