pdf("data/2speed/2speed.pdf", 7.5, 3)
layout(matrix(c(1:3),1,3,byrow = TRUE))
state2col <- function(x) {
  col <- rep("black", length(x))
  for (i in 1:length(x)) {
    if (x[i]==1) {
      col[i] <- c("fill_color=yellow")
    } else {
      col[i] <- c("fill_color=purple")
    }
  }
  return(col)
}

# fit 2 speed model
## with EM

library (mixtools)
vcf = read.table("data/density/density6.txt")
vcfem = normalmixEM(vcf$V4/25,k=2)
par(mar=c(4.5,4.5,1,1))
plot.mixEM(vcfem, breaks=50,density = TRUE, lwd2  = 2, w=1.1, xlab2="Variants/kb",main2="",col2=c("purple","orange"))
library(shape)

Arrows(2.0, 0.63, 3.2, 0.63, arr.length = 0.2, segment = T, code = 1, arr.adj = 0.5, col="purple")
Arrows(5.5, 0.085, 6.3, 0.12, arr.length = 0.2, segment = T, code = 1, arr.adj = 0.5, col="orange" )
text(11,0.63, expression(paste("slow: ", mu, " = 0.6,  ", sigma," = 0.3")))
text(11,0.17, expression(paste("fast: ", mu, " = 4.9,  ", sigma," = 3.5")))

mtext("a", adj=0.01, line=-2, outer=T)

## decode with veterbi
library (depmixS4)
msp <- depmix(V4~1,nstates=2,data=vcf)
set.seed(1)
fmsp <- fit(msp)
#plot(ts(posterior(fmsp)))  
state = posterior(fmsp)$state
write.table(paste(vcf$V1, vcf$V2, vcf$V3, state),file="data/2speed/state.tsv", sep = "\t", row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(paste(vcf$V1, vcf$V2, vcf$V3, state2col(state)),file="data/circos/data/state.txt", sep = "\t", row.names=FALSE, col.names=FALSE, quote=FALSE)

# gc interval
system("./gc.interval.sh")
fast<-read.table("data/gc/gc.fast.txt")
slow<-read.table("data/gc/gc.slow.txt")
x<-list(slow$V1,fast$V1)
names(x)<-c("slow", "fast")
par(mar=c(4.5,4.5,1,1))
boxplot(x,ylim=c(40,60),col=c("purple","yellow"),ylab="GC content (%)")
t.test(fast$V1,slow$V1, alternative = "less")$p.value
mtext("b", adj=0.35, line=-2, outer=T);


# classpro
fast<-6353
slow<-7811
genome<-read.table("data/classpro/genome.tsv")
g<-as.matrix(genome)
g[1,]<-g[1,]/slow
g[2,]<-g[2,]/fast
par(mar=c(4.5,4.5,1,0.5))
barplot(g,
        beside = T,
        col = c("purple","yellow"),
        ylab = "Ratio",
        ylim = c(0,0.33)
)
legend("topright", box.col = "white", rownames(g), fill = c("purple","yellow"))
mtext("c", adj=0.685, line=-2, outer=T);

dev.off()