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
function sensor = define_sensor(kgrid, margin, transducer)
% Transducer mask 
x_offset = margin;

sensor.mask = zeros(kgrid.Nx, kgrid.Ny, kgrid.Nz);
type = 'individual';

switch type
    case 'sheet'     
        index_y = kgrid.Ny/2 + 1;
        start_index_z = kgrid.Nz/2 - round(transducer.element_length/2) + 1;
        sensor.mask(x_offset:end, index_y, ...
            start_index_z:start_index_z+transducer.element_length-1) = 1;
        sensor.record={'p'};
    case 'individual'
        center.x = kgrid.Nx/2 + 1;
        center.y = kgrid.Ny/2 + 1;
        center.z = kgrid.Nz/2 + 1; 
        sensor.mask(center.x, center.y, center.z) = 1;
        sensor.mask (center.x, center.y, center.z-100) = 1;
        sensor.mask (center.x-100, center.y, center.z-100) = 1;
        sensor.mask(center.x+100, center.y, center.z) = 1;
        sensor.record={'p'};
end

end
