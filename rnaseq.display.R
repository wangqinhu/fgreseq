pdf("data/rnaseq/rnaseq.pdf", 6, 6)
layout(matrix(c(1,2,3,4),2,2,byrow = TRUE), c(1.0,1.0),c(1.0,1.0), respect = T)

system("sh ./rnaseq.2speed.sh")
par(mar=c(4,4.5,1.0,0.5))
s<-read.table("data/rnaseq/slow.diff.tsv")
plot(s$logCPM,s$logFC,pch=20,cex=0.8, col="purple", xlab="logCPM", ylab="logFC")
panel.first = grid()
f<-read.table("data/rnaseq/fast.diff.tsv")
points(f$logCPM,f$logFC,pch=20,cex=0.8, col="yellow")
non<-read.table("data/rnaseq/no.diff.tsv")
points(non$logCPM,non$logFC,pch=20,cex=0.8)
legend("topright", c("fast","slow", "ns"), pch = 20, bg ="lightgreen", col = c("yellow", "purple", "black"),cex=0.8)
mtext("a", adj=0.020, line=-1.8, outer=T)

library(RColorBrewer)
par(mar=c(4,5,1.0,0.5))
mc <- brewer.pal(6,"Blues")
mc[3]<-c("pink")
mc[4]<-c("red")
#	slow	fast
#nd	1186	2125
#ns	4185	1931
#up>2	896	517
#up>10	170	660
#down>2	979	610
#down>10	395	510
fr<-matrix(c(1186+4185,896,170,979,395,2125+1931,517,660,610,510),5)
rownames(fr)<-c("ns", "up>2", "up>10", "down>2", "down>10")
colnames(fr)<-c("slow","fast")
barplot(prop.table(fr,2),xlim=c(0,6),ylab="frequency", col=mc[2:6])
legend(3,0.67,rev(row.names(fr)), pch=20,col=rev(mc), cex = 1.0)
mtext("b", adj=0.545, line=-1.8, outer=T)

fu<-read.table("data/rnaseq/up.fast.sum.tsv")
su<-read.table("data/rnaseq/up.slow.sum.tsv")
fd<-read.table("data/rnaseq/dn.fast.sum.tsv")
sd<-read.table("data/rnaseq/dn.slow.sum.tsv")
fold<-list(su$V2, fu$V2, sd$V2, fd$V2)
#names(fold)<-c("up\nslow", "up\nfast", "down\nslow", "down\nfast")
par(mar=c(3,4.5,1.0,1.0))
boxplot(fold, ylab="logFC", col=c("purple","yellow"), axes = F)
axis(1,at=1:4,labels = rep("",4))
axis(2)
box()
mylab<-c("up\nslow", "up\nfast", "down\nslow", "down\nfast")
par(xpd=NA)
text(1:4,-18,mylab)
mtext("c", adj=0.020, line=-20, outer=T);

rnaseq<-read.table("data/classpro/rnaseq.tsv")
r<-as.matrix(rnaseq)
fast<-6353
slow<-7811
r[1,]<-r[1,]/slow
r[2,]<-r[2,]/fast
par(mar=c(3,5,1.0,1.0))
barx<-barplot(prop.table(r,2),
              col = c("purple","yellow"),
              ylab = "Ratio of subgenome",
              xlim = c(0,8),
              xaxt="n"
)
text(barx+0.6, -0.1,
     cex = 0.8,
     labels=colnames(r),
     srt=45,
     pos=2,
     font = 2,
     xpd=TRUE)
legend(6.2, 1, rev(rownames(r)), fill = c("yellow","purple"),cex=0.7)
mtext("d", adj=0.545, line=-20, outer=T);

dev.off()