#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;
use DBI;
use Getopt::Long;
use List::Util qw ( sum);
my %opts;
my $VERSION = "2.0";

GetOptions(
	\%opts, "enrich=s", "p=s", "num=i", "q=s", "min_diff=i", "help!"
);

my $usage = <<"USAGE";
       Program : $0
       Version : 1.0
       Contact : binxu.liu\@majorbio.com
       Usage :perl $0 [options]
        -enrich 	enrichment result of goatools
		-p			diff expression gene list
        -num  		listfile  listall genenames for all the GO terms of this level
		-q			up down FOLDCHANGE
        -help		Display this usage information

       example: 
USAGE

die $usage
  if ( !$opts{enrich} || $opts{help} );
my $p = $opts{p}?$opts{p}:1;
my $q = $opts{p}?$opts{p}:1;
my $num = $opts{num}?$opts{num}:12;

open( FILE, "<$opts{enrich}" ) || die "Can't open $opts{enrich} or file not exsit!\n";
my $head = <FILE>;
my $total = 1;

open( TEMP, "> $opts{enrich}.temp" ) || die "Can't open $opts{enrich} or file not exsit!\n";
print TEMP $head;
while (<FILE>) {
	chomp;
	
	if($total >20){
		last;
	}
	$total++;
	my @lines = split(/\t/,$_);
	if($lines[5]<$p && $lines[6]<$q){
		print TEMP $_."\n";
	}

}
system("sed 's/example/$opts{enrich}.temp/g' /mnt/ilustre/users/bingxu.liu/workspace/RNA_Pipeline/script/GO_picture.R >$opts{enrich}.temp.R");
# while(!(-e "$opts{enrich}.temp.png" && -e "$opts{enrich}.temp.svg")){
	# system("R --no-save < $opts{enrich}.temp.R");
# }
# system("R --no-save < $opts{enrich}.temp.R");
# system("rm $opts{enrich}.temp.R $opts{enrich}.temp");
close FILE;
close TEMP;
