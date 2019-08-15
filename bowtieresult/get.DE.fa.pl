#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$gen);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"gene:s"=>\$gen,
	"out:s"=>\$fout,
			) or &USAGE;
&USAGE unless ($fout);

open IN,$fin;
my %seq;
$/ = ">";
while(<IN>){
	chomp;
	next if ($_ eq "" || /^$/);
	my ($chr,$seq) = split(/\n/,$_,2);
	$seq =~ s/\n//g;
	$seq{$chr} = $seq;
}
close IN;
$/ = "\n";
open In,$gen;
open Out,">$fout";
while (<In>) {
	chomp;
	#my ($gene,$trans)=split/\s+/,$_;
	if (exists $seq{$_}) {
		print Out ">$_\n$seq{$_}\n";
	}
}
close In;
close Out;
#######################################################################################
print STDOUT "\nDone. Total elapsed time : ",time()-$BEGIN_TIME,"s\n";
#######################################################################################
sub ABSOLUTE_DIR #$pavfile=&ABSOLUTE_DIR($pavfile);
{
	my $cur_dir=`pwd`;chomp($cur_dir);
	my ($in)=@_;
	my $return="";
	if(-f $in){
		my $dir=dirname($in);
		my $file=basename($in);
		chdir $dir;$dir=`pwd`;chomp $dir;
		$return="$dir/$file";
	}elsif(-d $in){
		chdir $in;$return=`pwd`;chomp $return;
	}else{
		warn "Warning just for file and dir \n$in";
		exit;
	}
	chdir $cur_dir;
	return $return;
}
sub USAGE {#
        my $usage=<<"USAGE";
Contact:        meng.luo\@majorbio.com;
Script:			$Script
Description:

	eg:  perl $Script -int gene.fa -out gene.DE.fa -gene DE.list
	
Usage:
  Options:
	-int input fa file
	-out ouput file name 
	-gene the gene and transcript id list
	-h         Help

USAGE
        print $usage;
        exit;
}
