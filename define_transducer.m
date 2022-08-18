function transducer = define_transducer(grid_size)

transducer.num_elements = 2 * 24 ;  % number of transducer elements used for xAM scan
transducer.element_width = ceil((100e-6)/grid_size); % [voxels]

% for RCA element length = full aperture
transducer.element_length = transducer.num_elements * transducer.element_width; % [voxels]
transducer.pitch = transducer.element_width; % [voxels]
transducer.passband = [14.5e6 21.5e6]; % [Hz]
        
transducer.size_y = transducer.pitch * transducer.num_elements;
end