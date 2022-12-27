#!/usr/bin/perl
use strict;
use warnings;
############
#This script is used to count codon termination events.
############

my %code;
my %redu;
while(<>){
	chomp;
	my @a = split(/\t/,$_);
	my $id = $a[0] . '_' . $a[1] . '_' . $a[3];
	next if (defined $redu{$id});
	$redu{$id} = 1;
	if(defined $code{$a[0]}){
		$code{$a[0]}++;
	}else{
		$code{$a[0]} = 1;
	}
}
foreach(sort keys %code){
	print "$_\t$code{$_}\n";
}