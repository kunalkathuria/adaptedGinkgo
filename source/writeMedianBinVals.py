import sys
import numpy as np
binFile=sys.argv[1]
ginkgoBintoChrom=sys.argv[2]
outDir=sys.argv[4]
badBinFile=sys.argv[3]
totalBins=5363
if __name__=="__main__":

    medianList = []
    counter=0
    binMatrix = np.loadtxt(binFile)
    fwA=open(outDir + "/medianBins.autosomes.txt","w")
    fwA.write("Bin Median_bin_value Chrom\n")
    fwXY=open(outDir + "/medianBins.XY.txt","w")
    fwXY.write("Bin Median_bin_value Chrom\n")

    binMedians = np.apply_along_axis( np.median, axis=0, arr=binMatrix )

    #to get right outlier bin numbers
    fb=open(ginkgoBintoChrom,"r")
    fb.readline()

    badBins = []
    allBins=range(1,totalBins+1)
    fbb=open(badBinFile,"r")
    for line in fbb:
        badBins.append(int(line[:-1]))
    trueBinNumMap = [x for x in allBins if x not in badBins]

    XY=0
    prevBinNum=0
    for counter,entry in enumerate(binMedians):
        binNum = trueBinNumMap[counter]
        #account for bad bin numbers skipped, to map correct chr to bin
        gap = binNum - prevBinNum - 1
        for x in range(0,gap):
            fb.readline()
        prevBinNum = binNum
        chrom = fb.readline().split()[0]
        #if chr has switched to chrX
        if XY==0 and chrom == "chrX":
            XY=1
        if XY==0:
            fwA.write("%s %s %s\n" %(binNum,entry,chrom))
        elif XY==1:
            fwXY.write("%s %s %s\n" %(binNum,entry,chrom))

    fwA.close()
    fwXY.close()

    #for i in enumerate(binMatrix 
#    bf=open(binFile,"r")
#    fw=open(medianBins,"w")
#    header=bf.readline()
#    for line in bf:
#        if line.startswith("Bin"):
#            counter+=1
#            fw.write("%s %s" (counter,median(CNVals)) 
#            #medianList.append(median(CNVals))
#        else:
#            CNvals = float(line.split())
    
