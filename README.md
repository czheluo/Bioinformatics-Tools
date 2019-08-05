#  S (small) Bioinformatics Tools

### Populations diversity 

#### Reference

- N. Rochette & J. Catchen. [Deriving genotypes from RAD-seq short-read data using Stacks](https://www.nature.com/articles/nprot.2017.123). Nature Protocols, 12:2640–2659, 2017
- Jianbo He, Shan Meng, Tuanjie Zhao, Guangnan Xing, Shouping Yang, Yan Li, Rongzhan Guan, Jiangjie Lu, Yufeng Wang, Qiuju Xia, Bing Yang, Junyi Gai, [An innovative procedure of genome-wide association analysis fits studies on germplasm population and plant breeding](https://link.springer.com/article/10.1007%2Fs00122-017-2962-9), Theor Appl Genet, 2017, 130: 2327-2343. doi: 10.1007/s00122-017-2962-9

#### Bowtie
> cd /mnt/ilustre/centos7users/meng.luo/project/yuanjie_MJ20190619038/bowtie/1/ && bowtie -f -n 0 -e 80 -l 18 -a -m 5 --best --strata --al M.clean.1.mapped --un M.clean.1.unmapped M.clean.1.fa /mnt/ilustre/centos7users/meng.luo/project/yuanjie_MJ20190619038/04.bam-sort/Z.sort.mapped.bam.fa M.clean.1.bwt 2> M.clean.1.log

### VENN plot

Required INSTALL VennDiagram R package 
 ```r
> install.packages("VennDiagram")
> library(VennDiagram)
```
#### examples

![venn 1](VENN/Fig/0001.jpg "venn1")
![venn 2](VENN/Fig/0002.jpg "venn2")
