
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
def euclidian_distance(var1,var2):
    distances= []
    for i,j in zip(var1,var2):
        sum = (i[0]-j[0])**2
        sum+= (i[1]-j[1])**2
        sum+= (i[2]-j[2])**2
        dist = sum
        distances.append(dist)
    return distances

def read_runtime(fileName):
    log_file= open(fileName,"r").readlines()
    run_times= []
    solution= []
    for i in log_file:
        if i.startswith("Info   : Elapsed time: "):
            run_times.append(i.split(":")[-1].split("cs")[0]+"cs")
        if "> Final solution  :" in i:
            solution.append(i.split("=")[-1].split(r'\\')[0])
    return run_times,solution

def common_vals(arr1,arr2):
    # find the common values between two arrays
    # 
    arr1 = set(arr1)
    arr2 = set(arr2)
    if (arr1 & arr2):
        return list(arr1 & arr2)[0]
    else:
        return -1

def text_to_array(string,file_type="stcell"):
    ##
    # Function to process neper tesselation stats output
    ##
    if file_type == "stcell":
        arr = [float(i) for i in string.split(" ")]
        coo    = arr[:3]
        vol    = arr[3]
        ncells = [int(i) for i in arr[4:]]
        return [coo,vol,ncells]
    elif file_type=="stface":
        arr = [float(i) for i in string.split(" ")]
        area    = arr[0]
        nfacenb = arr[1]
        nfaces  = arr[2:]
        return [area,nfacenb,nfaces]
    elif file_type=="stpoly":
        string = string.split(" ")
        num_faces = int(string[0])
        faces = [int(i) for i in string[1:num_faces]]
        face_eqns = [float(i) for i in string[num_faces:]]
        return [num_faces,faces,face_eqns]
    
def list_to_ascii(arr):
    # Helper function for writing output
    # input an array [a,b,c] 
    # output "a b c"
    string = str(arr)[1:-1].replace(","," ")
    return string
#
#
def process_generated_tess(area,faces,
                           face_eqns,ncells,oris,debug=None,preamble="   ="):
    neighbors             = open(working_dir+"_neighbors_ids","w")
    neighbor_shared_areas = open(working_dir+"_neighbor_shared_areas","w")
    neighbor_face_eqns    = open(working_dir+"_neighbor_face_normals","w")
    misorientations       = open(working_dir+"_misorientations","w")
    #
    # Loop over grain i's list of neighbors (ncells) (note: i= 0,numgrains-1)
    for i,cell in enumerate(ncells[:debug]):
        #
        ori_grain = ret_to_funda(oris[i] ) 
        faces_grain = faces[i]   
        misoris     = []
        shared_area = []
        face_eqns_shared= []
        # Loop over list of grains neighboring grain i
        for j in cell:
            j=int(j)-1 # adjust indexing variable (neper indexes at 1 python lists at 0)
            ori_neighbor = oris[j]
            ori_neighbor = ret_to_funda(ori_neighbor)
            misori_val = quat_misori(ori_grain,ori_neighbor) # calculate misorientation in degrees
            # store value
            misoris.append(misori_val)
            # Extract faces of the neighboring grain
            faces_neighbor = faces[j]
            # Find the common values

            shared_face = common_vals(faces_grain,faces_neighbor)
            # Find the area of the shared face if available or use 0.0
            area_shared = area[shared_face-1] if shared_face !=-1 else 0.0
            shared_area.append(area_shared)
            # Find the normal of the shared face
            face_eqn_shared = face_eqns[j][faces_neighbor.index(shared_face)] if shared_face !=-1 else ["nan","nan","nan"]
            face_eqns_shared.append(face_eqn_shared)
            #
        #
        # write line of values into their respective files
        neighbors.writelines(list_to_ascii(cell)+"\n")   
        neighbor_face_eqns.writelines(str(face_eqns_shared)+"\n")
        misorientations.writelines(list_to_ascii(misoris)+"\n")
        neighbor_shared_areas.writelines(list_to_ascii(shared_area)+"\n")
    # close all files
    neighbors.close() #
    neighbor_face_eqns.close() # 
    misorientations.close() #
    neighbor_shared_areas.close() # 

    print(" ------ "*7)
    print("    += wrote file ",working_dir+"_neighbors_ids")
    print("    += wrote file ",working_dir+"_neighbor_shared_areas")
    print("    += wrote file ",working_dir+"_neighbor_face_normals")
    print("    += wrote file ",working_dir+"_misorientations")


    

########
## input command line argument for the name of the tess stats file
if __name__ == "__main__":
    tic=time.time()
    # comand line inputs
    working_dir=sys.argv[1]
    #
    print("\n\n")
    print(" ===== "*7)
    print(" Working on sample ",working_dir,"...")
    print(" ===== "*7)
    preamble="  "
    #
    #
    ####
    stcell_file = open(working_dir+".stcell").readlines()
    stcell_file = np.array([ text_to_array(i,file_type="stcell") for i in stcell_file],dtype=object)
    #
    #\# coo,vol,ncells
    #
    coos_tess,vols_tess,ncells = stcell_file[:,0],stcell_file[:,1],stcell_file[:,2]
    vols_tess = vols_tess/sum(vols_tess)
    ##
    ##
    stface_file = open(working_dir+".stface").readlines()
    stface_file = np.array([ text_to_array(i,file_type="stface") for i in stface_file],dtype=object)
    #
    #\#area,nfacenb,nfaces
    #
    area,nfacenb,nfaces = stface_file[:,0],stface_file[:,1],stface_file[:,2]
    #
    stpoly_file = open(working_dir+".stpoly").readlines()
    stpoly_file = np.array([text_to_array(i,file_type="stpoly") for i in stpoly_file],dtype=object)
    num_faces,faces,face_eqns = stpoly_file[:,0],stpoly_file[:,1],stpoly_file[:,2]
    #
    #
    list_nums = [i for i in range(len(vols_tess))]
    ##
    # initialize figures
    ## 
    fig1 = plt.figure()
    # fig2 = plt.figure()
    # add subplots
    ax1 = fig1.add_subplot()
    # ax2 = fig2.add_subplot()
    # Set maximum using maximum of the volumes
    #
    ## plot Volumes
    ax1.hist(vols_tess,bins=50,edgecolor= 'white',color="k")
    ax1.set_ylabel("Frequency")
    ax1.set_xlabel("Generated Volumes")
    # ax1.set_ylim([0,0.016])
    # ax1.set_xlim([0,0.015])   
    # ax1.set_yticks([0,0.005,0.010,0.015])
    # ax1.set_xticks([0,0.005,0.010,0.015])   
    #
    # ## plot centroid distances
    # ax2.scatter(ids,distances,c="k")
    # ax2.set_ylabel(" Eucledian Distance of Centroids")
    # ax2.set_xlabel(" Grain ID")
    # ax2.set_ylim([0,0.0045])
    # ax2.set_xlim([-1,800])   
    ## plot coodrdinate differences
    plt.tight_layout()
    #
    ## adjust subfigures
    fig1.subplots_adjust(left=0.18, right=0.95,top=0.98,bottom=0.13, wspace=0.1, hspace=0.1)        
    # fig2.subplots_adjust(left=0.15, right=0.97,top=0.98,  bottom=0.11)#,  bottom=0.11, wspace=0.1, hspace=0.1)        
    #
    ## save plots
    fig1.savefig("imgs/"+working_dir+"_vols",dpi=200)
    # fig2.savefig("imgs/"+working_dir+"_dists")
    #
    toc = time.time()
    print(" ===== "*7)
    print(f"  {working_dir} took {toc-tic:2.3f} secs to process")
    print(" ===== "*7)
    exit(0)
