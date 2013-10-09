use strict;
use warnings;
use Test::More;
use IPC::Run qw( start finish );
use Storable;

my @data =
  map { s/^(.+)\n//; [ $1, split /==\n/ ] } grep { length } split /\@\@\s/,
  do { local $/; <DATA> };

sub run_test {
    my ($script,$stdin,$expected,$msg) = @_;
    my ($in, $out);
    my $h = start ['perl', $script], \$in, \$out;
    $in .= $stdin;
    finish($h);
    is $out, $expected, $msg;
}

sub make_long_field {
    my $long_in  = "712345674\n";
    my $long_out = " 12345674\n";
    for (0..300) {
        $long_in  .= "523456789\n534567894\n";
        $long_out .= " 23456789\n 34567894\n";
    }
    $long_in  .= "891779657\n";
    $long_out .= "     9657\n";
    for (0..200) {
        $long_in  .= "523456789\n534567894\n";
        $long_out .= " 23456789\n 34567894\n";
    }
    $long_in  .= "291779657\n";
    $long_out .= "     9657\n";
    for (0..300) {
        $long_in  .= "523456789\n534567894\n";
        $long_out .= " 23456789\n 34567894\n";
    }
    $long_in  .= "313459339\n";
    $long_out .= " 1345    \n";
    return $long_in, $long_out;
}


my %results;
for my $script (<script/*.pl>) {
    next if $script eq 'script/example.pl';
    diag("Testing $script");
    my @t = ();
    for my $data (@data) {
        push @t, run_test($script,$data->[1],$data->[2],$data->[0]);
    }

    my ($long_in, $long_out) = make_long_field();
    push @t, run_test($script,$long_in,$long_out,"long field");

    $results{$script} = 1;
    map {$results{$script} *= $_ } @t;
}

done_testing;

store \%results, 'golf-08-check.out';

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
@@ long horizontal 2
121212121
355555555
212121212
==
121212121
3        
212121212
@@ long horizontal and long vertical
212121212
777777779
555555554
898989897
==
        2
        9
        4
        7
@@ square
212121255
787878755
454545498
==
2121212  
7878787  
454545498
@@ square 2
454545498
312121255
687878755
==
454545498
3121212  
6878787  
@@ square 3
124545498
553121261
554878787
==
124545498
  3121261
  4878787
@@ cross
127126345
678772612
361559787
126987135
==
127  6345
67    612
36    787
126  7135
@@ cross 2
125125345
658772512
341559487
136984135
==
12    345
6      12
3      87
13    135
@@ cross 3
125125845
758772532
941559416
236984751
==
1      45
        2
        6
2      51
@@
