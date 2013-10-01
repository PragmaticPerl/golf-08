use strict;
use warnings;
use Test::More;

open my $fh, '<', 'script/digits.pl' or BAIL_OUT();
my $shebang = <$fh>;
chomp $shebang;
my $length  = length do { local $/; <$fh> };
close $fh;
diag(
      "\n"
    . "Shebang : $shebang\n"
    . " Length : $length\n"
);
pass();
done_testing();
