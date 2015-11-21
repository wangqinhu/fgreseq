##
## This code calculates syn and nonsyn values for an alignment
##
## Notice:
##                                                                 2/05/99
## Unless otherwise indicated, this information, consisting of source code,
## documentation, and executable programs, has been authored by an employee or
## employees of the University of California under LACC # ______ , operator of the
## Los Alamos National Laboratory under Contract No. W-7405-ENG-36 with the U.S.
## Department of Energy. The U.S. Government has rights to use, reproduce, and
## distribute this information. The public may copy and use this information
## without charge, make derivative works, distribute, and publicly display
## provided that this Notice and any statement of authorship are reproduced on all
## copies.  However, the public may not incorporate this information in any
## commercial or proprietary product.  Neither the Government nor the University
## makes any warranty, express or implied, or assumes any liability or
## responsibility for the use of this information.
##
## Read the filenames from the command line

#define PAIRLISTSIZE  20000
#define CODONLISTSIZE 400
#define LINEMAX       1024

#include <string.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

enum baseNumber { T=0, C=1, A=2, G=3 };
const char *baseletter = "TCAG";

const char *aminoAcid  = "FFLLLLLLIIIMVVVV\
                          SSSSPPPPTTTTAAAA\
                          YYZZHHQQNNKKDDEE\
                          CCZWRRRRSSRRGGGG";
const int synPotential[]= { 1,1,2,2,3,3,4,4,2,2,2,0,3,3,3,3,
			    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
			    1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
			    1,1,1,0,3,3,4,4,1,1,2,2,3,3,3,3 };


int invalid(const char codon[3]) {
  fprintf(stderr,"What is %c%c%c?\n",codon[0],codon[1],codon[2]);
  exit(EXIT_FAILURE);
  return 0;
}

#define BASE_TO_NUMBER(codon,i) \
      ((codon[i]=='T') ? T: \
       (codon[i]=='C') ? C: \
       (codon[i]=='A') ? A: \
       (codon[i]=='G') ? G: invalid(codon))

int
to_number (const char codon[3])
{
    /* NOTE: the scheme for converting codons to numbers takes the
     * middle base as the most significant, followed by the left,
     * and finally the last base is least significant
     */
  int i, result=0;
  for (i=0; i<3; i++) 
    if ((codon[i] == '-') || (codon[i] == 'N') ||
        (codon[i] == 'R') || codon[i] == ' ')
      return -1;

  result = 16*BASE_TO_NUMBER(codon,1);
  result += 4*BASE_TO_NUMBER(codon,0);
  result += 1*BASE_TO_NUMBER(codon,2);
  return result;
}

double
to_synPotential (const char codon[3])
{
  const int codonNumber = to_number(codon);
  return (codonNumber < 0)?-1:synPotential[codonNumber]/3.0;
}

double
to_nonsynPotential (const char codon[3])
{
  const int codonNumber = to_number(codon);
  return (codonNumber < 0)?-1:3-synPotential[codonNumber];
}

char
to_aminoacid (const char codon[3])
{
  const int codonNumber = to_number(codon);
  return (codonNumber<0)?' ':aminoAcid[codonNumber];
}

int 
main(int argc, char *argv[])
{
  const char *me = argv[0];
  const char *codonInputFile;
  FILE *CIF;
  char line[LINEMAX+1];

  double *sp = NULL, *np =NULL;
  double *s = NULL, *n = NULL;

  long npairs = -1;

  double pSyn_ave=0, pNon_ave=0;
  double dSyn_ave=0, dNon_ave=0;

  double sum_scov = 0, sum_ncov = 0;
  double sum_scov_d = 0, sum_ncov_d = 0;

  double scov = 0, ncov = 0;

  long ipa, pair;

  int    (*pairlist)   [2];
  double (*synPoten)   [CODONLISTSIZE];
  double (*syn)        [CODONLISTSIZE];
  double *sumSynPoten;
  double (*nonPoten)   [CODONLISTSIZE];
  double (*non)        [CODONLISTSIZE];
  double *sumNonPoten;
  int    *nCodons    ;
  double *psTable    ;
  double *pnTable    ;
  double *dsTable    ;
  double *dnTable    ;

  pairlist    = malloc(PAIRLISTSIZE*sizeof*pairlist);
  synPoten    = malloc(PAIRLISTSIZE*sizeof*synPoten);
  syn         = malloc(PAIRLISTSIZE*sizeof*syn);
  sumSynPoten = malloc(PAIRLISTSIZE*sizeof*sumSynPoten);
  nonPoten    = malloc(PAIRLISTSIZE*sizeof*nonPoten);
  non         = malloc(PAIRLISTSIZE*sizeof*non);
  sumNonPoten = malloc(PAIRLISTSIZE*sizeof*sumNonPoten);
  nCodons     = malloc(PAIRLISTSIZE*sizeof*nCodons);
  psTable     = malloc(PAIRLISTSIZE*sizeof*psTable);
  pnTable     = malloc(PAIRLISTSIZE*sizeof*pnTable);
  dsTable     = malloc(PAIRLISTSIZE*sizeof*dsTable);
  dnTable     = malloc(PAIRLISTSIZE*sizeof*dnTable);

  if (! (pairlist    &&
	 synPoten    &&
	 syn         &&
	 sumSynPoten &&
	 nonPoten    &&
	 non         &&
	 sumNonPoten &&
	 nCodons     &&
	 psTable     &&
	 pnTable     &&
	 dsTable     &&
	 dnTable     ) ) {
    fprintf(stderr, "Allocation failed, inadequate memory -- value for PAIRLISTSIZE=%d is probably too large\n",PAIRLISTSIZE);
    exit(EXIT_FAILURE);
  }

  if (argc) {
    const char *tmp = me + strlen(me);
    while (*--tmp != '/' && tmp > me);
    if (*tmp == '/') tmp++;
    me = tmp;
  } else {
    me = "<program>";
  }
  if (argc != 2) {
   printf("Usage: %s codons.##\n", me);
   puts(  "       Computes covariances of all pairwise comparisons.\n");
   puts(  "Actually, computes covariances for all _pairs_ of pirwise comparisons!\n");
   exit(EXIT_FAILURE);
  }
  codonInputFile = argv[1];
  if (!((CIF=fopen(codonInputFile,"r")))) {
    fprintf(stderr, "Cant open codon input file [%s]\n", codonInputFile);
    exit(EXIT_FAILURE);
  }


  while (fgets(line,LINEMAX,CIF)) {
    char b1, b2, b3;
    int num1, num2;
    int i;
    char ca[3], cb[3];
    double rsyn, rnon;
    double spi, npi;

    line[strlen(line)-1] = '\0';
    if (!strncmp("Codon", line, 5)) continue;
    if ((sscanf(line,"This%cis%ccomparison%c%d x %d",&b1,&b2,&b3,&num1,&num2)
	 == 5) && (b1==' ') && (b2==' ') && (b3==' ')) {
      npairs++;
      if (npairs > PAIRLISTSIZE) {
	fprintf(stderr, "Increase PAIRLISTSIZE\n");
	exit(EXIT_FAILURE);
      }
      pairlist[npairs][0] = num1;
      pairlist[npairs][1] = num2;
      sp = synPoten[npairs];
      s = syn[npairs];          /* sets pointer so s[i] = syn[npairs][i] */
      sumSynPoten[npairs] = 0;
      np = nonPoten[npairs];
      n = non[npairs];
      sumNonPoten[npairs] = 0;
      nCodons[npairs] = 0;
      continue;
    }
    rsyn = rnon = 0;
    if (sscanf(line,"%d %*[^ ] %3c %3c %*[^ ] %*[^ ] %lf %lf",
	       &i,ca,cb,&rsyn,&rnon) < 3) {
      fprintf(stderr, "Unparseable line: '%s'\n", line);
      exit(EXIT_FAILURE);
    }
    if (i > CODONLISTSIZE) {
      fprintf(stderr, "Increase CODONLISTSIZE=%d at least to %d\n",
              CODONLISTSIZE,i);
      exit(EXIT_FAILURE);
    }
    if ( (to_number(ca) < 0) || (to_number(cb) < 0) ) {
      rsyn = spi = 0;
      rnon = npi = 0;
    } else {
      spi = (to_synPotential(ca) + to_synPotential(cb))/2;
      npi = 3 - spi;
    }

    if (! (s && n && sp && np) ) {
      fprintf(stderr,"Possible input file syntax error\n");
      exit(EXIT_FAILURE);
    }
    s[i] = rsyn; n[i] = rnon; sp[i] = spi; np[i] = npi;
    sumSynPoten[npairs] += spi;
    sumNonPoten[npairs] += npi;
    nCodons[npairs]++;
  }
  fclose(CIF);

  npairs++;

  for (pair = 0; pair < npairs; pair++) {
    double ssum = 0;
    double nsum = 0;
    double ps, pn;
    int i;

    if (0) fprintf(stderr,"Doing %ld of %ld\n", pair, npairs);
    s  = syn     [pair];
    sp = synPoten[pair];
    n  = non     [pair];
    np = nonPoten[pair];

    for (i = 0; i < nCodons[pair]; i++) {
      ssum += s[i];
      nsum += n[i];
    }

    pSyn_ave += psTable[pair] = ps = ssum / sumSynPoten[pair];
    pNon_ave += pnTable[pair] = pn = nsum / sumNonPoten[pair];
    dSyn_ave += dsTable[pair] = -0.75*log(1-4*ps/3);
    dNon_ave += dnTable[pair] = -0.75*log(1-4*pn/3);

    for (i = 0; i < nCodons[pair]; i++) {
      s[i] -= ps*sp[i];
      n[i] -= pn*np[i];
    }

  }

  pSyn_ave /= npairs;
  pNon_ave /= npairs;
  dSyn_ave /= npairs;
  dNon_ave /= npairs;

  for (ipa = 0; ipa<npairs; ipa++) {
    int *pa = pairlist[ipa];
    double *sa = syn[ipa];
    double *na = non[ipa];
    long ipb;

    if (0) fprintf(stderr,"Row %ld of  %ld\n", ipa, npairs);

    for (ipb = ipa; ipb<npairs; ipb++) {
      int *pb = pairlist[ipb];
      double *sb = syn[ipb];
      double *nb = non[ipb];
      int i;
      double pd_correction;

      if (nCodons[ipa] != nCodons[ipb]) {
	fprintf(stderr,"Pair %d,%d and Pair %d,%d have unequal number of codons\n",
		pa[0],pa[1],pb[0],pb[1]);
	continue;
      }
      for (i=0; i<nCodons[ipa]; i++) {
	scov += sa[i]*sb[i];
	ncov += na[i]*nb[i];
      }
      scov /= sumSynPoten[ipa]*sumSynPoten[ipb];
      ncov /= sumNonPoten[ipa]*sumNonPoten[ipb];
      if (ipa != ipb) {
	scov *= 2;
	ncov *= 2;
      }

      sum_scov += scov;
      sum_ncov += ncov;

      sum_scov_d += scov/
	(pd_correction = (1-4*psTable[ipa]/3)*(1-4*psTable[ipb]/3));
      sum_ncov_d += ncov/pd_correction;
    }
  }

  printf("\n");
  printf("Average ps:         %.6f\n",pSyn_ave);
  printf("Variance(ps):       %.6f\n",sum_scov/(npairs*(double)npairs));
  printf("Std Deviation(ps):  %.6f\n",sqrt(sum_scov)/npairs);
  printf("Average ds:         %.6f\n",dSyn_ave);
  printf("Variance(ds):       %.6f\n",sum_scov_d/(npairs*(double)npairs));
  printf("Std Deviation(ds):  %.6f\n",sqrt(sum_scov_d)/npairs);
  printf("\n");
  printf("Average pn:         %.6f\n",pNon_ave);
  printf("Variance(pn):       %.6f\n",sum_ncov/(npairs*(double)npairs));
  printf("Std Deviation(pn):  %.6f\n",sqrt(sum_ncov)/npairs);
  printf("Average dn:         %.6f\n",dNon_ave);
  printf("Variance(dn):       %.6f\n",sum_ncov_d/(npairs*(double)npairs));
  printf("Std Deviation(dn):  %.6f\n",sqrt(sum_ncov_d)/npairs);

  return 0;
}
