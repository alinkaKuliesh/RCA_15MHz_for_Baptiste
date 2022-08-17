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
load('/Users/akuliesh1/RCA_15MHz_for_Baptiste/Results/sound_sheet_apod_lat_02_el_05_sensors.mat')

dt = 2.4e-9;
pulse_length = 324;
time = [0:length(pressure{1}(1, :))-1] * dt * 1e6; % [us]

figure()
subplot(2, 2, 1)
[~, idx_max] = max(pressure{1}(1, :));
idx_start = idx_max - pulse_length;
idx_end = idx_max + pulse_length;
plot(time(idx_start:idx_end), pressure{1}(1, idx_start:idx_end), 'DisplayName', 'left aperture'); hold on
plot(time(idx_start:idx_end), pressure{2}(1, idx_start:idx_end), 'DisplayName', 'right aperture'); hold on
plot(time(idx_start:idx_end), pressure{3}(1, idx_start:idx_end), 'DisplayName', 'both apertures');
xlabel('time [us]')
ylabel('pressure [Pa]')
title('signal on sensor 1')
legend

subplot(2, 2, 2)
[~, idx_max] = max(pressure{1}(2, :));
idx_start = idx_max - pulse_length;
idx_end = idx_max + pulse_length;
plot(time(idx_start:idx_end), pressure{1}(2, idx_start:idx_end), 'DisplayName', 'left aperture'); hold on
plot(time(idx_start:idx_end), pressure{2}(2, idx_start:idx_end), 'DisplayName', 'right aperture'); hold on
plot(time(idx_start:idx_end), pressure{3}(2, idx_start:idx_end), 'DisplayName', 'both apertures');
xlabel('time [us]')
ylabel('pressure [Pa]')
title('signal on sensor 2')
legend

subplot(2, 2, 3)
[~, idx_max] = max(pressure{1}(3, :));
idx_start = idx_max - pulse_length;
idx_end = idx_max + pulse_length;
plot(time(idx_start:idx_end), pressure{1}(3, idx_start:idx_end), 'DisplayName', 'left aperture'); hold on
plot(time(idx_start:idx_end), pressure{2}(3, idx_start:idx_end), 'DisplayName', 'right aperture'); hold on
plot(time(idx_start:idx_end), pressure{3}(3, idx_start:idx_end), 'DisplayName', 'both apertures');
xlabel('time [us]')
ylabel('pressure [Pa]')
title('signal on sensor 3')
legend

subplot(2, 2, 4)
[~, idx_max] = max(pressure{1}(4, :));
idx_start = idx_max - pulse_length;
idx_end = idx_max + pulse_length;
plot(time(idx_start:idx_end), pressure{1}(4, idx_start:idx_end), 'DisplayName', 'left aperture'); hold on
plot(time(idx_start:idx_end), pressure{2}(4, idx_start:idx_end), 'DisplayName', 'right aperture'); hold on
plot(time(idx_start:idx_end), pressure{3}(4, idx_start:idx_end), 'DisplayName', 'both apertures');
xlabel('time [us]')
ylabel('pressure [Pa]')
title('signal on sensor 4')
legend

