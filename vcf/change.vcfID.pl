#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$list);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"out:s"=>\$fout,
	"list:s"=>\$list,
			) or &USAGE;
&USAGE unless ($fout);
open IN,$list;
my %ch;
while (<IN>) {
	chomp;
	my($id1,$id2)=split/\s+/,$_;
	$ch{$id1}=$id2;
}
close IN;
open In,$fin;
open Out,">$fout";
while (<In>) {
	chomp;
	if ($_ =~ "#") {
		print Out "$_\n";
	}else{
		my ($chr,$pos,$id,$all)=split/\s+/,$_,4;
		print Out "$ch{$chr}\t$pos\t$ch{$chr}:$pos\t$all\n";
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

	eg: perl change.vcfID.pl -int pop.kf.uniq.09.recode.vcf -out pop.recode.vcf 
	
Usage:
  Options:
	-int input file name
	-out output file name 
	-h         Help

USAGE
        print $usage;
        exit;
}
