# SP number
fsf <-
  matrix(c(494, 6092-494, 122, 8072-122),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# postive1 selection number
fsf <-
  matrix(c(2440, 6092-2440, 2179, 8072-2179),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# postive2 selection number
fsf <-
  matrix(c(276, 6092-276, 73, 8072-73),
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
  matrix(c(81, 6025-81, 25, 8140-25),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value

# refined
fsf <-
  matrix(c(51, 6025-81, 10, 8140-25),
         nrow = 2,
         dimnames = list(Class = c("T", "F"),
                         Genome = c("Fast", "Slow")))
fsft<-fisher.test(fsf, alternative = "greater")
fsf
fsft$p.value
