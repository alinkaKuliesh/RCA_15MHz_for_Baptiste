% pulse settings

function pulse = define_pulse(pulse, transducer, grid_size, speed_of_sound)
pulse.num_cycles = 3; 
pulse.wave_length = speed_of_sound / pulse.center_freq;
pulse.length = pulse.num_cycles * pulse.wave_length; % [m]
pulse.pnp = 200e3; %  [Pa]
pulse.angle = 21; % [deg]
element_spacing = transducer.pitch * grid_size; % [m]
% define transducer element delays 
element_index = 0:transducer.num_elements/2-1;    
element_index = [element_index fliplr(element_index)];
pulse.delays = element_spacing * element_index * sind(abs(pulse.angle)) / speed_of_sound;
pulse.focus = inf;
pulse.type = 'theoretical';
end