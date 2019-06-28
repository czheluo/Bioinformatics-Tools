#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$all,$go,$pathway);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"list:s"=>\$fin,
	"gene:s"=>\$all,
	"GO:s"=>\$go,
	"pathway:s"=>\$pathway,
	"out:s"=>\$fout,
			) or &USAGE;
&USAGE unless ($fout);
$fin=ABSOLUTE_DIR($fin);
$fout=ABSOLUTE_DIR($fout);
my @lists=glob("$fin/*DE.list");
open SH,">$fout/go.data.sh";
print SH "ln -s /mnt/ilustre/users/bingxu.liu/workspace/RNA_Pipeline/RNA_database/gene_ontology.1_2.obo $fout ";
open SH1,">$fout/go.sh";
open SH2,">$fout/kegg.sh";
foreach my $file (@lists) {
	my $fln=basename($file);
	#print SH1 "python /mnt/ilustre/app/rna/function_enrichment/goatools-master/scripts/find_enrichment.py $fin/$fln $all $go --alpha 0.8 --fdr >$fin/$fln.go_enrichment && ";
	print SH1 "perl $Bin/bin/extract_goatools.pl -enrich $fin/$fln.go_enrichment -diff $fin/$fln -lib $fout/gene_ontology.1_2.obo && ";
	print SH1 "perl $Bin/bin/enrich_barplot.pl -i $fin/$fln.enrichment.detail.xls -t GO && ";
	print SH1 "perl $Bin/bin/go_orthology_relation.pl -enrich $fin/$fln.enrichment.detail.xls \n";
	print SH2 "perl $Bin/bin/diff_ko_select.pl -g $fin/$fln -k $pathway > /dev/null 2>&1 && "; 
	print SH2 "python $Bin/bin/identify.py -f $fin/$fln.ko_annot -n BH -b $pathway -o $fin/$fln.kegg_enrichment.xls &&";
	print SH2 "perl $Bin/bin/enrich_barplot.pl -i $fin/$fln.kegg_enrichment.xls -t PATHWAY \n";
}
close SH;
close SH1;
close SH2;
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
	"list:s"=>\$fin,
	"gene:s"=>\$all,
	"GO:s"=>\$go,
	"pathway:s"=>\$pathway,
	"out:s"=>\$fout,
	-h         Help

USAGE
        print $usage;
        exit;
}
