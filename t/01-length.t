use strict;
use warnings;
use Test::More;
use Storable;

my $results = retrieve 'golf-08-check.out';

my $min    = 1e9;
my @winner = ('nobody');

for my $script (<script/*.pl>) {
    next if $script eq 'script/example.pl';
    if (!$results->{$script}) {
        $script =~ s/script\///;
        diag( sprintf "% 20s: failed tests, skipped", $script);
        next;
    }
    open my $fh, '<', $script or BAIL_OUT();
    my $shebang = <$fh>;
    chomp $shebang;
    my $length = length do { local $/; <$fh> };
    close $fh;
    $script =~ s/script\///;
    diag( sprintf "% 20s: shebang=% 20s length=% 3s",
        $script, $shebang, $length );
    pass();

    if ( $min > $length ) {
        @winner = ($script);
        $min    = $length;
    }
    elsif ( $min == $length ) {
        push @winner, $script;
    }
}

diag( "And the oscar goes to " . join ", ", @winner );

done_testing();
