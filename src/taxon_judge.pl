#!/usr/bin/perl
use strict;
use warnings;
############
#This script is used to judge taxonomy of proteins.
############

my $dna = shift;
my $dir = shift;
my $taxon = shift;
my $taxon_hash = &get_home_lineage($taxon);
my $threads = 25;
my $db = "/histor/zhao/dulifeng/DataBase/Diamond_Protein_NR_2020/nr_with_taxomap_0.dmnd";
my $name = $dna;
$name =~ s/\.fna$//;
$name =~ s/.*\///;
#`diamond blastx --query $dna --db $db  --sensitive --evalue 1e-100 --threads $threads --out $dir/$name.blast --outfmt 6 staxids qseqid sseqid pident length mismatch gapopen qstart qend sstart send slen evalue bitscore`;
my $lca_file = "$dir/$name.lca";
my $lineage_file = "$dir/$name.lineage";
`taxonkit lca -s ";" -o $lca_file $dir/$name.blast`;
`taxonkit lineage -t -i 15 -o $lineage_file $lca_file`;

open(DI,"<$lineage_file") or die "Can not open $!\n";
while(<DI>){
	chomp;
	my ($staxids, $qseqid, $sseqid, $pident, $length, $mismatch, $gapopen, $qstart, $qend, $sstart, $send, $slen, $evalue, $bitscore, $lca, $tax_name, $lineage) = split(/\t/,$_);
	next if $pident < 60;
	next if $send ne $slen;
	next unless &judge_taxon($lca,$lineage);
	die "wrong\n" if $sstart > $send;
	my $pos = 0;
	my $out = ';';
	if($qstart<$qend){
		$out = &obtain_stop_codon($dna,$qseqid,$qend);
		$out = uc($out);
	}else{
		$out = &obtain_stop_codon($dna,$qseqid,$qend-4);
		$out = reverse_complement($out);
		$out = uc($out);
	}
	print "$out\t$qseqid\t$sseqid\t$qend\n";
}
close DI;

sub obtain_stop_codon{
	my $dna = shift;
	my $query = shift;
	my $position = shift;
	my $seq = '';
	open(IN,"<$dna") or die "Can not open $!\n";
	while(<IN>){
		if($_=~/>$query/){
			while(my $a=<IN>){
				last if $a=~/\>/;
				chomp $a;
				$seq = $seq . $a;
			}
		}
	}
	close IN;
	$seq = uc($seq);
	return substr($seq,$position,3);
}	
sub reverse_complement{
	my $seq = shift;
	$seq =~ tr/atcguATCGU/tagcaTAGCA/;
	my $re = reverse $seq;
	return $re;
}

sub judge_taxon{
	my $lca = shift;
	my $lineage = shift;
	my @taxon_list = split(/;/,$lineage);
	if(defined $taxon_hash -> {$lca}){
		return 1;
	}
	foreach my $i(@taxon_list){
		if($i==$taxon){
			return 1;
		}
	}
	return 0;
}

sub get_home_lineage{
	my $taxon = shift;
	my $tmp_taxon = `echo $taxon | taxonkit lineage -t`;
	chomp $tmp_taxon;
	my ($a,$b,$c) = split(/\t/,$tmp_taxon);
	my @d = split (/;/,$c);
	my %hash;
	foreach(@d){
		$hash{$_} = 1;
	}
	return \%hash;
}
