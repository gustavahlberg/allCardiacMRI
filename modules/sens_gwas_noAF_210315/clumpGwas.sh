#
# clump gwas summarystat
#
# ------------------------------

sumstat=$1

bdir=${DIR}/../../data/subsetBinaryPed
out=${DIR}/results/$gwas/$(basename ${sumstat%.bgen.stats.gz})

for i in {1..22}
do
   
    echo $i
    bfile=${bdir}/subsetFinal_ukb_chr${i}_v3
    #sumstat=${DIR}/../gwas_w_plink_191117/results_sens/tmp.gz

    module  unload plink2/1.90beta5.4
    module load plink2/2.00alpha20190429
    plink2 --bfile $bfile --rm-dup list

    module unload plink2/2.00alpha20190429
    module  load plink2/1.90beta5.4
    plink --bfile ${bfile} \
        --clump ${sumstat} \
        --clump-p1 0.000005 \
        --clump-p2 0.05 \
        --clump-r2 0.1 \
        --clump-kb 1000 \
        --clump-field P_BOLT_LMM \
        --clump-snp-field SNP \
        --exclude $DIR/plink2.rmdup.mismatch \
        --out ${out}_${i}

    rm ${DIR}/plink2.rmdup.mismatch 
    
done


tmp=`find results/$gwas/*clumped| head -1`
head -1 ${DIR}/$tmp | sed -E -e 's/[[:blank:]]+/ /g' | \
    sed -E -e 's/^[[:blank:]]//' > header 

cat ${out}_[0-9]*.clumped | grep -v '^[[:space:]]*$' | \
    sed -E -e 's/[[:blank:]]+/ /g' | sed -E -e 's/^[[:blank:]]//' | \
    grep -v CHR | cat header - > ${out}_ALL.clumped
rm ${out}*log ${out}_*.nosex 

echo SNP > tmpHead

cut -f 3 -d " " ${out}_ALL.clumped | \
    perl -ane 'chomp; print "$_\t\n" ' | cat tmpHead - > ${out}_rsidLeadSnps_.txt
gzcat $sumstat |grep -F -f ${out}_rsidLeadSnps_.txt - > ${out}_leadSnps.txt


plink --gene-report ${out}_leadSnps.txt glist-hg19 \
    --gene-list-border 500 \
    --out ${out}_nearstGenes_SuggestiveLeadSnps.txt


cat ${out}_ALL.clumped | perl -ane 'if($F[4] <= 5e-8){print $_}' > ${out}_gwSign_ALL.clumped
plink --gene-report ${out}_gwSign_ALL.clumped glist-hg19 \
    --gene-list-border 500 \
    --out ${out}_nearstGenes_LeadSnps.txt

cat ${out}_gwSign_ALL.clumped  | cut -f 3,12 -d " " | tr " " "\n" | \
    tr "," "\n" | sed -E -e 's/\(1\)//g' | \
    perl -ane 'chomp; print "$_\t\n" '> ${out}_rsid_Locus_nominalSignSnps.txt

gzcat ${sumstat} | grep -F -f ${out}_rsid_Locus_nominalSignSnps.txt - \
    > ${out}_Locus_nominalSignSnps.txt




