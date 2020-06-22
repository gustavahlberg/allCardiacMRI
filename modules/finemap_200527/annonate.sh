# -------------------------------
#
# Annontate w/ snpeff
#
# -------------------------------

ref=/Users/gustavahlberg/REF/hs.build37.1.dict
vcf=$1
#vcf=vcfs/rntrn_ilamax_2.chr10.vcf

# -------------------------------
#
# sort vcf alleles
#

cat header $vcf > tmp; mv tmp $vcf


java -jar picard.jar SortVcf \
  I=$vcf \
  O=tmp.vcf \
  SD=$ref


bcftools +fill-from-fasta tmp.vcf -- -c REF -f /Users/gustavahlberg/REF/hs.build37.1.fa > output.vcf
# bcftools +fill-from-fasta test.vcf --header-lines
#cat  output.vcf | grep -v '#' | cut -f 4,5 > tmp
R CMD BATCH checkAlleles.R 

grep '#' output.vcf | cat - tmp.vcf > tmp ; mv tmp output.vcf; rm tmp.vcf


# -------------------------------
#
# annontate
#

#dbNSFP annotation string
# AnnoDbNSFP=${GERP++_RS,Uniprot_acc,MutationTaster_pred,
# FATHMM_pred,SIFT_pred,SIFT_converted_rankscore,
# Polyphen2_HDIV_pred,Polyphen2_HDIV_rankscore,Polyphen2_HVAR_rankscore,
# Polyphen2_HVAR_pred,ExAC_Adj_AF,ExAC_NFE_AF,
# clinvar_clnsig,clinvar_trait,GERP++_NR,SIFT_score,FATHMM_score,
# phyloP46way_primate,phyloP100way_vertebrate,CADD_raw,CADD_raw_rankscore,CADD_phred'}

vcfOut=vcfAnnonted/$(basename ${vcf%.vcf}.annon.dbnsp.vcf)

java -jar ~/bin/snpEff/snpEff.jar GRCh37.75 output.vcf > tmp.vcf
java -jar ~/bin/snpEff/SnpSift.jar dbnsfp -v -db \
  ~/RESOURCES/dbNSFP2.9.txt.gz tmp.vcf > $vcfOut



