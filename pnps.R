pdf("data/pnps/positive.pdf", 6, 6)
layout(matrix(c(1,2,3,4),2,2,byrow = TRUE), c(1,1), c(1,1),respect = T)

library(squash)
library(plotrix)

#############
# positive 1 #
#############

# pn - ps
x<-read.table("data/pnps/pnps.tsv")
xl<-dim(x)

pn_ps<-rep(NA, xl[1]*21)
dim(pn_ps)<-c(xl[1],21)
rownames(pn_ps)<-x[,1]
# marker
psm<-rep(NA, xl[1])
dim(psm)<-c(xl[1],1)
rownames(psm)<-x[,1]
pp<-pn_ps
for (i in seq(1,xl[1])) {
  for (j in seq(1,21)) {
    pn_ps[i,j] <- x[i,j*4-2] - x[i,j*4-1]
    if (pn_ps[i,j] > 0) {
      pp[i,j] <- 1;
    }
  }
}

for (i in seq(1,xl[1])) {
  psm[i]<-sum(pp[i,], na.rm = T)
}

num_pair<-11

write.table(pn_ps, "data/pnps/pn_ps.txt", quote = F, row.names = T,col.names = F)
write.table(rownames(psm)[psm>=num_pair], "data/pnps/positive1.txt", quote = F, row.names = F,col.names = F)
system("cat data/pnps/positive1.txt | grep 'FGRRES' | cut -f1 > data/pnps/positive1.id.txt")
system("./isc data/2speed/list.fast data/pnps/positive1.id.txt > data/pnps/positive1.fast.id")
system("./isc data/2speed/list.slow data/pnps/positive1.id.txt > data/pnps/positive1.slow.id")

br<-11
zc<-rep(0,22)
for (i in seq(1,22)) {
  zc[i]<-sum(psm==(i-1))
}

par(mar=c(4.5,4,1,1))
gap.barplot(zc,
            gap=c(1500,7500),
            xlab="No. of the ortholog pairs for pN-pS > 0",
            ylab = "Number of genes",
            xaxt='n',
            col = c(rep("lightblue",br), rep("red", 22-br))
)
axis(1, at =seq(1,22,5), labels = seq(0,21,5))
axis(2,at=c(0,500,1000))

from<-1500
axis.break(2,from,breakcol="honeydew",style="gap")
axis.break(2,from*(1+0.02),breakcol="black",style="zigzag")
axis.break(4,from*(1+0.02),breakcol="black",style="zigzag")

mtext("A", adj=0.01, line=-1.5, outer=T)


#############
# positive 2 #
#############
pns<-c(0)
pss<-c(0)
for (i in seq(1,21)) {
  pns<-pns+x[,i*4-2]
  pss<-pss+x[,i*4-1]
}

# plot all
par(mar=c(4.5,4.5,1,0.5))
hist2(log2(pss/21),log2(pns/21), key = vkey, key.args = list(x=-1,y=-15.5,stretch = 1), nx=100, xlim=c(-16,0), ylim=c(-16,0), xlab = "log2(pS)", ylab="log2(pN)", colFn = jet)
abline(a = 0, b = 1, col = 2)
# get positive2x
positive2<-x[rownames(x)[pns>pss & pss>0],]
write.table(positive2, "data/pnps/positive2.txt", quote = F, row.names = F,col.names = F)
system("cat data/pnps/positive2.txt | cut -d ' ' -f 1 > data/pnps/positive2.id.txt")
system("./isc data/2speed/list.fast data/pnps/positive2.txt > data/pnps/positive2.fast")
system("./isc data/2speed/list.slow data/pnps/positive2.txt > data/pnps/positive2.slow")
# plot positive2.slow
x<-read.table("data/pnps/positive2.slow")
pn_s<-c(0)
ps_s<-c(0)
for (i in seq(0,20)) {
  pn_s<-pn_s+x[,i*4+2]
  ps_s<-ps_s+x[,i*4+3]
}
points(log2(ps_s/21),log2(pn_s/21),pch=20,cex=0.8,col="purple")
# plot positive2.fast
x<-read.table("data/pnps/positive2.fast")
pn_f<-c(0)
ps_f<-c(0)
for (i in seq(0,20)) {
  pn_f<-pn_f+x[,i*4+2]
  ps_f<-ps_f+x[,i*4+3]
}
points(log2(ps_f/21),log2(pn_f/21),pch=20,cex=0.8,col="yellow")
legend("topleft", c("fast","slow", "pN=pS"), pch = c(20,20,-1), lty=c(-1,-1,1), bg ="lightgreen", col = c("yellow", "purple", "red"))
mtext("B", adj=0.53, line=-1.5, outer=T)



##############
# boxplot pN #
##############

# define all postive

system("cat data/pnps/positive1.id.txt data/pnps/positive2.id.txt | sort | uniq > data/pnps/positive.id.txt")
system("./isc data/2speed/list.fast data/pnps/positive.id.txt > data/pnps/positive.fast.id")
system("./isc data/2speed/list.slow data/pnps/positive.id.txt > data/pnps/positive.slow.id")
system("./isc data/pnps/positive.fast.id data/pnps/pnps.tsv > data/pnps/positive.fast")
system("./isc data/pnps/positive.slow.id data/pnps/pnps.tsv > data/pnps/positive.slow")

x<-read.table("data/pnps/positive.slow")
# plot positive2.slow
pn_s<-c(0)
for (i in seq(0,20)) {
  pn_s<-pn_s+x[,i*4+2]
}
# plot positive2.fast
x<-read.table("data/pnps/positive.fast")
pn_f<-c(0)
for (i in seq(0,20)) {
  pn_f<-pn_f+x[,i*4+2]
}
y<-list(pn_s/21*100,pn_f/21*100)
names(y)<-c("slow","fast")
par(mar=c(3.5,4,2,1))
boxplot(y,col=c("purple","yellow"),ylab=paste("pN (x 0.01)"),outline=F, ylim=c(0,1.5))

yt<-t.test(y$fast,y$slow, alternative = "g")
yt$p.value

mtext("C", adj=0.01, line=-20, outer=T)


############
# classpro #
############
positive<-read.table("data/classpro/positive.tsv")
genome<-read.table("data/classpro/genome.tsv")
p<-as.matrix(positive/genome)
par(mar=c(3.5,4.5,2,0.5))
barx<-barplot(prop.table(p,2),
              col = c("purple","yellow"),
              ylab = "Proportion",
              xlim = c(0,8),
              xaxt="n"
)
text(barx+0.6, -0.1,
     cex = 0.8,
     labels=colnames(p),
     srt=45,
     pos=2,
     font = 2,
     xpd=TRUE)
legend(6.2, 1, rev(rownames(p)), fill = c("yellow","purple"),cex=0.7)
mtext("D", adj=0.53, line=-20, outer=T)


dev.off()
