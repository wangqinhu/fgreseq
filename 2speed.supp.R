pdf("data/2speed/2speed.supp.pdf", 7,2.5)
layout(matrix(c(1:3),1,3,byrow = TRUE))
#gc gene
fast<-read.table("data/2speed/fast.lengc.tsv")
slow<-read.table("data/2speed/slow.lengc.tsv")
x<-list(slow$V3,fast$V3)
names(x)<-c("slow", "fast")
par(mar=c(2.5,4.5,1,2))
boxplot(x, ylim=c(40,60), col=c("purple","yellow"),ylab="GC content (%)")
mtext("A", adj=0.01, line=-2, outer=T);


# gene len
fast<-read.table("data/2speed/fast.lengc.tsv")
slow<-read.table("data/2speed/slow.lengc.tsv")
y<-list(slow$V2,fast$V2)
names(y)<-c("slow", "fast")
par(mar=c(2.5,4.5,1,2))
boxplot(y, ylim=c(0,8000), col=c("purple","yellow"),ylab="Gene length (bp)", outline = T)
mtext("B", adj=0.35, line=-2, outer=T);


# exon
fast<-read.table("data/2speed/fast.exon.tsv")
slow<-read.table("data/2speed/slow.exon.tsv")
x<-list(slow$V2,fast$V2)
names(x)<-c("slow", "fast")
par(mar=c(2.5,4.5,1,2))
boxplot(x, col=c("purple","yellow"),ylab="Number of exons", outline = T)
mtext("C", adj=0.685, line=-2, outer=T);
dev.off()