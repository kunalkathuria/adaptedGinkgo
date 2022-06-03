#From Will Chronister's script

library(dplyr)
library(ggplot2)
library(tidyr)

IQR_factor <- 1.5
args <- commandArgs(trailing=T)
print(args[1])
autosome_medbinvals <- read.table(args[1],header = T,sep = " ")

#Use Tukey Outlier Test to find outlying bins
#Autosomes first
autosome_medbinvals <- autosome_medbinvals %>% 
  mutate(log2_median_bin_value=log2(as.numeric(Median_bin_value)))
autosome_log2_25pct <- as.numeric(quantile(autosome_medbinvals$log2_median_bin_value)[2])
autosome_log2_75pct <- as.numeric(quantile(autosome_medbinvals$log2_median_bin_value)[4])
IQR_autosome_log2 <- IQR_factor*IQR(autosome_medbinvals$log2_median_bin_value)

outlier_bins_autosome <- autosome_medbinvals$Bin[autosome_medbinvals$log2_median_bin_value < (autosome_log2_25pct - IQR_autosome_log2)]
outlier_bins_autosome <- sort(c(outlier_bins_autosome, 
                          autosome_medbinvals$Bin[autosome_medbinvals$log2_median_bin_value > (autosome_log2_75pct + IQR_autosome_log2)]))

#print(autosome_medbinvals$log2_median_bin_value)
print(autosome_log2_25pct)
print(autosome_log2_75pct)
print(IQR_autosome_log2)
#fileName = cat("outlierBins.",args[2],".txt",sep="")
cat(paste(outlier_bins_autosome,collapse="\n"),"\n",file="outlierBins.txt")

#applies to both autosomes and sex chromosomes depending on args[2]
autosome_chrom_breaks <- cumsum(rle(as.vector(autosome_medbinvals$Chrom))$lengths)
  
#Plot bad bins and thresholds
print(paste("Plotting",args[2],"outlier bins"))
asdf <- ggplot(autosome_medbinvals,
       mapping=aes(x=Bin, y=Median_bin_value)) +
  geom_vline(size=0.5,col="gray88",xintercept=autosome_chrom_breaks[-length(autosome_chrom_breaks)]) +
  geom_point(alpha=0.55, size=2) +
  geom_abline(size=1.5, col="orange2", linetype="dashed", slope=0, intercept=2^(autosome_log2_25pct - IQR_autosome_log2)) +
  geom_abline(size=1.5, col="orange2", linetype="dashed", slope=0, intercept=2^(autosome_log2_75pct + IQR_autosome_log2)) +
  theme_bw(base_size=24) +
  theme(panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        plot.title = element_text(hjust=0.5),
        axis.text.x = element_text(size=16),
        axis.text.y = element_text(size=16),
        plot.subtitle = element_text(size=12, hjust = 0.5)) +
  scale_x_continuous(expand = c(.01,.01)) +
  ylab("Median bin value") +
  ggtitle(paste(args[3], ",", length(outlier_bins_autosome),"common outlier bins", sep=" ")) +
  labs(subtitle=paste(args[2],"bad bins")) +
  ylim(0,5)
ggsave(filename = "median_bin_values.png", plot=asdf, height=4, width=12)
