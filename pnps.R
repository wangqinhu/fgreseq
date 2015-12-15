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
pns<-c(0)
pss<-c(0)
pn_ps<-c(0)
for (i in seq(1,21)) {
  pns<-pns+x[,i*4-2]
  pss<-pss+x[,i*4-1]
  pn_ps<-(pns-pss)/21
}

psm<-rep(FALSE, xl[1])
for (i in 1:length(pns)) {
  if (pn_ps[i] > 0) {
    psm[i]<-TRUE
  }
}

names(psm)<-x[,1]
names(pn_ps)<-x[,1]

write.table(pn_ps, "data/pnps/positive1.txt", quote = F, row.names = T,col.names = F)
write.table(names(psm)[psm>0], "data/pnps/positive1.id.txt", quote = F, row.names = F,col.names = F)
system("./isc data/2speed/list.fast data/pnps/positive1.id.txt > data/pnps/positive1.id.fast")
system("./isc data/2speed/list.slow data/pnps/positive1.id.txt > data/pnps/positive1.id.slow")
system("./isc data/2speed/list.fast data/pnps/positive1.txt > data/pnps/positive1.fastall.txt")
system("./isc data/2speed/list.slow data/pnps/positive1.txt > data/pnps/positive1.slowall.txt")

par(mar=c(4.25,4,1.5,0.5))
br<-100
z<-hist(pn_ps, breaks = br, plot=F)
xt<-z$breaks
gap.barplot(z$density,
            gap=c(70,180),
            xlab="pN - pS",
            ylab = "Density",
            col = c(rep("lightblue",sum(z$breaks<=0)), rep("red", br-sum(z$breaks<=0))),
            xtics = xt,
            xlim = c(-0.03,0.03),
            xaxt='n')

axis(1,at=c(-0.02,-0.01,0,0.01,0.02))
axis(2,at=c(25))

from<-70
axis.break(2,from,breakcol="honeydew",style="gap")
axis.break(2,from*(1+0.02),breakcol="black",style="zigzag")
axis.break(4,from*(1+0.02),breakcol="black",style="zigzag")

mtext("a", adj=0.01, line=-2, outer=T)


############
# classpro #
############
fast<-6353
slow<-7811
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
for (i in seq(1,21)) {
  pns<-pns+x[,i*4-2]
  pss<-pss+x[,i*4-1]
}

# plot all
par(mar=c(4.25,4,1.5,0.5))
hist2(log2(pss/21),log2(pns/21), key = vkey, key.args = list(x=-1,y=-15.5,stretch = 1), nx=100, xlim=c(-16,0), ylim=c(-16,0), xlab = "log2(pS)", ylab="log2(pN)", colFn = jet)
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
mtext("c", adj=0.01, line=-20, outer=T)

##############
# boxplot pN #
##############
y<-list(pn_s/21,pn_f/21)
names(y)<-c("slow","fast")
par(mar=c(4.25,6,1.5,1))
boxplot(y,col=c("purple","yellow"),ylab="pN")
mtext("d", adj=0.56, line=-20, outer=T)
dev.off()
