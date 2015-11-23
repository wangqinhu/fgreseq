pdf("data/rnaseq/rnaseq.pdf", 9, 3.5)
layout(matrix(c(1,2,3),1,3,byrow = TRUE), c(1.0,0.7,0.8),  respect = T)

system("sh ./rnaseq.2speed.sh")
par(mar=c(4,4,1.2,1.5))
s<-read.table("data/rnaseq/slow.diff.tsv")
plot(s$logCPM,s$logFC,pch=20,cex=0.8, col="purple", xlab="logCPM", ylab="logFC")
panel.first = grid()
f<-read.table("data/rnaseq/fast.diff.tsv")
points(f$logCPM,f$logFC,pch=20,cex=0.8, col="yellow")
non<-read.table("data/rnaseq/no.diff.tsv")
points(non$logCPM,non$logFC,pch=20,cex=0.8)
legend("topright", c("fast","slow", "ns"), pch = 20, bg ="lightgreen", col = c("yellow", "purple", "black"))
mtext("A", adj=0.005, line=-1.8, outer=T, cex=1.3);

par(mar=c(4,4.5,1.2,1.0))
mc <- brewer.pal(6,"Blues")
mc[3]<-c("pink")
mc[4]<-c("red")
# slow	fast
#nd	1251	2060
#ns	4295	1821
#up>2	921	492
#up>10	175	655
#down>2	1018	574
#down>10  412	490
fr<-matrix(c(1251+4295,920,175,1018,412,2060+1821,492,655,574,490),5)
rownames(fr)<-c("ns", "up>2", "up>10", "down>2", "down>10")
colnames(fr)<-c("slow","fast")
barplot(prop.table(fr,2),xlim=c(0,4.4),ylab="frequency", col=mc[2:6])
legend("right",rev(row.names(fr)), pch=20,col=rev(mc))
mtext("B", adj=0.42, line=-1.8, outer=T, cex=1.3)

fu<-read.table("data/rnaseq/up.fast.sum.tsv")
su<-read.table("data/rnaseq/up.slow.sum.tsv")
fd<-read.table("data/rnaseq/dn.fast.sum.tsv")
sd<-read.table("data/rnaseq/dn.slow.sum.tsv")
fold<-list(su$V2, fu$V2, sd$V2, fd$V2)
#names(fold)<-c("up\nslow", "up\nfast", "down\nslow", "down\nfast")
par(mar=c(4,5,1.2,0))
boxplot(fold, ylab="logFC", col=c("purple","yellow"), axes = F)
axis(1,at=1:4,labels = rep("",4))
axis(2)
box()
mylab<-c("up\nslow", "up\nfast", "down\nslow", "down\nfast")
par(xpd=NA)
text(1:4,-18,mylab)
mtext("C", adj=0.7, line=-1.8, outer=T, cex=1.3);
dev.off()

