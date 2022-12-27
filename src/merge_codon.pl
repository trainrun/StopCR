#!/usr/bin/perl
use strict;
use warnings;
my $dir = shift;
my @file = `ls $dir`;
my @seq = split("",'-' x (scalar(@file) * 3));
my $name = ">a";
my $id = 0;
my $pos = 0;
foreach my $f(@file){
	open(IN,"<$dir/$f") or die "Can not open $!\n";
	while(<IN>){
		my ($a,$b) = split(/\t/,$_);
		my ($c,$d) = split(/--/,$a);
		for(my $i=0;$i<$b;$i++){
			$id++;
			my @s = @seq;
			if($c eq 'TAA'){
				$s[$pos] = $d;
			}
			if($c eq 'TGA'){
				$s[$pos+1] = $d;
			}
			if($c eq 'TAG'){
				$s[$pos+2] = $d;
			}
			my $merge = join("",@s);
			print $name . $id . "\n" . $merge . "\n";
		}		
	}
	close IN;
	$pos += 3;
}	
