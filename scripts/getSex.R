#!/usr/bin/R

### Kortine Kleinheinz
### 28/02/2014 k.kleinheinz@dkfz.de
### Determine the gender of the patient with simple ratio of per base coverage Y chromosome over All chromosomes
library(getopt)

script_dir = dirname(get_Rscript_filename())
source(paste0(script_dir,"/qq.R"))
source(paste0(script_dir, "/getopt.R"))

wd = getwd()
# set default values 
min_Y_ratio=0.12
min_X_ratio=0.8
################################################################################
## Get coverage of Y chromosome in normal tissue to determine gender 
################################################################################
getopt2(matrix(c(
		 'file_size',	    's', 1, "character", "chromosome length file",
		 'cnv_file',	    'c', 1, "character", "cnv file for all chromosomes",	
		 'file_out',	    'o', 1, "character", "outfile with determined sex of patient",
                 'min_Y_ratio',	    'y', 2, "numeric"  , "minimum ratio to be exceeded for male patients",
		 'min_X_ratio',     'x', 2, "numeric" , "minimum ratio to be exceeded for female patients"
                ), ncol = 5, byrow = TRUE) )
     
cat(qq("file_size: @{file_size}\n\n"))
cat(qq("file_out: @{file_out}\n\n"))
cat(qq("cnv_file: @{cnv_file}\n\n"))
cat(qq("min_Y_ratio: @{min_Y_ratio}\n\n" ))
cat(qq("min_X_ratio: @{min_X_ratio}\n\n" ))
cat("\n")

#read chromosome length file and cnv file for Y
data <- read.table( cnv_file, sep='\t', header=FALSE )
size <- read.table( file_size, header=FALSE, as.is=TRUE )
size$V1 <- gsub('chr', '', size$V1)

colnames(data) <- c( 'chr', 'pos', 'end', 'normal' )
colnames(size) <- c( 'chr', 'length' )

dataX <- data[grep("X", data$chr),]
dataY <- data[grep("Y", data$chr),]

# sum of per base coverage over whole genome
index <- which(colnames(dataY)=="normal")
#cmd <- paste0("awk '{s+=$", index,"} END{print s}' ", cnv_files)

covY <- sum(as.numeric(dataY$normal))
covX <- sum(as.numeric(dataX$normal))
covAll <- as.numeric(sum(data$normal))

lengthY   <- size[size$chr=='Y', 'length']
lengthX   <- size[size$chr=='X', 'length']
lengthAll <- sum( as.numeric(size$length) )

covMale <- (covY/lengthY)/(covAll/lengthAll)
covFemale <- (covX/lengthX)/(covAll/lengthAll)
cat( qq("covMale: @{covMale}\n covFemale: @{covFemale}\n\n" ) )

if ( covFemale >= min_X_ratio ){
  if (covMale >= min_Y_ratio ){
	sex='klinefelter'
  }else{
    	sex='female'
  }
}else{
	sex='male'
}
cat( sex)

write.table(data.frame(sex), file_out, row.names=FALSE, col.names=FALSE, quote=FALSE)
