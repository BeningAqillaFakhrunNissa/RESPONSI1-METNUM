% Bening Aqilla Fakrun Nissa - L0325018
% Kasus 2: Sistem Persamaan Linear (SPL)


% 1. Data belanja dan konversi satuan ke kg
% Faktor konversi ke kg: 1 kg = 1 kg, 1 g = 0.001 kg, 1 hg = 0.1 kg, 1 dag = 0.01 kg
kg = 1; g = 0.001; hg = 0.1; dag = 0.01;

%            Beras      Telur       Tepung     Ayam
A0 = [ 2.5*kg    1500*g     5*kg       500*g;     % Adel
       40*hg     0.75*kg    1000*g     2*kg;      % Briza
       2000*g    15*hg      50*dag     6000*g;    % Caca
       1*kg      4250*g     20*hg      9*hg ];    % Dinda

b0 = [161000; 149000; 251500; 173000];            % total belanja (Rp)
nama_orang = {'Adel', 'Briza', 'Caca', 'Dinda'};
nama_bahan = {'Beras', 'Telur', 'Tepung', 'Ayam'};
n = 4;

disp('=== BENTUK SPL: A x = b (satuan kg) ===');
disp('Matriks A (urutan baris: Adel, Briza, Caca, Dinda):');
disp(A0);
disp('Vektor b (Rp):');
disp(b0);

% 2. Analisis: apakah metode iteratif (Gauss-Seidel) bisa dipakai?
% (a) Syarat cukup: dominan diagonal ketat |a_ii| > sum_{j~=i} |a_ij|
fprintf('\n=== CEK DOMINAN DIAGONAL (URUTAN AWAL) ===\n');
for i = 1:n
    diag_i = abs(A0(i,i));
    sisa   = sum(abs(A0(i,:))) - diag_i;
    if diag_i > sisa, ket = 'dominan'; else, ket = 'TIDAK dominan'; end
    fprintf('Baris %d (%s): |a_ii| = %.2f, jumlah lainnya = %.2f -> %s\n', ...
            i, nama_orang{i}, diag_i, sisa, ket);
end

% (b) Syarat perlu dan cukup: jari-jari spektral matriks iterasi Gauss-Seidel < 1
L = tril(A0);  U = A0 - L;
rho0 = max(abs(eig(-(L \ U))));
fprintf('Jari-jari spektral Gauss-Seidel (urutan awal) = %.4f -> ', rho0);
if rho0 < 1, disp('konvergen'); else, disp('DIVERGEN'); end

% 3. Penukaran baris (pivoting) agar dominan diagonal
% Urutan baru: Briza, Dinda, Adel, Caca (elemen terbesar tiap baris di diagonal)
urut = [2 4 1 3];
A = A0(urut, :);
b = b0(urut);

fprintf('\n=== CEK DOMINAN DIAGONAL (SETELAH BARIS DITUKAR) ===\n');
for i = 1:n
    diag_i = abs(A(i,i));
    sisa   = sum(abs(A(i,:))) - diag_i;
    if diag_i > sisa, ket = 'dominan'; else, ket = 'TIDAK dominan'; end
    fprintf('Baris %d (%s): |a_ii| = %.2f, jumlah lainnya = %.2f -> %s\n', ...
            i, nama_orang{urut(i)}, diag_i, sisa, ket);
end
L = tril(A);  U = A - L;
rho1 = max(abs(eig(-(L \ U))));
fprintf('Jari-jari spektral Gauss-Seidel (setelah tukar) = %.4f -> ', rho1);
if rho1 < 1, disp('konvergen'); else, disp('DIVERGEN'); end

% 4. Metode Gauss-Seidel
tol = 1e-6;  maxit = 1000;
x = zeros(n,1);                         % tebakan awal
fprintf('\n=== ITERASI GAUSS-SEIDEL ===\n');
fprintf('%-5s %-12s %-12s %-12s %-12s %-10s\n', 'Iter', 'Beras', 'Telur', 'Tepung', 'Ayam', 'Selisih');
for iter = 1:maxit
    x_lama = x;
    for i = 1:n
        idx = [1:i-1, i+1:n];                         % semua kolom selain diagonal
        x(i) = (b(i) - A(i,idx) * x(idx)) / A(i,i);   % pakai nilai terbaru
    end
    selisih = max(abs(x - x_lama));
    if iter <= 5 || selisih < tol
        fprintf('%-5d %-12.2f %-12.2f %-12.2f %-12.2f %-10.2e\n', iter, x(1), x(2), x(3), x(4), selisih);
    end
    if selisih < tol, break; end
end
fprintf('Konvergen pada iterasi ke-%d\n', iter);

fprintf('\n=== HASIL AKHIR (GAUSS-SEIDEL) ===\n');
for i = 1:n
    fprintf('%-7s : Rp %10.2f per kg\n', nama_bahan{i}, x(i));
end

% 5. Verifikasi dengan metode langsung Gauss-Jordan
M = [A0, b0];                           % matriks augmented (urutan asli)
for k = 1:n
    [~, p] = max(abs(M(k:n, k)));       % pivoting parsial
    p = p + k - 1;
    M([k p], :) = M([p k], :);
    M(k,:) = M(k,:) / M(k,k);           % normalisasi baris pivot
    for i = [1:k-1, k+1:n]
        M(i,:) = M(i,:) - M(i,k) * M(k,:);   % nol-kan kolom k di baris lain
    end
end
x_gj = M(:, end);

fprintf('\n=== VERIFIKASI (GAUSS-JORDAN) & RESIDU ===\n');
for i = 1:n
    fprintf('%-7s : Gauss-Seidel = %10.2f | Gauss-Jordan = %10.2f\n', nama_bahan{i}, x(i), x_gj(i));
end
fprintf('Residu maks |A0*x - b0| (Gauss-Seidel) = %.4e\n', max(abs(A0*x - b0)));
