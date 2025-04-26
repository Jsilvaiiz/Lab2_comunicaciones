clc; clear; close all;

% Parámetros base
f0 = 1000;               % Frecuencia base (Hz)
Ts = 1 / f0;             % Periodo de símbolo
alphas = [0, 0.25, 0.75, 1];
num_bits = 10000;          % Número de bits
samples_per_symbol = 100; % Sobre-muestreo
Fs = samples_per_symbol / Ts; % Frecuencia de muestreo
t_pulse = -5*Ts:1/Fs:5*Ts;    % Tiempo del pulso

% Generar datos NRZ-L
data = randi([0 1], 1, num_bits);
data_nrz = 2*data - 1; % NRZ-L: 0 -> -1, 1 -> +1
upsampled = upsample(data_nrz, samples_per_symbol);

% Bucle sobre distintos valores de alpha
for idx = 1:length(alphas)
    alpha = alphas(idx);
    
    % Pulso coseno alzado
    t = t_pulse;
    h = zeros(size(t));
    for k = 1:length(t)
        if t(k) == 0
            h(k) = 1;
        elseif alpha ~= 0 && abs(t(k)) == Ts / (2 * alpha)
            h(k) = (pi/4) * sinc(1 / (2 * alpha));
        else
            h(k) = sinc(t(k)/Ts) .* cos(pi*alpha*t(k)/Ts) ./ (1 - (2*alpha*t(k)/Ts)^2);
        end
    end
    
    % Filtrado (convolución del pulso con la señal)
    tx_signal = conv(upsampled, h, 'same');
    
    % Añadir ruido AWGN
    SNR = 20; % dB
    rx_signal = awgn(tx_signal, SNR, 'measured');
    
    % Diagrama de ojo
    %figure;
    eyediagram(rx_signal, 2*samples_per_symbol); % 2 símbolos por ventana
    title(['Diagrama de Ojo, Roll-off = ', num2str(alpha)]);
end