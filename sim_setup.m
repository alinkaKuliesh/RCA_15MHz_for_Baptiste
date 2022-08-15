function run_param = sim_setup(run_param)
if run_param.hpc
    addpath(genpath("/tudelft.net/staff-bulk/tnw/IST/AK/hpc/akuliesh1/Matlab_Toolboxes"));
    addpath(genpath("/tudelft.net/staff-bulk/tnw/IST/AK/hpc/akuliesh1/MIS_opt_fullRT/Mesh_voxelisation"));
    run_param.DATA_CAST = 'gpuArray-single';
    folderName = strcat('param');
    mkdir(folderName)
    run_param.DATA_PATH = strcat('~/tudbulk/MIS_image/', folderName);
elseif run_param.maroilles_gpu
    addpath(genpath("~/k-wave-toolbox-version-1.3"));
    addpath(genpath("~/Mesh_voxelisation"));
    run_param.DATA_CAST = 'gpuArray-single';
    run_param.DATA_PATH = '~/MIS_opt_fullRT/job';
    run_param.DEVICE_NUM = 1; % select gpu device [0 1 2] 
elseif run_param.dhpc
    addpath(genpath("/scratch/akuliesh1/Matlab_Toolboxes"));
    run_param.DATA_PATH = '/scratch/akuliesh1/MIS_opt_fullRT/job';
    run_param.DATA_CAST = 'gpuArray-single';
else
    run_param.DATA_CAST = 'single';
end

end