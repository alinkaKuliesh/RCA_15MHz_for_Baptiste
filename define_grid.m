% =========================================================================
% DEFINE THE K-WAVE GRID
% input:    grid_size
%           pulse 
%           transducer
% output:   kgrid - k-space grid
%           margin - disatnce between PML and transducer
%           PML
% 
% Time to compute each FFT minimised by choosing 
% the total number of grid points in each direction (including the PML) 
% to be a power of two, or to have small prime factors.          
% =========================================================================
function [kgrid, margin, PML] = define_grid(grid_size, pulse, transducer)
    
    % calculate the spacing between the grid points
    dx = grid_size; % [m] 
    dy = dx;                 
    dz = dx;                    
    
    % set min margin between the source/sensor & PML
    margin = ceil(2*pulse.wave_length/dx); % [grid points]
    
    Nz = transducer.element_length + 2 * margin;

    Nx = round(transducer.num_elements * transducer.pitch / 2 * cotd(pulse.angle)) + margin;
    
    Ny = transducer.num_elements * transducer.pitch + 2 * margin;
    
    if mod(Nx, 2) ~= 0
        Nx = Nx + 1;
    end
    
    if mod(Ny, 2) ~= 0 
        Ny = Ny + 1;
    end
    
    if mod(Nz, 2) ~= 0
        Nz = Nz + 1;
    end
    
    display([Nx, Ny, Nz])
    
    % create the k-space grid
    kgrid = kWaveGrid(Nx, dx, Ny, dy, Nz, dz);
    
    % find optimal size of the perfectly matched layer (PML)
    PML.X_SIZE = define_PML([20, 40], Nx);
    PML.Y_SIZE = define_PML([20, 40], Ny);
    PML.Z_SIZE = define_PML([10, 30], Nz);
    PML.Alpha = 2;
    
end