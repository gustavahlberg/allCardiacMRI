


qsub -t 0-4 gwas_bolt_rtrn_sbp.pbs

bash clump_spbAdj.sh


bash ${DIR}/getLeadSNPs_sbp.sh
bash ${DIR}/getLeadSNPs_sbp.sh


bash ${DIR}/getnominalSignSnps.sh


