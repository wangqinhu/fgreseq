library(squash)
pdf("data/go/go_ir.pdf",width = 4.2,height = 3)

layout(matrix(c(1,1,1,4,2,3),2,3,byrow = TRUE),c(1.5,1,1),c(5,1))

go<-read.table("data/go/go_infection.txt", header = T, sep = "\t", check.names = T)
gofold<-(go$T/(go$T+go$NAT))/(go$R/(go$R+go$NAR))
gof<--log10(go$P)

par(mar=c(0,1,1,1))

plot(gof,seq(1,length(go$GOID)),
     xlab="-log10(p)",
     ylab="",
     axes=F,
     xlim=c(0,50),
     col="white",
     adj=0.15
)

par(cex.axis=0.8)
axis(1,at=seq(0,max(gof)+1,8))

abline(h=seq(0.5,50.5,1),lty=3,col="grey75",lwd=0.6)
abline(v=seq(-4,max(gof)+1,2),lty=3,col="grey75",lwd=0.6)
rect(max(gof)+1.2,1-0.5,137,2-0.5,col="#CCCCFF", border = "white")
rect(max(gof)+1.2,2-0.5,137,8-0.5,col="#FFFFCC", border = "white")
rect(max(gof)+1.2,8-0.5,137,20-0.5,col="#FFCCCC", border = "white")

points(gof,seq(1,length(go$GOID)),
       col=jet(19)[rank(go$T)],
       pch=16,
       cex=0.5+log2(gofold)*0.35
)

text(max(gof)+2,seq(1,length(go$GOID)),paste(go$GOID,go$Term),cex=0.6,adj = 0)

abline(v=48.5,col="white", lwd=2)
abline(v=max(gof)+1)
text(50.3,1,"CC",cex=0.6)
text(50.3,4.5,"MF",cex=0.6)
text(50.3,13.5,"BP",cex=0.6)
box()



# legend 1
par(mar=c(2.2,1,0.5,2),xpd = T)
barplot(rep(1,11),border = "NA", space = 0,
        ylab="",
        xlab="",
        xlim=c(0.40,10.54),
        axes = F, col=jet(11) )
box()
text(6,-0.8,"Number of enriched genes", adj=0.55, cex = 0.8)

# legend 2
par(mar=c(2.2,1,0.5,2))
plot(c(1:5),rep(1,5),
     ylab="",
     xlab="",
     xlim=c(1,5.2),
     axes = F,pch=16, cex=0.5+fivenum(log2(gofold)*0.45),col="green")
box()
text(3,-0.1,"Fold change", adj=0.5, cex = 0.8)

# legend main
plot(0,0, axes = F,col="NA")
text(0,-2.7,"-log10(p-value)", adj=0.5, cex = 0.8)

dev.off()