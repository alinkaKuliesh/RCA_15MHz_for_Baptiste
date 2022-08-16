% =========================================================================
% RUN THE SIMULATION
% input:    run_param
%           PML 
%           kgrid
%           pulse
%           medium
%           source
%           sensor
% output:   sensor_data - output of kWave simulation function 
%           kspaceFirstOrder, contains recorded pressure lines on sensors
% 
% According to run_param structure the kWave simulation function is chosen
% for gpu - kspaceFirstOrder3DG, for cpu - kspaceFirstOrder3DC, local
% machine - kspaceFirstOrder3D. To run simulation on gpu CUDA module is
% necessary. 
% =========================================================================
function sensor_data = run_simulation(run_param, PML, kgrid, medium, source, sensor)

input_args = {'PMLInside',false,...
    'PMLAlpha', PML.Alpha, ...
    'PMLSize',[PML.X_SIZE, PML.Y_SIZE, PML.Z_SIZE], ...
    'DataPath', run_param.DATA_PATH, ...
    'DataCast', run_param.DATA_CAST, ...
    'Smooth', false};

if run_param.dhpc
    if strcmp(run_param.DATA_CAST, 'gpuArray-single')
        binary_path = '/scratch/akuliesh1/tools/kspaceFirstOrder-CUDA';
        input_args = [input_args {'BinaryPath', binary_path}];
        sensor_data = kspaceFirstOrder3DG(kgrid, medium, source, sensor, input_args{:});
    else
        binary_path = '/scratch/akuliesh1/tools/kspaceFirstOrder-OMP';
        input_args = [input_args {'BinaryPath', binary_path}];
        sensor_data = kspaceFirstOrder3DC(kgrid, medium, source, sensor, input_args{:});
    end
elseif run_param.hpc
%     input_args = [input_args {'DataPath', run_param.DATA_PATH}];
    if strcmp(run_param.DATA_CAST, 'gpuArray-single')
        sensor_data = kspaceFirstOrder3DG(kgrid, medium, source, sensor, input_args{:});
    else
        sensor_data = kspaceFirstOrder3DC(kgrid, medium, source, sensor, input_args{:});
    end
elseif run_param.maroilles_gpu
    input_args = [input_args {'DeviceNum', run_param.DEVICE_NUM}];
    sensor_data = kspaceFirstOrder3DG(kgrid, medium, source, sensor, input_args{:});
        
else
    rho = 1000;
    speed_of_sound = 1540;
    if run_param.record_movie
        input_args = [input_args {'DisplayMask', source.u_mask, 'PlotPML', false, ...
            'PlotScale', [-1/4, 1/4] *  max(source.ux*rho*speed_of_sound, [], 'all'), ...
            'RecordMovie', true, 'MovieName', 'movie', 'MovieProfile', 'MPEG-4'}];
       
    else
        input_args = [input_args {'DisplayMask', source.u_mask, 'PlotPML', false, ...
            'PlotScale', [-1/4, 1/4] *  max(source.ux*rho*speed_of_sound, [], 'all')}];
        
    end
    
    sensor_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});   
    
end

end