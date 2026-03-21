ml = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]';
adc_set1 = [3847.72, 3298.15, 2598.20, 2242.15, 2080.62, 1919.09, 1757.56, ...
            1596.04, 1509.30, 1499.82, 1382.95, 1358.68, 1350.32]';
adc_set2 = [3847.72, 3298.15, 2598.20, 2242.15, 2080.62, 1919.09, 1757.56, ...
            1596.04, 1509.30, 1499.82, 1382.95, 1358.68, 1350.32]';
adc_set3 = [3850.20, 3264.65, 2503.15, 2282.80, 2080.50, 1978.30, 1752.30, ...
            1689.65, 1687.35, 1557.70, 1384.55, 1376.20, 1353.75]';
adc_set4 = [3845.25, 3331.65, 2693.25, 2211.85, 2106.25, 1857.35, 1650.05, ...
            1581.90, 1331.25, 1441.95, 1381.35, 1341.15, 1346.90]';

% Combine into single vectors
mask    = ml >= 15 & ml <= 35;
ml_all  = [ml(mask); ml(mask); ml(mask); ml(mask)];
adc_all = [adc_set1(mask); adc_set2(mask); adc_set3(mask); adc_set4(mask)];


ml_fine = linspace(0, 60, 300)';

% Fit
p1 = polyfit(ml_all, adc_all, 1);
%p2 = polyfit(ml_all, adc_all, 2);

% R²
ss_tot = sum((adc_all - mean(adc_all)).^2);
r2 = @(p) 1 - sum((adc_all - polyval(p, ml_all)).^2) / ss_tot;

figure;
hold on;

plot(ml_all, adc_all, 'o', 'Color', [0.11 0.62 0.46], ...
    'MarkerFaceColor', [0.11 0.62 0.46], 'MarkerSize', 6, ...
    'DisplayName', 'Calibration Data Points');

plot(ml_fine, polyval(p1, ml_fine), '-', 'Color', [0.21 0.49 0.72], ...
    'LineWidth', 1.8, 'DisplayName', sprintf('1st order (R²=%.4f)', r2(p1)));

%plot(ml_fine, polyval(p2, ml_fine), '-', 'Color', [0.84 0.37 0.19], ...
%    'LineWidth', 1.8, 'DisplayName', sprintf('2nd order (R²=%.4f)', r2(p2)));

hold off;
xlabel('Water added (ml)', 'FontSize', 12);
ylabel('Mean ADC count',   'FontSize', 12);
title('Final linear regression', 'FontSize', 13);
legend('Location', 'northeast', 'FontSize', 11);
grid on;
xlim([-2, 62]);
set(gca, 'XTick', 0:5:60);

fprintf('\n--- Polynomial fit coefficients ---\n\n');
fprintf('1st order: ADC = %.4f * ml + %.4f\n', p1(1), p1(2));
%fprintf('2nd order: ADC = %.4f * ml^2 + %.4f * ml + %.4f\n', p2(1), p2(2), p2(3));
