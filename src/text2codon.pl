#!/usr/bin/perl
use strict; 
use warnings;
my %stop;
my $fasta = shift;
my $text = shift;
open(IN,"<$fasta") or die "Can not open $_ \n";
my $name = 'tmp';
my %fast_hash;
while(<IN>){
	chomp;
	next if /^\s*$/;
	if(/^>/){
		$name = $_;
		$name =~ s/\s.*//;
		$name =~ s/^>//;
		$fast_hash{$name} = '';
	}else{
		$fast_hash{$name} .= $_;
	}
}
close IN;

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
#				if(defined $stop{$ref_seq[$i]}){
#					$stop{$ref_seq[$i]}++;
#				}else{
#					$stop{$ref_seq[$i]} = 1;
#				}
				&found_codon($query_list[2]+$i-$pos,$query_list[1],$ref_seq[$i]) if $ref_seq[$i]=~/[A-Z]/;
			}
		}
	}
}

sub found_codon{
	my $position = shift;
	my $name = shift;
	my $prot = shift;
	my ($a,$b) = split(/_____/,$name);
	#print "$name\t$a\t$b\n";
	my $seq = $fast_hash{$a};
	my $reverse = &reverse_complement($seq);
	my $codon;
	if($b==1){
		$codon=substr($seq,$position*3-3,3);
	}
	if($b==2){
		$codon=substr($seq,$position*3-2,3);
	}
	if($b==3){
		$codon=substr($seq,$position*3-1,3);
	}
	if($b==4){
		$codon=substr($reverse,$position*3-3,3);
	}
	if($b==5){
		$codon=substr($reverse,$position*3-2,3);
	}
	if($b==6){
		$codon=substr($reverse,$position*3-1,3);
	}
	
	my $t = uc($codon) . '--' . $prot;
	if(defined $stop{$t}){
		$stop{$t}++
	}else{
		$stop{$t}=1;
	}
}	
sub reverse_complement{
	my $seq = shift;
	$seq =~ tr/atcguATCGU/tagcaTAGCA/;
	my $re = reverse $seq;
	return $re;
}

foreach(keys %stop){
	print "$_\t$stop{$_}\n";
}