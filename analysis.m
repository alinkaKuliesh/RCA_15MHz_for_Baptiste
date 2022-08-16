clear all
load('/Users/akuliesh1/RCA_15MHz_for_Baptiste/Results/sound_sheet_apod_lat_02_el_05.mat')

p_max = reshape(sensor_data.p_max, [], transducer.element_length);

x = [0:size(p_max, 1)-1] * dx;
z = [0:size(p_max, 2)-1] * dx;
z = z - z(end/2);

[sensor_x, ~, sensor_z] = ind2sub(dims, find(sensor.mask == 1));
sensor_z = sensor_z - dims(3)/2;

figure()
imagesc(z*1e3, x*1e3, p_max); hold on
scatter((sensor_z-1)*dx*1e3, (sensor_x-1)*dx*1e3, 'x', 'LineWidth', 2)

colorbar 
xlabel('elevation [mm]')
ylabel('axial [mm]')
title('peak positive pressure')

%%
figure()
scatter(x*1e3, p_max(:, round(end/2)))

