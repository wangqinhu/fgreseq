# SP number
fsf <-
  matrix(c(504, 6353-504, 112, 7811-112),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# postive1 selection number
fsf <-
  matrix(c(3201, 6353-3201, 2750, 7811-2750),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# postive2 selection number
fsf <-
  matrix(c(313, 6353-313, 131, 7811-131),
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

# infection
fsf <-
  matrix(c(72, 6353-72, 8, 7811-8),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value