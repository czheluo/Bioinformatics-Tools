#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$min);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"out:s"=>\$fout,
			) or &USAGE;
&USAGE unless ($fout);
#$fin=ABSOLUTE_DIR($fin);
open In,$fin;
open SH,">$fout";
while (<In>) {
	chomp;
	print SH "awk \'BEGIN{OFS=FS=\"\\t\"}ARGIND==1{a[\$1]=\$0}ARGIND==2{if(a[\$1]){\$4=a[\$1]}else{\$4=\"\@\"};print \$0}\' $_\_1_vs_$_\_1_known.xls $_\_1_vs_$_\_2_known.xls | grep -v \"\@\" > $_\_1_vs_$_\_12_known.xls && awk \'BEGIN{OFS=FS=\"\\t\"}ARGIND==1{a[\$1]=\$0}ARGIND==2{if(a[\$1]){\$4=a[\$1]}else{\$4=\"\@\"};print \$0}\' $_\_1_vs_$_\_12_known.xls $_\_1_vs_$_\_3_known.xls | grep -v \"\@\" > $_\_1_vs_$_\_312_known.xls && less $_\_1_vs_$_\_312_known.xls | awk \'BEGIN{OFS=FS=\"\\t\"}{print \$1\"\t\"(\$2+\$5+\$8)/3\"\t\"(\$3+\$6+\$9)/3}'> result/$_\_1_vs_$_\_known.xls && less result/$_\_1_vs_$_\_known.xls|sed '1d'|cut -f1 > result/$_\_known.list \n";
	print SH "awk \'BEGIN{OFS=FS=\"\\t\"}ARGIND==1{a[\$1]=\$0}ARGIND==2{if(a[\$1]){\$4=a[\$1]}else{\$4=\"\@\"};print \$0}\' $_\_1_vs_$_\_1_novel.xls $_\_1_vs_$_\_2_novel.xls | grep -v \"\@\" > $_\_1_vs_$_\_12_novel.xls && awk \'BEGIN{OFS=FS=\"\\t\"}ARGIND==1{a[\$1]=\$0}ARGIND==2{if(a[\$1]){\$4=a[\$1]}else{\$4=\"\@\"};print \$0}\' $_\_1_vs_$_\_12_novel.xls $_\_1_vs_$_\_3_novel.xls | grep -v \"\@\" > $_\_1_vs_$_\_312_novel.xls && less $_\_1_vs_$_\_312_novel.xls | awk \'BEGIN{OFS=FS=\"\\t\"}{print \$1\"\t\"(\$2+\$5+\$8)/3\"\t\"(\$3+\$6+\$9)/3}'> result/$_\_1_vs_$_\_novel.xls && less result/$_\_1_vs_$_\_novel.xls|sed '1d'|cut -f1 > result/$_\_novel.list\n";
	print SH ""
}
close In;
close SH;
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

	eg: perl $Script -int uniq.list -out case6.sh
	

Usage:
  Options:
	-int input file name
	-out ouput file name 
	-h         Help

USAGE
        print $usage;
        exit;
}
