#!perl
sub h{$x=pop;while($x=~/(\d)(\s*)(?=\d)/g){$f=$1;$s=$2;$'=~/^(.)/;$x=~s/$f$s$1/ $s / if$f+$1==10||$f==$1}$x}sub v{$y=pop;@e=();for$i(0..8){$l='';$l.=substr$y,$i+$_*9,1for 0..$w;push@e,h$l}$y='';for$i(0..$w){$y.=substr$_,$i,1for@e}$y}($c=join'',<>)=~s/\n//g;$w=$c=~y///c/9-1;while($,ne$c){$,=$c;$c=v h$,}print/\d/?"$_\n":''for$,=~/[ \d]{9}/g