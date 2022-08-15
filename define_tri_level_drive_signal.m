function V = define_tri_level_drive_signal(Ncy, f, Fs)
% Get a pulse train of alternating positive and negative block pulses, with
% Ncy cycles and frequency f at sampling rate F.

ON_Frac = 0.67;             % Fraction of half cycle with high level

NT = Fs/f;                  % Number of sample points per cycle
NT_half = round(Fs/(2*f));  % Number of sample points per half cycle
NT_ON = round(ON_Frac*Fs/(2*f));

N = ceil(Ncy * NT);

V = zeros(1,N);

for k = 1:Ncy
    % Positive pulse
    Nstart = 1 + round((k-1)*NT);
    V(Nstart:Nstart+NT_ON) = 1;
    % Negative pulse
    Nstart = Nstart + NT_half;
    V(Nstart:Nstart+NT_ON) = -1;
end

end