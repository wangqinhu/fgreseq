library(squash)
c2<-read.table("data/cor/cor.tsv",
               header = T,
               na.strings = "NA",
               check.names = FALSE,
               sep = "\t")
pdf("data/cor/cor.pdf", 4, 4)
par(mar=c(2.5,2.5,2.5,2.5))
map<-corrogram(cor(c2, use = "complete.obs", method = "spearman"),
               key = FALSE)
vkey(map,
     side = 4,
     x = 2.5,
     y = 1.5,
     stretch = 0.55,
     title = "Spearman\ncorrelation")
dev.off()
