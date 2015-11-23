library(squash)
x<-read.table("data/pnps/pnps.tsv")

p1<-x[rownames(x)[x[,2]>x[,3]],1]
p2<-x[rownames(x)[x[,6]>x[,7]],1]
p3<-x[rownames(x)[x[,10]>x[,11]],1]
p4<-x[rownames(x)[x[,14]>x[,15]],1]
p5<-x[rownames(x)[x[,18]>x[,19]],1]
p6<-x[rownames(x)[x[,22]>x[,23]],1]
p7<-x[rownames(x)[x[,26]>x[,27]],1]
p8<-x[rownames(x)[x[,30]>x[,31]],1]
p9<-x[rownames(x)[x[,34]>x[,35]],1]
p10<-x[rownames(x)[x[,38]>x[,39]],1]

write.table(p1, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F)
write.table(p2, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p3, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p4, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p5, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p6, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p7, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p8, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p9, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)
write.table(p10, "data/pnps/postive.txt", quote = F, row.names = F,col.names = F, append=T)

system("cat data/pnps/postive.txt | sort | uniq > data/pnps/postive1.txt")
