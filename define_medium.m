% =========================================================================
% DEFINE THE MEDIUM PARAMETERS
% input:    kgrid
%           margin 
%           flag_speckle (true: add 5% variation to speed of sound and density maps)
%           grid_size
% output:   medium - struct with speed of sound, density, B/A, alpha
%           coefficient maps. Maps consist of masks which correspond to 
%           different tissue types
%           vessel - struct with mask of the vessel brench geometry and
%           coordinates of the origin
% 
% vessel mask has properties of the blood, taken from tissue_properties.mat
% file, the rest of the media has tissue average properties
% =========================================================================

function medium = define_medium(kgrid, speckle)
%% water medium
c0 = 1480; %[m/s]
rho0 = 1000; %[kg/m^3]
BonA0 = 5.2;
alpha_coeff_0 = 0.002; % power law absorption prefactor [dB/(MHz^y cm)]

%% speckle SOS & density
% define a random distribution of scatterers for the medium
background_map_mean = 1;
background_map_std = 0.05;
background_map = background_map_mean +...
    background_map_std*rand([kgrid.Nx, kgrid.Ny, kgrid.Nz]);

if speckle 
   % add speckle
    maps.sound_speed= c0 * ones(kgrid.Nx, kgrid.Ny, kgrid.Nz) .* background_map;
    maps.density = rho0 * ones(kgrid.Nx, kgrid.Ny, kgrid.Nz) .* background_map;
else
    maps.sound_speed= c0 * ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);
    maps.density = rho0 * ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);    
end

maps.BonA = BonA0 * ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);
maps.alpha_coeff = alpha_coeff_0 * ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);

%     figure()
%     imagesc(maps.sound_speed(:, :, kgrid.Nz/2))
%     colorbar

%% assign created maps
medium.sound_speed = maps.sound_speed;
medium.density = maps.density;
medium.BonA = maps.BonA;
medium.alpha_coeff = maps.alpha_coeff; 
medium.alpha_power = 2;  % frequency dependance y
% medium.alpha_mode = 'no_dispersion';
    
end