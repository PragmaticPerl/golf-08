use strict;
use warnings;
use Test::More;
use Capture::Tiny qw(capture_stdout);

my @data =
  map { s/^(.+)\n//; [ $1, split /==\n/ ] } grep { length } split /\@\@\s/,
  do { local $/; <DATA> };

for my $script (<script/*.pl>) {
    next if $script eq 'script/example.pl';
    diag("Testing $script");
    for my $data (@data) {
        is capture_stdout {
            my $pid = open my $fh, '|-';
            if ($pid) {
                print $fh $data->[1];
                close $fh;
                waitpid $pid, 0;
            }
            elsif ( $pid == 0 ) {
                { exec $^X, $script; }
                BAIL_OUT("Can't run $script");
            }
            else {
                BAIL_OUT("Can't fork");
            }
        }, $data->[2], $data->[0];
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
@@
