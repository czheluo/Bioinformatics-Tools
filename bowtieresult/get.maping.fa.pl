#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$fa);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"fa:s"=>\$fa,
	"out:s"=>\$fout,
			) or &USAGE;
&USAGE unless ($fout);

open IN,$fa;
my %seq;
$/ = ">";
while(<IN>){
	chomp;
	next if ($_ eq "" || /^$/);
	my ($chr,$seq) = split(/\n/,$_,2);
	#print $chr;die;
	$seq =~ s/\n//g;
	$seq{$chr} = $seq;
}
close IN;

$/="\n";
open In,$fin;
open Out,">$fout";
while (<In>) {
	chomp;
	my ($readsid,$strand,$refid,$start,$end)=split/\s+/,$_;
	my $len=$end-$start;
	next if ($len < 21 || $len > 23);
	my $pos = $start-1;
	if ($pos <= 0) {
		$pos =0;
	}else{
		$pos =$pos;	
	}
	#print $seq{$refid};die;
	my $part = substr($seq{$refid},$pos,($end-$start));
	$part =~ s/T/U/g;
	print Out "$readsid\t$strand\t$start $part $end\t$len\n";
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

	eg: perl $Script -int B.txt -fa ref.fa -out B.anno 
	
Usage:

  Options:
	-int input file name
	-fa input fa file 
	-out ouput file name 
	-h         Help

USAGE
        print $usage;
        exit;
}
