% Bening Aqilla Fakhrun Nissa - L0325018
% Kasus 3: Persamaan Nonlinear

% 1. Data dan persamaan
V_bola   = 300;                               % cm^3
V_tabung = (3/2) * V_bola;                    % dari perbandingan 2 : 3
V_luar   = V_tabung - V_bola;                 % volume tabung di luar bola
fprintf('Volume tabung            = %.2f cm^3\n', V_tabung);
fprintf('Volume tabung di luar bola = %.2f cm^3\n\n', V_luar);

f = @(r) (2/3) * pi * r.^3 - V_luar;          % f(r) = 0

% 2. Metode grafik untuk menentukan nilai awal
r = 0:0.1:8;
figure(1);
plot(r, f(r), 'b-', 'LineWidth', 1.5); hold on;
plot([0 8], [0 0], 'k-');                     % sumbu f(r) = 0
grid on;
xlabel('r (cm)'); ylabel('f(r)');
title('Grafik f(r) = (2/3)\pi r^3 - 150');

% Dari grafik, kurva memotong sumbu-r di antara r = 4 dan r = 5
a0 = 4;  b0 = 5;
fprintf('f(%g) = %.4f, f(%g) = %.4f\n', a0, f(a0), b0, f(b0));
if f(a0) * f(b0) < 0
    disp('f(a)*f(b) < 0 -> akar berada di dalam interval [a, b]');
else
    error('Interval awal tidak mengurung akar. Ubah a dan b.');
end

tol = 1e-6;  maxit = 100;

% 3. Metode Biseksi
a = a0;  b = b0;
fprintf('\n=== METODE BISEKSI ===\n');
fprintf('%-5s %-11s %-11s %-11s %-13s\n', 'Iter', 'a', 'b', 'c', 'f(c)');
for iter = 1:maxit
    c = (a + b) / 2;
    fprintf('%-5d %-11.6f %-11.6f %-11.6f %-13.6f\n', iter, a, b, c, f(c));
    if abs(f(c)) < tol || (b - a)/2 < tol
        break;
    end
    if f(a) * f(c) < 0
        b = c;
    else
        a = c;
    end
end
r_bis = c;  iter_bis = iter;

% 4. Metode Regula-Falsi (pembanding)
a = a0;  b = b0;
fprintf('\n=== METODE REGULA-FALSI ===\n');
fprintf('%-5s %-11s %-11s %-11s %-13s\n', 'Iter', 'a', 'b', 'c', 'f(c)');
for iter = 1:maxit
    c = (a*f(b) - b*f(a)) / (f(b) - f(a));
    fprintf('%-5d %-11.6f %-11.6f %-11.6f %-13.6f\n', iter, a, b, c, f(c));
    if abs(f(c)) < tol
        break;
    end
    if f(a) * f(c) < 0
        b = c;
    else
        a = c;
    end
end
r_rf = c;  iter_rf = iter;

% 5. Hasil akhir
plot(r_bis, f(r_bis), 'ro', 'MarkerFaceColor', 'r');   % tandai akar pada grafik
legend('f(r)', 'f(r) = 0', 'akar (biseksi)', 'Location', 'northwest');
hold off;

fprintf('\n=== HASIL AKHIR ===\n');
fprintf('Biseksi      : r = %.6f cm (%d iterasi)\n', r_bis, iter_bis);
fprintf('Regula-falsi : r = %.6f cm (%d iterasi)\n', r_rf, iter_rf);
fprintf('Jari-jari bola dan tabung r = %.4f cm\n', r_bis);
fprintf('Tinggi tabung t = 2r        = %.4f cm\n', 2*r_bis);

% 6. Verifikasi
fprintf('\n=== VERIFIKASI ===\n');
fprintf('V_bola   = %.4f cm^3 (target 300)\n', (4/3)*pi*r_bis^3);
fprintf('V_tabung = %.4f cm^3 (target 450)\n', 2*pi*r_bis^3);
fprintf('V_luar   = %.4f cm^3 (target 150)\n', (2/3)*pi*r_bis^3);
fprintf('Solusi analitik r = (225/pi)^(1/3) = %.6f cm\n', (225/pi)^(1/3));
