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
	"list:s"=>\$fin,
	"out:s"=>\$fout,
			) or &USAGE;
&USAGE unless ($fout);
#$fin=ABSOLUTE_DIR($fin);
open In,$fin;
my @name;
while (<In>) {
	chomp;
	push @name,join("\t",$_);
}
close In;
open SH,">$fout";
for (my $i=0;$i < @name ;$i++) {
	my ($name1,undef)=split/\./,$name[$i];
	for (my $j=$i+1;$j< @name ;$j++) {
		my ($name2,undef)=split/\./,$name[$j];
		print SH "perl $Bin/bin/Venn_rnaseq.pl -f $name1.list,$name2.list -l $name1,$name2 -o $name1\_vs_$name2 \n";
	}
}
close In;
close SH;
#open In,$fin;
#open SH,">$fout";
#while (<In>) {
#	chomp;
#	my ($name1,undef)=split/\./,$_;
#	open IN,$fin;
#	while (<IN>) {
#		chomp;
#		my ($name2,undef)=split/\./,$_;
#		if ($name1 eq $name2) {
#			next;
#		}else{
#			print SH "$Bin/bin/Venn_rnaseq.pl -f $name1.list,$name2.list -l $name1,$name2 -o $name1\_vs_$name2 \n";
#		}
#	}	
#}
#close In;
#close SH;
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

	eg: perl -int filename -out filename 
	

Usage:
  Options:
	-list input list file name
	-out ouput file name 
	-h         Help

USAGE
        print $usage;
        exit;
}
