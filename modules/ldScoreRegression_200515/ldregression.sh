#
# Genetic correlation
# date: 200515
#
# ---------------------------------------------------------------
#
# Genetic Correlation and the
# LD Score Regression Intercept
#


cd $DIR/data/
wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
tar -jxvf eur_w_ld_chr.tar.bz2
cd $DIR


# ---------------------------------------------------------------
#
# lamin
#


phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_lamin.bgen.stats.sumstats.gz,${phenotypes%,}



ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out lamin_GeneticCorr

# ---------------------------------------------------------------
#
# ilamin
#


phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_ilamin.bgen.stats.sumstats.gz,${phenotypes%,}


ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out ilamin_GeneticCorr


# ---------------------------------------------------------------
#
# lamax
#

phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_lamax.bgen.stats.sumstats.gz,${phenotypes%,}


ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out lamax_GeneticCorr



# ---------------------------------------------------------------
#
# ilamax
#


phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_ilamax.bgen.stats.sumstats.gz,${phenotypes%,}


ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out ilamax_GeneticCorr


# ---------------------------------------------------------------
#
# latef
#


phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_latef.bgen.stats.sumstats.gz,${phenotypes%,}


ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out latef_GeneticCorr


# ---------------------------------------------------------------
#
# la aef
#


phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_laaef.bgen.stats.sumstats.gz,${phenotypes%,}


ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out laaef_GeneticCorr


# ---------------------------------------------------------------
#
# la pef
#

phenotypes=`find sumstats/*sumstats.gz | tr "\n" ","`
phenotypes=$DIR/sumstats/gwas_rtrn/rntrn_lapef.bgen.stats.sumstats.gz,${phenotypes%,}


ldsc.py \
    --rg $phenotypes \
    --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
    --out lapef_GeneticCorr






###################################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###################################################################
