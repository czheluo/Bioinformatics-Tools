#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($out,$vcf,$gro,$queue,$wsh);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"gro:s"=>\$gro,
	"out:s"=>\$out,
	"vcf:s"=>\$vcf,
	"queue:s"=>\$queue,
	"wsh:s"=>\$wsh,
	) or &USAGE;
&USAGE unless ($vcf and $out);
$queue ||="DNA";
mkdir $wsh if (!-d $wsh);
mkdir $out if (!-d $out);
$out=ABSOLUTE_DIR($out);
$vcf=ABSOLUTE_DIR($vcf);
$gro=ABSOLUTE_DIR($gro);
$wsh=ABSOLUTE_DIR($wsh);

my $populations="/mnt/ilustre/centos7users/dna/.env/stacks-2.2/bin/populations";
open SH,">$wsh/pulation.sh";
print SH "$Bin/bin/rtm-gwas-gsc --grm --out $out/gsc.out --vcf $vcf \n";
print SH "$populations -V $vcf -O $out -M $gro -k -t 8 && ";
print SH "perl $Bin/bin/result.pl -int $out -out $out/pop.recode.csv ";
close SH;
my $job="qsub-slurm.pl --Queue $queue --Resource mem=10G --CPU 8  $wsh/pulation.sh";
`$job`;

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
	-vcf	<file>	input vcf file
	-out	<dir>	output dir
	-gro <file> group list file 
	-queue default ("DNA")
	-wsh <dir> work shell dir name 
  -h         Help

USAGE
        print $usage;
        exit;
}
