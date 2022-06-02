import sys
import numpy as np
varianceFile=sys.argv[1]
binFileGg=sys.argv[2]
outDir=sys.argv[4] #"/users/kkathuri/scripts/R/tukeyTest/"
varianceCutoff=float(sys.argv[3])

if __name__=="__main__":

    varianceHash = {}
    fv=open(varianceFile,"r")
    fb=open(binFileGg,"r")

    #kmeans: form 2 clusters
    #determine varianceCutoff

    #store variances with associated cell names
    for line0 in fv:
        variance=round(float(line0.split()[1]),4)
        if variance < varianceCutoff:
            varianceHash[line0.split()[0]] = variance
    fv.close()

    #filter good calls into matrix file
    fw0=open(outDir + "/binCNMatrix.txt","w")
    for counter,line in enumerate(fb):
        #print("hello", counter)
        if line.startswith("Bin"):
            cellName=line.split()[-1]
            if cellName in varianceHash:
                write=1
            else:
                write=0
        elif line.find("cell") == -1 and write==1:
            fw0.write("%s" %line)
            
    fw0.close()

