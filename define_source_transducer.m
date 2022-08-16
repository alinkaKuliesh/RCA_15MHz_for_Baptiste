% =========================================================================
% DEFINE THE SOURCE: transducer sends pulse 
% input:    kgrid
%           margin 
%           transducer
%           pulse
%           rho - refernce density of the media (for example water)
%           speed_of_sound - referense sos of the media (water)
% output:   source - mask of pulse sources, transducer pulse defined in
%           velocities terms ux = p / rho / speed_of_sound
% 
% for P4-1 probe - transmit pulse is definde according to the probe 
% characterization files (signal_type = 'experimental'). Other probes were
% not characterized signal_type = 'simple', pulse is defined by
% toneBurst().
%
% =========================================================================

function source = define_source_transducer(kgrid, margin, transducer, pulse, rho, speed_of_sound, medium)
%% flags for apodization
apodization_Z = true;
apodization_Y = true;

%% Define the mask
x_offset = margin;

source.u_mask = zeros(kgrid.Nx, kgrid.Ny, kgrid.Nz);
start_index_y = kgrid.Ny/2 - round(transducer.size_y/2) + 1;
start_index_z = kgrid.Nz/2 - round(transducer.element_length/2) + 1;

source.u_mask(x_offset, start_index_y:start_index_y + transducer.size_y - 1,...
    start_index_z:start_index_z+transducer.element_length-1) = 1;    
  
%% Define the signal
fs = 1 / kgrid.dt; % [Hz]
tri_level_signal = define_tri_level_drive_signal(pulse.num_cycles, pulse.center_freq, fs);
IR = approx_IR(transducer.passband, fs); % impulse response  
signal = conv(tri_level_signal, IR)';
signal_filt = filterTimeSeries(kgrid, medium, signal, 'ZeroPhase', true, 'PPW', 2);

% scale to desired pnp
scale_coeff = pulse.pnp / max(signal_filt);
signal_filt = scale_coeff * signal_filt;

delays_y = round(pulse.delays/kgrid.dt); 

for i = 1 : transducer.num_elements
    temporaryp(i,:) = [zeros(1, delays_y(i)), signal_filt, zeros(1, max(delays_y) - delays_y(i))];       
end

% for AM silence particular elements
if isfield(pulse, 'elements')
    switch pulse.elements
        case 'left'
            temporaryp(end/2+1:end, :) = zeros(transducer.num_elements/2, size(temporaryp, 2));
        case 'right'
            temporaryp(1:end/2, :) = zeros(transducer.num_elements/2, size(temporaryp, 2));
    end
end

figure()
plot(1:length(temporaryp(1,:)), temporaryp(floor(transducer.num_elements/2),:))
xlabel('sampling points')
ylabel('pressure [Pa]')
title('Pulse Shape')

%% Apodization 
apod_winY = getWin(size(temporaryp, 1)/2, 'Tukey', 'Param', 0.2, 'Plot', true).'; % 0 Rectangular window; 1 Hann window
apod_winY = repmat(apod_winY, 1, 2);       

if apodization_Y
    temporaryp = temporaryp .* apod_winY';
end

figure;
stackedPlot(1:length(temporaryp(1,:)), temporaryp);
xlabel('sampling points');
ylabel('Transducer Element');
title('Transmit Pressure after Apodization');

%% repeat along y direction voxels
temporaryp = repelem(temporaryp, transducer.element_width, 1);

apod_winZ = getWin(transducer.element_length, 'Tukey', 'Param', 0.2, 'Plot', false).'; % 0 Rectangular window; 1 Hann window

%% repeat along z direction voxels
num_voxels = transducer.num_elements * transducer.element_width; % number of voxels in transducer in longitudial direction

%repeat along z direction
for i = 1 : transducer.element_length
    if apodization_Z
        source.ux(num_voxels*(i-1)+1:num_voxels*(i-1)+num_voxels,:) = temporaryp / rho / speed_of_sound * apod_winZ(i); 
    else
        source.ux(num_voxels*(i-1)+1:num_voxels*(i-1)+num_voxels,:) = temporaryp / rho / speed_of_sound;
    end
end

end

