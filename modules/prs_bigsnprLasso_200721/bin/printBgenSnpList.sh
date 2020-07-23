module load bgen/20200629  
i=$1
pth=../../data/subsetbgen/
bgenix -list -g ${pth}/subset_ukb_imp_chr${i}_v3.bgen > tmp
