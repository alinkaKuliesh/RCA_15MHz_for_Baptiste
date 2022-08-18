function [] = main_AM_pnp_job1()
% simulation settings
run_param.hpc = false; % run on HPC gpu
run_param.dhpc = true; % run on DHPC gpu
run_param.maroilles_gpu = false; % run on Twente gpu
run_param.record_movie = false;
run_param = sim_setup(run_param);

CFL = 0.3;

pulse.center_freq = 15.625e6; % [Hz]
speed_of_sound = 1480; % [m/s]
rho = 1000; % [kg/m^3] reference density

ppwl = 8; % grid points per wavelength; optimal to retain 

grid_size = speed_of_sound / pulse.center_freq / ppwl; % [m]

% transducer settings based on US probe selection
transducer = define_transducer(grid_size);

% pulse settings
pulse = define_pulse(pulse, transducer, grid_size, speed_of_sound);
speckle = false;
 
[kgrid, margin, PML] = define_grid(grid_size, pulse, transducer);

medium = define_medium(kgrid, speckle);
c_max = max(medium.sound_speed(:));
% volumeViewer(medium.sound_speed)

% record signals long enough for back and forth pass of the wave

max_trans_dist = transducer.pitch * transducer.num_elements / 2 * kgrid.dx / sind(pulse.angle);    

% define simulation time for 1 & 3 iterations
t_end = (max_trans_dist + 2 * pulse.length) / speed_of_sound; % [s]

% define sensor
sensor_type = 'sheet';
sensor = define_sensor(kgrid, margin, transducer, sensor_type);
kgrid.t_array = makeTime(kgrid, medium.sound_speed, CFL, t_end);

if strcmp(sensor_type, 'individual')   
    sequence = {'left' 'right' 'both'};
elseif strcmp(sensor_type, 'sheet')
    sequence = {'both'};
end

for seq_idx = 1 : length(sequence)
    % create the time array
    pulse.elements = sequence{seq_idx};
    % define the source transducer
    [source, pulse_length] = define_source_transducer(kgrid, margin, ...
        transducer, pulse, rho, speed_of_sound, medium);
    
    estim_time_mem(kgrid, PML, source, CFL, c_max, t_end); 
    
    sensor_data = run_simulation(run_param, PML, kgrid, ...
        medium, source, sensor);
    if strcmp(sensor_type, 'individual')
        pressure{seq_idx} = sensor_data.p;
    end
end

% save the workspace variables to the file

dx = kgrid.dx;
dt = kgrid.dt;
Nt = kgrid.Nt;
dims = [kgrid.Nx kgrid.Ny kgrid.Nz];
if strcmp(sensor_type, 'individual')
    file_name = strcat('individual_sensors.mat');
    save(file_name, 'transducer', 'dx', 'dt', 'pressure', 'sensor', 'pulse_length', 'dims');
elseif strcmp(sensor_type, 'sheet')
    file_name = strcat('sound_sheet.mat');
    save(file_name, 'transducer', 'dx', 'sensor_data', 'dt', 'Nt');
end
end
    


        
        
       
