% Bening Aqilla Fakhrun Nissa - L0325018
% Kasus 1: Galat & Error Pemotongan

% Parameter soal
h0     = 5;
lambda = 12;
v      = 36;
x_val  = 10;
t      = linspace(0, 5, 100);     % 0 <= t <= 5
u      = t * v / lambda;          % argumen cosinus (vektor)
n_vals = [23, 24, 25];            % batas iterasi (banyak suku deret)
toleransi = 1;                    % toleransi error (%)

% 1. Perhitungan eksak
h_eksak = h0 * (cos(u) + exp(x_val));

% 2. Perhitungan pendekatan
h_app = zeros(length(n_vals), length(t));

for i = 1:length(n_vals)
    n = n_vals(i);

    % deret cos(u) dengan n suku
    cos_app = zeros(size(u));
    for k = 0:(n-1)
        cos_app = cos_app + ((-1)^k) * (u.^(2*k)) / factorial(2*k);
    end

    % deret e^x dengan n suku
    exp_app = 0;
    for k = 0:(n-1)
        exp_app = exp_app + (x_val^k) / factorial(k);
    end

    h_app(i,:) = h0 * (cos_app + exp_app);
end

% 3. Grafik: keempat fungsi dalam satu plot
figure(1);
plot(t, h_eksak,   'k-',  'LineWidth', 2);   hold on;
plot(t, h_app(1,:), 'r--', 'LineWidth', 1.5);
plot(t, h_app(2,:), 'g-.', 'LineWidth', 1.5);
plot(t, h_app(3,:), 'b:',  'LineWidth', 1.5);
hold off; grid on;
xlabel('t (waktu)');
ylabel('h (tinggi gelombang)');
title('Perbandingan Hasil Eksak dan Pendekatan Deret Taylor');
legend('f_{eksak}', 'f_{n=23}', 'f_{n=24}', 'f_{n=25}', 'Location', 'northeastoutside');

% Grafik tambahan: galat mutlak terhadap t
figure(2);
plot(t, abs(h_eksak - h_app(1,:)), 'r--', 'LineWidth', 1.5); hold on;
plot(t, abs(h_eksak - h_app(2,:)), 'g-.', 'LineWidth', 1.5);
plot(t, abs(h_eksak - h_app(3,:)), 'b:',  'LineWidth', 1.5);
hold off; grid on;
xlabel('t (waktu)');
ylabel('Galat mutlak');
title('Galat Mutlak Pendekatan terhadap Hasil Eksak');
legend('n = 23', 'n = 24', 'n = 25', 'Location', 'northeastoutside');

% 4. Galat dan analisis toleransi
fprintf('================== ANALISIS GALAT KASUS 1 ==================\n');
fprintf('%-4s %-22s %-24s %-s\n', 'n', 'Rerata galat mutlak', 'Rerata galat relatif (%)', 'Keputusan');

for i = 1:length(n_vals)
    galat_mutlak = abs(h_eksak - h_app(i,:));
    rerata_mutlak = mean(galat_mutlak);
    rerata_relatif = mean(galat_mutlak ./ abs(h_eksak)) * 100;

    if rerata_relatif < toleransi
        keputusan = 'LAYAK (< 1%)';
    else
        keputusan = 'TIDAK LAYAK (>= 1%)';
    end

    fprintf('%-4d %-22.4f %-24.6f %-s\n', n_vals(i), rerata_mutlak, rerata_relatif, keputusan);
end
