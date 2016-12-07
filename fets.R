# SP number
fsf <-
  matrix(c(504, 6353-504, 112, 7811-112),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# postive selection number
fsf <-
  matrix(c(609, 6353-609, 572, 7811-572),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# rnaseq - up
fsf <-
  matrix(c(1177, 6353-1177, 1066, 7811-1066),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# rnaseq - down
fsf <-
  matrix(c(1120, 6353-1120, 1374, 7811-1374),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# rnaseq - total
fsf <-
  matrix(c(2297, 6353-2297, 2440, 7811-2440),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value
