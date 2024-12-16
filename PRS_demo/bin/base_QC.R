#Base GWAS processing 
#!/usr/bin/env Rscript


###################
# Import packages #
###################

suppressPackageStartupMessages({
  library(tidyverse)
  library(data.table)
  library(optparse)
  library(rlang)
})





#####################
# Parsing arguments #
#####################



#option_list <- list(make_option(c("--input_gwas_cat"), action="store", type='character',help="String containing input GWAS catalogue file (base cohort)."))
#args = parse_args(OptionParser(option_list = option_list))
option_list <- list(
  make_option(c("-f", "--file"), type="character", default=NULL, help="dataset file name",
              metavar="character"),
  make_option(c( "--number"), type="integer", default=10, 
              help="Number of iterations"),
  make_option(c( "--MarkerName"), type="character", default=NULL, 
           help= "column name of the RS ids [default= %SNP]", metavar="character"),
  make_option(c("A1", "--Allele1"), type="character", default= NULL, 
   help="column name of the Effect Allele [default= %A1]]", metavar="character") ,
  make_option(c("A2", "--Allele2"), type="character", default= NULL, 
           help="column name of the Other Allele [default= %A1]]", metavar="character"),
  make_option(c("B", "--Beta"), type="character", default= NULL, 
              help="column name of the Beta Values [default= %A1]]", metavar="character"),
  make_option(c("OR", "--OR"), type="character", default= NULL, 
              help="column name of  OR values [default= %A1]]", metavar="character"),
  make_option(c("p", "--p-value"), type="character", default= NULL, 
              help="column name of the p value [default= %A1]]", metavar="character"),
  make_option(c("f", "--freq"), type="character", default= NULL, 
              help="column name of the frequency [default= %A1]]", metavar="character"),
  make_option(c("maf", "--maf"), type="character", default= NULL, 
              help="column name of the minoe allele frequency [default= %A1]]", metavar="character")
  
  
  
  
)



opt_parser = OptionParser(option_list=option_list);

opt = parse_args(opt_parser);
print(opt)

##
#
if (is.null(opt$file)){
  print_help(opt_parser)
  stop("GWAS file input has to be given", call.=FALSE)
}

#####

# Arg to variable
#input_gwas_cat = args$input_gwas_cat


#input_gwas_file<- "/Users/anshika.chowdhary/Documents/cineca_paper/HT.ma"
#height_tut <- as.tibble(fread("/Users/anshika.chowdhary/Downloads/Height.gwas.txt"))

######################################
# Importing data and transforming it #
######################################
#file_gwas <- "/Users/anshika.chowdhary/gwas_summary/PGS002146.txt"
#base_gwas <- as_tibble(fread(input_gwas_file), sep=" ",  na.strings = c("", "NA"))
base_gwas <- fread(opt$file, sep="\t",  skip = 0, na.strings = c("", NA))
#base_gwas <- fread(file_gwas, sep="\t",  skip = 0, na.strings = c("", NA))
print(head(base_gwas))
colnames_base <- colnames(base_gwas)
print("kkk")
print(colnames_base)


#####
#base_gwas <- base_gwas %>%  as.data.table() %>% na.omit(base_gwas)


#### remove rows with duplicte SNPs
#base_gwas <- base_gwas %>% distinct(SNP, .keep_all = TRUE)



##### assign SNPs
if(is.null(opt$SNP)){
  SNP <- colnames_base[stringr::str_which( colnames_base,'SNP|RSId|rsID')]
  if(is_empty (SNP)){
    stop("unable to identify the SNP column in GWAS file") }
  else{
    print(paste("Found the column",SNP,  "as the SNP column"  ))
  }
}else
{
SNP = opt$SNP
}


##assign effect allele
if(is.null(opt$A1)){
  effect_allele<- colnames_base[stringr::str_which( colnames_base,'Effect allele|A1|Allele1')]
  if(is_empty (effect_allele)){
    print("unable to identify the Effect column in GWAS file") }
  else{
    print(paste("Found the column", effect_allele,  "as the Effect Allele column"))
  }
}else
{
  A1 = opt$A1
}




##assign non-effect allele
if(is.null(opt$A2)){
  A2 <- colnames_base[stringr::str_which( colnames_base,'A2|Non effect Allele|Other Allele')]
  if(is_empty (A2)){
    print("unable to identify the minor allele column in GWAS file") }
  else{
    print(paste("Found the column", A2,  "as the Other allele column"  ))
  }
}else
{
  A2 = opt$A2
}

##assign beta
if(is.null(opt$beta)){
  betas<- colnames_base[stringr::str_which( colnames_base,'beta|Beta|effect_weight|weight')]
  if(is_empty (betas)){
    stop("unable to identify the beta column in GWAS file") }
  else{
    print(paste( "Found the column", betas,  "as the beta column" ) )
  }
}else
{
  betas = opt$beta
}

##assign OR
if(is.null(opt$OR)){
  OR <- colnames_base[stringr::str_which( colnames_base,'OR|or|OR')]
  if(is_empty (OR)){
    print("unable to identify the OR column uin GWAS file") }
  else{
    print(paste("Found the column", OR,  "as the OR column")  )
  }
  #stop("unable to identify the OR column in GWAS file")
}else
{
  OR = opt$OR
}


### assign p-value
if(is.null(opt$p)){
  p <- colnames_base[stringr::str_which( colnames_base,'p-value|p|pvalue')]
  if(is_empty (p)){
    print("unable to identify the p column in GWAS file") }
  else{
    print(paste("Found the column", p, " as the P-value column"  ))
  }

}else
{
  p = opt$p
}


## assign frequency
if(is.null(opt$frequency)){
  freq <-colnames_base[stringr::str_which( colnames_base,'fre|freq|frequency')]

    if(is_empty (freq)){
    print("unable to identify the frequency column in GWAS file")}
  else{
    print(paste("Found the column", freq,  "as the freqencycolumn"  ))
  }
}else
{
  freq = opt$frequency
}

## assign MAF
if(is.null(opt$maf)){
  maf <- colnames_base[stringr::str_which( colnames_base,'MAF|maf|minor allele frequency')]
  if(is_empty (maf)){
    print("unable to identify the maf column in GWAS file") }
  else{
    print(paste("Found the column", maf , "as the MAF column"  ))
  }

}else
{
  MAF = opt$maf
}


#########

#### Remove SNPs with no beta or OR ####
base_gwas <- filter(base_gwas, !(is.na(get(betas))))

base_gwas <- filter(base_gwas, !(is.na(betas) == TRUE & is.na(p) == TRUE))

#### For SNPs with at least a beta or OR, alternatively use the beta or OR to calculate the other ####
##modify this accordingly
base_gwas[[betas]] <- as.numeric(base_gwas[[betas]])
#base_gwas$odds_ratio <- as.numeric(base_gwas$base_gwas)

#base_gwas <- base_gwas %>% mutate(b = if_else(is.na(betas), log(OR), betas), OR = if_else(is.na(OR), exp(betas), OR))

#### For SNPs with no p-value, replace the NA by a 1 ####

base <- base %>% mutate(p_value = if_else(is.na(p_value), 1, p_value))


###remove ambigous SNPS:
base_gwas <- base_gwas %>%
  filter(!((  get(A1) == "A" & get(A2) == "T") |
             ( get(A1) == "T" & get(A2) == "A") |
             (get(A1) == "G" & get(A2) == "C") |
             ( get(A1) == "C" & get(A2) == "G")))

#######

##removing duplicate SNPs
base_gwas <- distinct(base_gwas, !!as.symbol(SNP), .keep_all = TRUE)

##filtering SNPs with pvalue threshold
base_gwas <- base_gwas %>%
  filter(  get(pvalue)< 0.77)

##filtering SNps according to ma filter 
base_gwas <- base_gwas %>%  filter( get(maf)> 0.5)


#### Save data ####

write.table(base, "basedata.gwas", quote = F, row.names =TRUE , sep = " ")