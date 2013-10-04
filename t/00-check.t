use strict;
use warnings;
use Test::More;
use IPC::Run qw( start finish );

my @data =
  map { s/^(.+)\n//; [ $1, split /==\n/ ] } grep { length } split /\@\@\s/,
  do { local $/; <DATA> };

for my $script (<script/*.pl>) {
    next if $script eq 'script/example.pl';
    diag("Testing $script");
    for my $data (@data) {
    my ($in, $out);
    my $h = start ['perl', $script], \$in, \$out;
        $in .= $data->[1];
        finish($h);
        is $out, $data->[2], $data->[0];
    }
}

done_testing;

__DATA__
@@ nothing
 234567  
    1314 
51617181 
==
 234567  
    1314 
51617181 
@@ 1h+1v
112345678
345867923
==
  23 5678
3458 7923
@@ empty line
121212123
333333333
454545454
==
12121212 
454545454
@@ long vertical
123123123
4 5454545
1 2312312
425454545
==
1 3123123
4 5454545
1 2312312
4 5454545
@@ double check
128134343
434343434
==
    34343
434343434
@@ long vertical 2
231231232
 54545454
 23123121
254545454
==
 31231232
 54545454
 23123121
 54545454
@@ long vertical 3
131231232
45454545 
12312312 
454545452
==
13123123 
45454545 
12312312 
45454545 
@@ long horizontal
121212125
238777793
454545454
==
121212125
238    93
454545454
@@ square
212121255
787878755
454545498
==
2121212  
7878787  
454545498
@@
