state2col <- function(x) {
  col <- rep("black", length(x))
  for (i in 1:length(x)) {
    if (x[i]==1) {
      col[i] <- c("fill_color=red")
    } else {
      col[i] <- c("fill_color=black")
    }
  }
  return(col)
}



# Read vcf
vcf = read.table("density.winstep.txt")

# mixplot
library (mixtools)
vcfem = normalmixEM(vcf$V4/25,k=2)
plot(vcfem$all.loglik)
par(mar=c(4.2,4.5,1,0.2))
plot.mixEM(vcfem, breaks=50,density = TRUE, w = 1.1, xlab2="Variants/Kb",main2="")

# hmm
library (depmixS4)
msp <- depmix(V4~1,nstates=2,data=vcf)
set.seed(1)
fmsp <- fit(msp)
plot(ts(posterior(fmsp)))  
state = posterior(fmsp)$state
write.table(paste(vcf$V1, vcf$V2, vcf$V3, state),file="state.tsv", sep = "\t", row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(paste(vcf$V1, vcf$V2, vcf$V3, state2col(state)),file="state.txt", sep = "\t", row.names=FALSE, col.names=FALSE, quote=FALSE)

