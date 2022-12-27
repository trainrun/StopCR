#!/usr/bin/perl
use strict; 
use warnings;
############
#This script is used to translate DNA sequences into six-frame protein sequences.
############

my %aacode = (
"TTT" => "F", "TTC" => "F", "TTA" => "L", "TTG" => "L",
"TCT" => "S", "TCC" => "S", "TCA" => "S", "TCG" => "S",
"TAT" => "Y", "TAC" => "Y", "TAA" => "X", "TAG" => "X",
"TGT" => "C", "TGC" => "C", "TGA" => "X", "TGG" => "W",
"CTT" => "L", "CTC" => "L", "CTA" => "L", "CTG" => "L",
"CCT" => "P", "CCC" => "P", "CCA" => "P", "CCG" => "P",
"CAT" => "H", "CAC" => "H", "CAA" => "Q", "CAG" => "Q",
"CGT" => "R", "CGC" => "R", "CGA" => "R", "CGG" => "R",
"ATT" => "I", "ATC" => "I", "ATA" => "I", "ATG" => "M",
"ACT" => "T", "ACC" => "T", "ACA" => "T", "ACG" => "T",
"AAT" => "N", "AAC" => "N", "AAA" => "K", "AAG" => "K",
"AGT" => "S", "AGC" => "S", "AGA" => "R", "AGG" => "R",
"GTT" => "V", "GTC" => "V", "GTA" => "V", "GTG" => "V",
"GCT" => "A", "GCC" => "A", "GCA" => "A", "GCG" => "A",
"GAT" => "D", "GAC" => "D", "GAA" => "E", "GAG" => "E",
"GGT" => "G", "GGC" => "G", "GGA" => "G", "GGG" => "G",
); # this is the hash table for the amino acids
my $name;
my $seq = '';
while(<>){
	chomp;
	next if /^\s*$/;
	if(/^>/){
		if(defined $name){

			&print_six_frame($name,uc($seq)) if (length($seq)>=500 && length($seq)<=300000);
		}
		$name = $_;
		$name =~ s/\s.*//;
		$seq = '';
	}else{
		$seq .= $_;
	}
}
&print_six_frame($name,uc($seq));

sub print_six_frame{
	my $name=shift;
	my $seq=shift;
	my $seq2 = $seq;
	my @li=unpack("(A3)*",$seq2);
	my $prot1 = &translate(\@li);
	$seq2 = substr($seq,1);
	@li=unpack("(A3)*",$seq2);
	my $prot2 = &translate(\@li);
	$seq2 = substr($seq,2);
	@li=unpack("(A3)*",$seq2);
	my $prot3 = &translate(\@li);
	my $reverse = &reverse_complement($seq);
	@li=unpack("(A3)*",$reverse);
	my $prot4 = &translate(\@li);
	$seq2 = substr($reverse,1);
	@li=unpack("(A3)*",$seq2);
	my $prot5 = &translate(\@li);
	$seq2 = substr($reverse,2);
	@li=unpack("(A3)*",$seq2);
	my $prot6 = &translate(\@li);
	print $name . "_____1\n" . $prot1 . "\n" . $name . "_____2\n" . $prot2 . "\n" . $name . "_____3\n" . $prot3 . "\n" . $name . "_____4\n" . $prot4 . "\n" . $name . "_____5\n" . $prot5 . "\n" . $name . "_____6\n" . $prot6 . "\n";
}

sub translate{
	my $list=shift;
	my $prot = '';
	foreach(@$list){
		$prot=$prot . $aacode{$_} if (length($_)==3);
	}
	return $prot;
}

sub reverse_complement{
	my $seq = shift;
	$seq =~ tr/atcguATCGU/tagcaTAGCA/;
	my $re = reverse $seq;
	return $re;
}
	
	
