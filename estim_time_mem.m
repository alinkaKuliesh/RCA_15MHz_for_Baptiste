function estim_time_mem(kgrid, PML, source, CFL, c_max, t_end)

Nx = kgrid.Nx + 2 * PML.X_SIZE;
Ny = kgrid.Ny + 2 * PML.Y_SIZE;
Nz = kgrid.Nz + 2 * PML.Z_SIZE;

grid_size = Nx * Ny * Nz;
load('./time_estimation/beta_coeff.mat');
t_step = 10^(beta_coeff(1) + beta_coeff(2) * log10(grid_size));

dt = CFL * kgrid.dx /c_max;
num_steps = floor(t_end / dt) + 1;   
time_sim = t_step * num_steps;

%% 
% highest memory consumption is expected in 3rd itteration
A_max = 9;
B_max = 2;

input = numel(source.ux);


mem_sim.max = ((13 + A_max) * Nx * Ny * Nz + (7 + B_max) * Nx /2 * Ny * Nz) * 4 / 1024^3  + ...
    input * 8  / 1024^3;
%% output
disp(['Required memory max = ', num2str(mem_sim.max), ' Gb']);
disp(['Required time = ', num2str(time_sim), ' s']);
end
