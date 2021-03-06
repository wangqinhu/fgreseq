library(squash)
pdf("data/go/go_fast.pdf",width = 5.6,height = 3.2)

layout(matrix(c(1,1,1,4,2,3),2,3,byrow = TRUE),c(1.5,1,1),c(5,1))

go<-read.table("data/go/go_fast.reduced.txt", header = T, sep = "\t", check.names = T)
gofold<-(go$T/(go$T+go$NAT))/(go$R/(go$R+go$NAR))
gof<--log10(go$P)

par(mar=c(0,1,1,1))

plot(gof,seq(1,length(go$GOID)),
     xlab="-log10(p)",
     ylab="",
     axes=F,
     xlim=c(0,120),
     col="white",
     adj=0.15
     )

axis(1,at=seq(0,max(gof)+1,8))

abline(h=seq(0.5,50.5,1),lty=3,col="grey75",lwd=0.6)
abline(v=seq(-4,max(gof)+1,2),lty=3,col="grey75",lwd=0.6)
rect(max(gof)+1.2,1-0.5,125.8,3-0.5,col="#CCCCFF", border = "white")
rect(max(gof)+1.2,3-0.5,125.8,17-0.5,col="#FFFFCC", border = "white")
rect(max(gof)+1.2,17-0.5,125.8,21-0.5,col="#FFCCCC", border = "white")

points(gof,seq(1,length(go$GOID)),
     col=jet(20)[rank(go$T)],
     pch=16,
     cex=0.5+log2(gofold)*0.5
)

text(max(gof)+2,seq(1,length(go$GOID)),paste(go$GOID,go$Term),cex=0.6,adj = 0)

abline(v=119,col="white", lwd=2)
abline(v=max(gof)+1)
text(122,1.5,"CC",cex=0.6)
text(122,9.5,"MF",cex=0.6)
text(122,18.5,"BP",cex=0.6)
box()



# legend 1
par(mar=c(2.2,1,0.5,2),xpd = T)
barplot(rep(1,11),border = "NA", space = 0,
     ylab="",
     xlab="",
     xlim=c(0.40,10.54),
     axes = F, col=jet(11) )
box()
text(6,-0.8,"Number of enriched genes", adj=0.55)

# legend 2
par(mar=c(2.2,1,0.5,2))
plot(c(1:5),rep(1,5),
     ylab="",
     xlab="",
     xlim=c(1,5.2),
     axes = F,pch=16, cex=0.5+fivenum(log2(gofold)*0.5),col="green")
box()
text(3,-0.1,"Fold change", adj=0.5)

# legend main
plot(0,0, axes = F,col="NA")
text(0,-2.7,"-log10(p-value)", adj=0.5)

dev.off()