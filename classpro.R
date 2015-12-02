fast<-6092
slow<-8072
genome<-read.table("data/classpro/genome.tsv")
g<-as.matrix(genome)
g[1,]<-g[1,]/fast
g[2,]<-g[2,]/slow
barplot(g, 
        beside = T,
        col = c("yellow","purple"),
        ylab = "Ratio of subgenome"
        )
legend("topleft", box.col = "white", rownames(g), fill = c("yellow","purple"))

rnaseq<-read.table("data/classpro/rnaseq.tsv")
r<-as.matrix(rnaseq)
r[1,]<-r[1,]/fast
r[2,]<-r[2,]/slow
barplot(prop.table(r,2), 
        col = c("yellow","purple"),
        ylab = "Ratio of subgenome",
        xlim = c(0,6)
)
legend(5, 1, rownames(g), fill = c("yellow","purple"))
        
positive<-read.table("data/classpro/positive.tsv")
p<-as.matrix(positive)
p[1,]<-p[1,]/fast
p[2,]<-p[2,]/slow
barplot(prop.table(p,2), 
        col = c("yellow","purple"),
        ylab = "Ratio of subgenome",
        xlim = c(0,6)
)
legend(5, 1, rownames(g), fill = c("yellow","purple"))
