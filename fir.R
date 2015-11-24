# hist2
library(squash)

# flanking intergenic regions, FIRs
x<-read.table("data/2speed/fg.fir.tsv")
fast<-read.table("data/2speed/fg.fast.fir.tsv")
slow<-read.table("data/2speed/fg.slow.fir.tsv")
pif<-read.table("data/2speed/pi.fir.tsv")


pdf("data/2speed/fir.pdf",7,7)
layout(matrix(c(1,2,3,4),2,2,byrow = TRUE))
par(mar=c(4,4,1,1))
hist2(log2(x$V2),log2(x$V3), nx=100, colFn=jet, key.args = list(stretch = 1), xlim=c(0,20),ylim=c(0,20),
      xlab="log2(5' FIRs)", ylab="log2(3' FIRs)")
text(2,18,"Fg")

hist2(log2(fast$V2),log2(fast$V3), nx=100, colFn=jet, key.args = list(stretch = 1), xlim=c(0,20),ylim=c(0,20),
      xlab="log2(5' FIRs)", ylab="log2(3' FIRs)")
text(3,18,"Fg.fast")
hist2(log2(slow$V2),log2(slow$V3), nx=100, colFn=jet, key.args = list(stretch = 0.8), xlim=c(0,20),ylim=c(0,20),
      xlab="log2(5' FIRs)", ylab="log2(3' FIRs)")
text(3,18,"Fg.slow")
hist2(log2(pif$V2),log2(pif$V3), nx=100, colFn=jet, key.args = list(stretch = 0.7), xlim=c(0,20),ylim=c(0,20),
      xlab="log2(5' FIRs)", ylab="log2(3' FIRs)")
text(2,18,"Pi")
dev.off()