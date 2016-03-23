# functions
rowSd <- function (x, na.rm = FALSE, dims = 1L) 
{
  if (is.data.frame(x)) 
    x <- as.matrix(x)
  if (!is.array(x) || length(dn <- dim(x)) < 2L) 
    stop("'x' must be an array of at least two dimensions")
  if (dims < 1L || dims > length(dn) - 1L) 
    stop("invalid 'dims'")
  z <- rep(NULL, dn[1])
  for (i in 1:dn[1]) {
    z[i] <- sd(x[i,])
  }
  z
}

error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length/2, ...)
}

pdf("data/var/varlof.pdf", 4, 7)
layout(matrix(c(1,2),2,1), c(0.6,1), TRUE)
# size factor
sf <- c(7082500,
        19221567,
        7082500,
        1891454,
        2782419)

# raw freq
freq1 <- read.table("data/var/var_freq.txt", header = TRUE, check.names = FALSE)
pc1 <- rowMeans(freq1) * 100
sd1 <- rowSd(freq1) * 100

# normalized freq
freq2 <- freq1 / sf * sum(sf)
pc2 <- rowMeans(freq2)
pc2 <- pc2 / sum(pc2) * 100
sd2 <- rowSd(freq2)/sum(rowMeans(freq2)) * 100

# plot
f<-rbind(pc1,pc2)
rownames(f) <- c("percentage", "normalized percentage")
par(mar=c(4,4.5,1,1))
barx <- barplot(f,
                beside = T,
                ylim = c(0,65),
                xaxt="n",
                col = c("lightblue", "pink")
                )
lablist <- rbind("", colnames(f))
text(barx, -2.5,
     cex = 0.9,
     font = 2,
     labels=lablist,
     srt=45,
     pos=2,
     xpd=TRUE)
text(-0.5, 66, "(%)", xpd=TRUE)
error.bar(barx, f, rbind(sd1,sd2) )
legend("top",
       box.col = "white",
       rownames(f),
       col = c("lightblue", "pink"),
       pch=19)

lof<-read.table("data/var/lof_num.txt")

par(mar=c(4.5,4.5,1,1))
barplot(rev(lof$num),
        names.arg = rev(rownames(lof)),
        las=1,
        xlab = "Number of LOF genes",
        xlim = c(0, 700),
        col = "#5c87b4",
        space = 0.67,
        horiz = TRUE
)
abline(v=350, lty=2, col = "grey95")
dev.off()