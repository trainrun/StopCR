#!/usr/bin/perl
use strict; 
use warnings;
my %stop;
my $text = shift;
my $prot = shift;
open(IN,"<$text") or die "Can not open $_ \n";	
while(<IN>){
	chomp;
	if(/\Q  == domain /){
		my $ref = <IN>;
		chomp $ref;
		my @ref_list = split(/\s+/,$ref);
		while(scalar(@ref_list)<5){
			$ref = <IN>;
			chomp $ref;
			@ref_list = split(/\s+/,$ref);
		}
		my $query = <IN>;
		$query = <IN>;
		chomp $query;
		my @query_list = split(/\s+/,$query);
#		$ref_list[3] = uc $ref_list[3];
#		$query_list[3] = uc $query_list[3];
		#print "$ref_list[3]\n";
		
		my @ref_seq = split("",$ref_list[3]);
		my @query_seq = split("",$query_list[3]);
		my $pos = 0;
		for(my $i=0;$i<scalar(@ref_seq);$i++){
			$pos++ if $query_seq[$i] eq '-';
			if($query_seq[$i] eq 'X'){
				print "$ref\n$query\n" if $ref_seq[$i] eq $prot;
			}
		}
	}
}

