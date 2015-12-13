library(squash)
library(plotrix)

x<-read.table("data/pnps/pnps.tsv")

pdf("data/pnps/positive.pdf", 6, 6)
layout(matrix(c(1,2,3,4),2,2,byrow = TRUE), c(1,1), c(1,1),respect = T)

#############
# positive 1 #
#############

xl<-dim(x)
# pn - ps
pn_ps<-rep(NA, xl[1]*10)
dim(pn_ps)<-c(xl[1],10)
rownames(pn_ps)<-x[,1]
# marker
psm<-rep(NA, xl[1])
dim(psm)<-c(xl[1],1)
rownames(psm)<-x[,1]
for (i in seq(1,xl[1])) {
  for (j in seq(1,10)) {
    pn_ps[i,j] <- x[i,j*4-2] - x[i,j*4-1]
    if (pn_ps[i,j] > 0) {
      psm[i]<-TRUE
    } 
  }
}
write.table(pn_ps, "data/pnps/positive.txt", quote = F, row.names = T,col.names = F)
write.table(rownames(psm)[psm>0], "data/pnps/positive.temp.txt", quote = F, row.names = F,col.names = F)
system("cat data/pnps/positive.temp.txt | grep 'FGRRES' | cut -f1 > data/pnps/positive1.id.txt && rm data/pnps/positive.temp.txt")
system("./isc data/2speed/list.fast data/pnps/positive1.id.txt > data/pnps/positive1.fast")
system("./isc data/2speed/list.slow data/pnps/positive1.id.txt > data/pnps/positive1.slow")
system("./isc data/2speed/list.fast data/pnps/positive.txt > data/pnps/positive.fast")
system("./isc data/2speed/list.slow data/pnps/positive.txt > data/pnps/positive.slow")

par(mar=c(4.25,4,1.5,0.5))
z<-hist(pn_ps, breaks = 50, plot=F)
xt<-z$breaks
gap.barplot(z$density,
            gap=c(25,114),
            xlab="pN - pS",
            ylab = "Density",
            col = c(rep("lightblue",54), rep("red", 16)),
            xtics = xt,
            xlim = c(-0.1,0.1),
            xaxt='n')

axis(1,at=c(-0.1,0,0.1))
axis(2,at=c(10,20,120))

from<-25
axis.break(2,from,breakcol="honeydew",style="gap")
axis.break(2,from*(1+0.02),breakcol="black",style="zigzag")
axis.break(4,from*(1+0.02),breakcol="black",style="zigzag")

mtext("a", adj=0.01, line=-2, outer=T)

############
# classpro #
############
fast<-6092
slow<-8072
positive<-read.table("data/classpro/positive.tsv")
p<-as.matrix(positive)
p[1,]<-p[1,]/slow
p[2,]<-p[2,]/fast
par(mar=c(4.25,6,1.5,0.5))
barplot(prop.table(p,2),
        col = c("purple","yellow"),
        ylab = "Ratio of subgenome",
        xlim = c(0,7),
        cex.names = 0.75
)
legend(5, 1, rev(rownames(p)), fill = c("yellow","purple"),cex=0.8)
mtext("b", adj=0.56, line=-2, outer=T)


#############
# positive 2 #
#############
pns<-c(0)
pss<-c(0)
for (i in seq(1,10)) {
  pns<-pns+x[,i*4-2]
  pss<-pss+x[,i*4-1]
}

# plot all
par(mar=c(4.25,4,1.5,0.5))
hist2(log2(pss/10),log2(pns/10), key = vkey, key.args = list(x=-1,y=-15.5,stretch = 1), nx=100, xlim=c(-16,0), ylim=c(-16,0), xlab = "log2(pS)", ylab="log2(pN)", colFn = jet)
abline(a = 0, b = 1, col = 2)
# get positive2
positive2<-x[rownames(x)[pns>pss & pss>0],]
write.table(positive2, "data/pnps/positive2.txt", quote = F, row.names = F,col.names = F)
system("cat data/pnps/positive2.txt | cut -d ' ' -f 1 > data/pnps/positive2.id.txt")
system("./isc data/2speed/list.fast data/pnps/positive2.txt > data/pnps/positive2.fast")
system("./isc data/2speed/list.slow data/pnps/positive2.txt > data/pnps/positive2.slow")
# plot positive2.slow
x<-read.table("data/pnps/positive2.slow")
pn_s<-c(0)
ps_s<-c(0)
for (i in seq(0,9)) {
  pn_s<-pn_s+x[,i*4+2]
  ps_s<-ps_s+x[,i*4+3]
}
points(log2(ps_s/10),log2(pn_s/10),pch=20,cex=0.8,col="purple")
# plot positive2.fast
x<-read.table("data/pnps/positive2.fast")
pn_f<-c(0)
ps_f<-c(0)
for (i in seq(0,9)) {
  pn_f<-pn_f+x[,i*4+2]
  ps_f<-ps_f+x[,i*4+3]
}
points(log2(ps_f/10),log2(pn_f/10),pch=20,cex=0.8,col="yellow")
legend("topleft", c("fast","slow", "pN=pS"), pch = c(20,20,-1), lty=c(-1,-1,1), bg ="lightgreen", col = c("yellow", "purple", "red"))
mtext("c", adj=0.01, line=-20, outer=T)

##############
# boxplot pN #
##############
y<-list(pn_s/10,pn_f/10)
names(y)<-c("slow","fast")
par(mar=c(4.25,6,1.5,1))
boxplot(y,col=c("purple","yellow"),ylab="pN")
mtext("d", adj=0.56, line=-20, outer=T)
dev.off()
