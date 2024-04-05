#!/bin/bash
#SBATCH -e error.%A
#SBATCH -o output.%A
#SBATCH --nodes=NUM_NODES
#SBATCH --ntasks-per-node=NUM_PROCS
#SBATCH --time=8:00:00

echo $SLURM_JOB_NODELIST are the nodes assigned

echo $SLURM_NTASKS on $SLURM_NNODES nodes with $SLURM_NTASKS_PER_NODE per node

echo "LAUNCH FEPX"

# Run FEPX in parallel
export GFORTRAN_UNBUFFERED_ALL=n

fepx_dir="/home/etmengiste/bin/fepx_2-dev"

mpirun -np $SLURM_NTASKS ${fepx_dir}

echo "COMPLETED SUCCESSFULLY"
echo "Running postprocessing script"

sim_name=NAME
#SBATCH --epilogue=PROCESS_SCRIPT



exit 0
