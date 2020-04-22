eigenvectors = read.table("results/eigenvectors.txt",
                 stringsAsFactors = F,
                 header = T)

eigenvalues = read.table("results/eigenvalues.txt",
                          stringsAsFactors = F)

pcas = read.table("results/ukbMriSubset.FlashPca.txt",
                  stringsAsFactors = F,
                  header = T)


head(pcas)
summary(sqrt(eigenvalues$V1[1])*eigenvectors$U1)
summary(pcas$PC1)

hist(sqrt(eigenvalues$V1[1])*eigenvectors$U1)
hist(sqrt(eigenvalues$V1[2])*eigenvectors$U2)

plot(eigenvectors$U1,eigenvectors$U2)
plot(pcas$PC1,pcas$PC2)
pairs(pcas[,3:7])
