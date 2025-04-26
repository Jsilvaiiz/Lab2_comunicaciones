factors = [0, 0.25, 0.75, 1]; % factores de roll-off
fo = 1; % frec de Nyquist

colors = ['r', 'g', 'b', 'k']; % colores para las graficas

% respuesta al impulso
figure;
hold on;
grid on;
title('Respuesta al impulso');
xlabel('Tiempo (seg)');
ylabel('H(t)');
xlim([0, 10]);

t = linspace(0, 10, 5000); % vector de tiempo

for i = 1:length(factors)
    factor = factors(i);
    fdt = factor * fo; % frecuencia de corte

    term1 = (sin(2 * pi * fo * abs(t))) ./ (2 * pi * fo * abs(t));
    term2 = (cos(2 * pi * fdt * abs(t))) ./ (1 - (4 * fdt * abs(t)).^2);

    h = 2 * fo * term1 .* term2; % respuesta al impulso

    h(t == 0) = 2 * fo; % definir el valor en t=0 para evitar NaN

    plot(t, h, colors(i), 'LineWidth', 1.5, 'DisplayName', [num2str(factor)]); 
end

legend('Location', 'best');

% respuesta en frecuencia
figure;
hold on;
grid on;
title('Respuesta en frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('H(f)');
xlim([-2.5, 2.5]);

for i = 1:length(factors)
    factor = factors(i);
    fdt = factor * fo; % frecuencia de corte
    B = fo + fdt; % ancho de banda
    f1 = fo - fdt; % frecuencia de corte inferior

    f = linspace(-2*B, 2*   B, 1000); % vector de frecuencia

    H = zeros(size(f));

    for j = 1:length(f)
        if abs(f(j)) < f1
            H(j) = 0; % fuera de la banda
        elseif abs(f(j)) < B
            H(j) = 0.5 * (1 + cos(pi * (abs(f(j)) - f1) / (2*fdt))); % dentro de la banda
        else
            H(j) = 0; % fuera de la banda
        end
    end

    plot(f, H, colors(i), 'LineWidth', 1.5, 'DisplayName', [num2str(factor)]); 
end

legend('Location', 'best');