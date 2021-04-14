
# collinearity


```linux

$ gffread -T Brapa_genome_v3.0_genes.gff3 -o ref_genome.gtf
$gtf2Bed.pl ref_genome.gtf >ref_genome.bed
$bedtools getfasta -fi ref.fa -bed ref_genome.gtf.bed > ref_genome.gtf.fa 
$ perl ../../fasta_change.pl Brapa_sequence_v3.0.fasta ref.fa
$/mnt/ilustre/users/dna/.env/bin/makeblastdb -in final.gtf.fa -dbtype nucl -title CRR -parse_seqids -out CRR -logfile CCR.log
$ /mnt/ilustre/users/dna/.env/bin/blastn -query Crr3.fa -db  CRR  -evalue 1e-2 -num_threads 8  -outfmt 6 -out Crr3.blast
$ /mnt/ilustre/centos7users/dna/.env/MCScanX/MCScanX Crr3
## the gff file was combined from two species

$java circle_plotter -g /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/v3.gff  -s /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/v3.collinearity -c /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/circos.ctl -o /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/v3.circos.png
$ java circle_plotter -g /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/v3.gff  -s /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/v3.collinearity -c /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/controlfile.ctl -o /mnt/ilustre/centos7users/meng.luo/project/RNA/liuhaifang_MJ20171228027/MCScanX/MCScanX/data/demo/two/v3.circos.png

```
