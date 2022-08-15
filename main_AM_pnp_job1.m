function [] = main_AM_pnp_job1()
% simulation settings
run_param.hpc = false; % run on HPC gpu
run_param.dhpc = false; % run on DHPC gpu
run_param.maroilles_gpu = true; % run on Twente gpu
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
% sequence = {'left' 'right' 'both'};
sequence = {'both'};
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
sensor = define_sensor(kgrid, margin, transducer);
kgrid.t_array = makeTime(kgrid, medium.sound_speed, CFL, t_end);

for seq_idx = 1 : length(sequence)
    % create the time array
    pulse.elements = sequence{seq_idx};
    % define the source transducer
    source = define_source_transducer(kgrid, margin, ...
        transducer, pulse, rho, speed_of_sound, medium);
    
    estim_time_mem(kgrid, PML, source, CFL, c_max, t_end); 
    
    sensor_data = run_simulation(run_param, PML, kgrid, ...
        medium, source, sensor);
end

% save the workspace variables to the file
file_name = strcat('sound_sheet.mat');

dx = kgrid.dx;

save(file_name, 'transducer', 'dx', 'sensor_data');
end
    


        
        
       
