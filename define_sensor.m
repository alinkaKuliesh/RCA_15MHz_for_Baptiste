% =========================================================================
% DEFINE THE SENSOR: MBs and transducer record pressure
% input:    kgrid
%           margin 
%           transducer
%           vessel (the output of define_medium(), vessel mask and origin)
%           frame - cell of MediaPoints.mat
% output:   sensor - mask of sensors
%           MB - struct with linear indexes of MBs in the sensor mask and 
%           indexes of recorded pressure lines (corresponding to MBs) in 
%           sensor_data
%           transducer - update of the transducer struct with same indexes
%           as MBs
% 
%
% =========================================================================
function sensor = define_sensor(kgrid, margin, transducer, measure)
% Transducer mask 
x_offset = margin;

sensor.mask = zeros(kgrid.Nx, kgrid.Ny, kgrid.Nz);

switch measure
    case 'xWave'   
        index_y = kgrid.Ny/2 - round(transducer.size_y/2) + 1 + transducer.size_y/2;
        start_index_z = kgrid.Nz/2 - round(transducer.element_length/2) + 1;
        sensor.mask(x_offset:end, index_y, ...
            start_index_z:start_index_z+transducer.element_length-1) = 1;
        sensor.record={'p_max'};
    case 'xAM'
        index_y = kgrid.Ny/2 - round(transducer.size_y/2) + 1 + transducer.size_y/2;
        start_index_z = kgrid.Nz/2 - round(transducer.element_length/2) + 1;
        sensor.mask(x_offset:end, index_y, ...
            start_index_z:start_index_z+transducer.element_length-1) = 1;
        sensor.record={'p'};
    case 'xWave_orthogonal'
        index_z = round(kgrid.Nz/2);
        start_index_y = kgrid.Ny/2 - round(transducer.size_y/2) + 1;
        sensor.mask(x_offset, start_index_y:start_index_y + transducer.size_y,...
            index_z) = 1;     
        sensor.record={'p_max'};

end

end
