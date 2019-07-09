#!/usr/bin/perl -w

use strict;
use warnings;
use Getopt::Long;
my %opts;
GetOptions (\%opts,"f=s","l=s","o=s","w=i","h=i","ls=f","ns=f");

my $usage = <<"USAGE";
        contact:czheluo\@gmail.com
        Discription: plot venn for differently expressed genes.
        Usage:perl $0 [options]
                -f      files     a,b,c
                -l      string    labels x,y,z
		-o	string	out file prefix
                -w      int       image width
                -h      int       image height
		-ls      float     lable size
		-ns      float     number  size

USAGE
die $usage if (!($opts{f}&&$opts{l}&& $opts{o}));
$opts{w}=$opts{w}?$opts{w}:10;
$opts{h}=$opts{h}?$opts{h}:10;
$opts{ls}=$opts{ls}?$opts{ls}:1;
$opts{ns}=$opts{ns}?$opts{ns}:2;

my @files = split /,/, $opts{f};
my @ids = split /,/, $opts{l};
my %hash;
for(my $i = 0; $i < @files; $i ++)
{
	open FA, $files[$i] or die $!;
	while(<FA>)
	{
		chomp;
		$hash{$_} = 0;
	}
	close FA;
}

my %res;
foreach(keys %hash)
{
	for(my $i = 0; $i < @files; $i ++)
	{
		my $flag = 0;
		open FA, $files[$i] or die $!;
		while(my $line = <FA>)
		{
			chomp($line);
			if($line eq $_)
			{
				push @{$res{$_}}, 1;
				$flag = 1;
				last;
			}
		}
		close FA;
		
		if($flag eq 1)
		{
			next;
		}else{
			push @{$res{$_}}, 0;
		}
	}
}

#my $out = join "-", @ids;
my $head = join "\t", @ids;
open OUT, "> $opts{o}.xls" or die $!;
print OUT "gene_id\t$head\n";
foreach my $g(keys %res)
{
	my $string = join "\t", @{$res{$g}};
	print OUT "$g\t$string\n";
}
close OUT;

open RCMD, ">cmd.r";
print RCMD "
options(warn=-100)
files<-unlist(strsplit(\"$opts{f}\",\",\",fix=T))
Lables<-unlist(strsplit(\"$opts{l}\",\",\",fix=T))
InputList<-list()
for(i in 1:length(files)){
    genes<-scan(file=files[i],what=character())
    InputList[[i]]<-genes
}
names(InputList)<-Lables
if(length(Lables)==2){fillColor<-c(\"dodgerblue\", \"goldenrod1\")}
if(length(Lables)==3){fillColor<-c(\"dodgerblue\", \"goldenrod1\",\"blue\")}
if(length(Lables)==4){fillColor<-c(\"dodgerblue\", \"goldenrod1\",\"blue\",\"red\")}
if(length(Lables)==5){fillColor<-c(\"dodgerblue\", \"goldenrod1\",\"blue\",\"red\",\"grey\")}

library(\"VennDiagram\")
#outname<-paste(Lables,collapse=\"-\")
outname<-\"$opts{o}\"
pdf(file = paste(outname,\".pdf\",sep=\"\"),width=$opts{w},height=$opts{h})
venn.plot<-venn.diagram(InputList,filename = NULL,col = \"black\",fill = fillColor,alpha = 0.50,cat.cex = $opts{ls},cat.fontface = \"bold\",margin = 0.15,cex=$opts{ns},scale=TRUE)
grid.draw(venn.plot)
dev.off()

";

`R --restore --no-save < cmd.r`;
system ('rm *.r');

