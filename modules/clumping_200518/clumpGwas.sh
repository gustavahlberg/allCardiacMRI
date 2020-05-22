#
# clump gwas summarystat
#
# ------------------------------

sumstat=$1
#sumstat=${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn/rntrn_ilamin.bgen.stats.gz 
bdir=${DIR}/../../data/subsetBinaryPed

out=$(basename ${sumstat%.bgen.stats.gz})

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
done


tmp=`find *clumped| head -1`
head -1 ${DIR}/$tmp | sed -E -e 's/[[:blank:]]+/ /g' | \
    sed -E -e 's/^[[:blank:]]//' > header 
cat ${DIR}/${out}_*.clumped | grep -v '^[[:space:]]*$' | \
    sed -E -e 's/[[:blank:]]+/ /g' | sed -E -e 's/^[[:blank:]]//' | \
    grep -v CHR | cat header - > ${DIR}/results/${out}_ALL.clumped
rm ${out}*log ${out}_*.nosex plink2.rmdup.mismatch

cut -f 3 -d " " ${DIR}/results/${out}_ALL.clumped | \
    perl -ane 'chomp; print "$_\t\n" '> ${DIR}/rsidLeadSnps_${out}.txt
gzcat $sumstat |grep -F -f ${DIR}/rsidLeadSnps_${out}.txt - > results/LeadSnps_${out}.txt


plink --gene-report results/LeadSnps_${out}.txt glist-hg19 \
    --gene-list-border 500 \
    --out results/nearstGenes_SuggestiveLeadSnps_${out}.txt


cat results/${out}_ALL.clumped | perl -ane 'if($F[4] <= 5e-8){print $_}' > results/gwSign_${out}_ALL.clumped
plink --gene-report results/gwSign_${out}_ALL.clumped glist-hg19 \
    --gene-list-border 500 \
    --out results/nearstGenes_LeadSnps_${out}.txt

cat results/gwSign_${out}_ALL.clumped | cut -f 3,12 -d " " | tr " " "\n" | \
    tr "," "\n" | sed -E -e 's/\(1\)//g' | \
    perl -ane 'chomp; print "$_\t\n" '> results/rsid_Locus_nominalSignSnps_${out}.txt

gzcat ${sumstat} | grep -F -f ${DIR}/results/rsid_Locus_nominalSignSnps_${out}.txt - \
    > results/Locus_nominalSignSnps_${out}.txt




