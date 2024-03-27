
import os
import sys
import matplotlib.pyplot as plt
import numpy as np
import time

SIZE=20
plt.rcParams.update({'font.size': SIZE})
plt.rcParams['text.usetex'] = True
plt.rcParams['font.family'] = 'DejaVu Sans'
plt.rcParams['figure.figsize'] = 5.5,5
#
plt.rc('font', size=SIZE)          # controls default text sizes
plt.rc('axes', titlesize=SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SIZE)    # fontsize of the tick labels
plt.rc('ytick', labelsize=SIZE)    # fontsize of the tick labels
plt.rc('legend', fontsize=SIZE)    # legend fontsize
plt.rc('figure', titlesize=SIZE)  #
#

########
## input command line argument for the name of the tess stats file
if __name__ == "__main__":
    # comand line inputs
    data_file=sys.argv[1]
    if sys.argv[2] != None:
        out_name=sys.argv[2]
    else:
        out_name="name"
    #
    data = np.loadtxt(data_file)
    stats= ["Sphericity","Equivalent Diameter"]
    statnames= ["sphericity","diameq"]
    xmin=[0.4,0.0]
    xmax=[1,0.5]
    # initialize figures
    ## 
    for i in range(2):
        num_bins=len(data[:,i])/5
        name =statnames[i]
        tic=time.time()
        fig1 = plt.figure()
        # fig2 = plt.figure()
        # add subplots
        ax1 = fig1.add_subplot()
        # ax2 = fig2.add_subplot()
        # Set maximum using maximum of the volumes
        #
        ## plot Volumes
        ax1.hist(data[:,i],bins=50,edgecolor= 'white',color="k")
        ax1.set_ylabel("Frequency")
        ax1.set_xlabel(stats[i])
        plt.tight_layout()
        #
        ## adjust subfigures
        fig1.subplots_adjust(left=0.12, right=0.95,top=0.98,bottom=0.13, wspace=0.1, hspace=0.1)        
        # fig2.subplots_adjust(left=0.15, right=0.97,top=0.98,  bottom=0.11)#,  bottom=0.11, wspace=0.1, hspace=0.1)        
        #
        ax1.set_ylim([0,37.5])
        ax1.set_xlim([xmin[i],xmax[i]])
        ## save plots
        fig1.savefig(f"imgs/{out_name}_{name}",dpi=200)
        # fig2.savefig("imgs/"+working_dir+"_dists")
        #
        toc = time.time()
        print(" ===== "*7)
        print(f"Info   :     [o] Wrote file imgs/{out_name}_{name}")
        print(f"Info   : Elapsed time: {toc-tic:2.3f} secs.")
        print(" ===== "*7)
    exit(0)
