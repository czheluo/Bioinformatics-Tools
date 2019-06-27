#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fout,$fin);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"out:s"=>\$fout,
	) or &USAGE;
&USAGE unless ($fin);
my $fna=glob("$fin/*.sumstats_summary.tsv");
open IN,$fna;
open OUT,">$fout";
while(<IN>){
	chomp;
	next if (/^# Var/);
	if (/^# Pop/) {
		my @id=split/\t/;
		print OUT "PopID\t$id[1]\t$id[2]\t$id[8]\t$id[11]\t$id[14]\t$id[18]\t$id[20]\t$id[23]\n";
	}elsif (/^# All positio/) {
		last;
	}else{
		my @id=split/\t/;
		print OUT "$id[0]\t$id[1]\t$id[2]\t$id[8]\t$id[11]\t$id[14]\t$id[18]\t$id[20]\t$id[23]\n";
	}
}
close IN;
close OUT;
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

	eg:


Usage:
  Options:
  -int input filename
  -out	<dir>	output filename
  -h         Help

USAGE
        print $usage;
        exit;
}
