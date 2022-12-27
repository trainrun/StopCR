#!/usr/bin/perl
use strict;
use warnings;

my $name = ">a";
my $id = 0;

while(<>){
	chomp;
	my ($a,$b) = split(/\t/,$_);
	my ($c,$d) = split(/--/,$a);
	for(my $i=0;$i<$b;$i++){
		$id++;
		print $name . $id . "\n" . $d . '-' . '-' . "\n" if $c eq 'TAA';
		print $name . $id . "\n" . '-' . $d . '-' . "\n" if $c eq 'TGA';
		print $name . $id . "\n" . '-' . '-' . $d . "\n" if $c eq 'TAG';
	}
}