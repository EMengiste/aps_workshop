import sys
sys.path
script_fdr="/home/etmengiste/code/data_reduction_scripts"
sys.path.append(script_fdr+"/common_scripts")
print(sys.path)
from tool_box import *
from fepx_sim import *
from plotting_tools import *
from pre_processing import *
#
def plot_stress_strain(ax,stress,strain,labels=False,lw=5,ls="-",col="k",label=""):
    ax.plot(strain, stress,col,ms=1,linestyle=ls,linewidth=lw,label=label)

    #
#
def plot_plot_nsave(stress,strain,ax,fig,step="all",ylim=[0,201]):
    i=step if step!="all" else None
    print(" Plotting step "+str(i))
    plot_stress_strain(ax,stress[0:i],strain[0:i],lw=7)  
    fig.subplots_adjust(left=0.15, right=0.97,top=0.98,  bottom=0.12, wspace=0.1, hspace=0.1)        
    # plt.show()
    ax.set_xlim([0.00001,5.5])
    ax.set_ylim([0.00001,120])
    stress_sim= '$\sigma_{eq}$'
    strain_sim= '$\epsilon_{eq}$'
    stress_exp = '$\sigma$'
    strain_exp="$\\v"+"arepsilon$"
    x_label = f'{strain_sim} (\%)'
    y_label = f'{stress_sim} (MPa)'
    ax.set_ylabel(y_label)
    ax.set_xlabel(x_label)
    fig.savefig("svs_"+str(step),dpi=100)
    ax.cla()
#
#
out_path = "output"
out_path = "imgs"
path = os.getcwd()
# individual_svs(path,"isotropic/Cube.sim",show=True)
# ids = [i for i in range(499,600,2)]
# ids="all"
oris = []
oris2 = []
orientation_plotting =  False#True #
stress_strain = True
## initialize sim object
sim = "simulation.sim"
simulation = fepx_sim(sim,path=path+"/"+sim)

# simulation.post_process("-reselset ori")
if stress_strain:
    try:
        stress=simulation.get_output("stress_eq",step="all")
        strain=100*simulation.get_output("strain_eq",step="all")
    except:
        simulation.post_process(options="-resmesh stress_eq,strain_eq")
        stress=simulation.get_output("stress_eq",step="all")
        strain=100*simulation.get_output("strain_eq",step="all")
    #
    # calculate the yield values
    yield_values = find_yield(stress,strain)
    ystrain,ystress =yield_values["y_strain"],yield_values["y_stress"]
    stress_off = yield_values["stress_offset"]
    load_steps =len(stress)# 1 # 
    max_stress=2*max(stress)
#
#

##
fig= plt.figure(figsize=[6,6])
ax = fig.add_subplot()
###
os.chdir(path+"/"+out_path)
print(sys.argv[:3])
arg1,arg2,arg3 =[ int(i) for i in sys.argv[1:4]]
ticinit = time.perf_counter()
starting_step = 48
for i in range(arg1,arg2+1,arg3):
    print(" Plotting step "+str(i))
    tic = time.perf_counter()
    if stress_strain: plot_plot_nsave(stress,strain,ax,fig,step=i)
    toc = time.perf_counter()
    print(f"Ran the step in {toc - tic:0.4f} seconds")

print(f"Ran the code in {toc - ticinit:0.4f} seconds")
exit(0)