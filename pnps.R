library(squash)
x<-read.table("data/pnps/pnps.tsv")

pdf("data/pnps/positive2.pdf", 6.8, 4.5)
layout(matrix(c(1,2),1,2,byrow = TRUE), c(1.8,1), c(1.8,1), respect = T)

pns<-c(0)
pss<-c(0)
for (i in seq(0,9)) {
  pns<-pns+x[,i*4+2]
  pss<-pss+x[,i*4+3]
}

# plot all
par(mar=c(5,4,0.5,1))
hist2(log2(pss/10),log2(pns/10), key = hkey, key.args = list(stretch = 1), nx=100, xlim=c(-16,0), ylim=c(-16,0), xlab = "log2(pS)", ylab="log2(pN)", colFn = jet)
abline(a = 0, b = 1, col = 2)
# get postive2
postive2<-x[rownames(x)[pns>pss & pss>0],]
write.table(postive2, "data/pnps/postive2.txt", quote = F, row.names = F,col.names = F)
system("./isc data/2speed/list.fast data/pnps/postive2.txt > data/pnps/postive2.fast")
system("./isc data/2speed/list.slow data/pnps/postive2.txt > data/pnps/postive2.slow")
# plot postive2.slow
x<-read.table("data/pnps/postive2.slow")
pn_s<-c(0)
ps_s<-c(0)
for (i in seq(0,9)) {
  pn_s<-pn_s+x[,i*4+2]
  ps_s<-ps_s+x[,i*4+3]
}
points(log2(ps_s/10),log2(pn_s/10),pch=20,cex=0.8,col="purple")
# plot postive2.fast
x<-read.table("data/pnps/postive2.fast")
pn_f<-c(0)
ps_f<-c(0)
for (i in seq(0,9)) {
  pn_f<-pn_f+x[,i*4+2]
  ps_f<-ps_f+x[,i*4+3]
}
points(log2(ps_f/10),log2(pn_f/10),pch=20,cex=0.8,col="yellow")
legend("topleft", c("fast","slow", "pN=pS"), pch = c(20,20,-1), lty=c(-1,-1,1), bg ="lightgreen", col = c("yellow", "purple", "red"))
mtext("A", adj=0.005, line=-1.5, outer=T, cex=1.5)

# boxplot pN
y<-list(pn_s/10,pn_f/10)
names(y)<-c("slow","fast")
par(mar=c(5,4,0.5,1))
boxplot(y,col=c("purple","yellow"),ylab="pN")
mtext("B", adj=0.66, line=-1.5, outer=T, cex=1.5)
dev.off()