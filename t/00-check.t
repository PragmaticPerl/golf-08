use strict;
use warnings;
use Test::More;
use Capture::Tiny qw(capture_stdout);

my @data = grep { length $_ } split /\@\@\s/, do { local $/; <DATA> };

for my $data (@data) {
    $data =~ s/^(.+)\n//;
    my $name = $1;
    my ($in, $out) = split /==\n/, $data;
    is capture_stdout {
        my $pid = open my $fh, '|-', 'script/digits.pl'
            or BAIL_OUT("Can't run digits.pl");
        print $fh $in;
        close $fh;
        waitpid $pid,0;
    }, $out, $name;
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
