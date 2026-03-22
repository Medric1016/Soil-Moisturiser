ml = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]';

adc_set1 = [3847.72, 3298.15, 2598.20, 2242.15, 2080.62, 1919.09, 1757.56, ...
            1596.04, 1509.30, 1499.82, 1382.95, 1358.68, 1350.32]';
adc_set2 = [3845.56, 3289.1,  2601.3,  2240.87, 2076.97, 1917.5,  1759.6,  ...
            1621.43, 1514.49, 1531.25, 1384.6,  1355.31, 1347.53]';
adc_set3 = [3850.20, 3264.65, 2503.15, 2282.80, 2080.50, 1978.30, 1752.30, ...
            1689.65, 1687.35, 1557.70, 1384.55, 1376.20, 1353.75]';
adc_set4 = [3845.25, 3331.65, 2693.25, 2211.85, 2106.25, 1857.35, 1650.05, ...
            1581.90, 1331.25, 1441.95, 1381.35, 1341.15, 1346.90]';

mask    = ml >= 15 & ml <= 35;
ml_all  = [ml(mask); ml(mask); ml(mask); ml(mask)];
adc_all = [adc_set1(mask); adc_set2(mask); adc_set3(mask); adc_set4(mask)];
ml_fine = linspace(0, 60, 300)';

p1 = polyfit(ml_all, adc_all, 1);
%p2 = polyfit(ml_all, adc_all, 2);

ss_tot = sum((adc_all - mean(adc_all)).^2);
r2 = @(p) 1 - sum((adc_all - polyval(p, ml_all)).^2) / ss_tot;

% ── Figure 1: Final linear regression ────────────────────────────────────
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

annotation_str = sprintf('ADC = %.4f·ml + %.4f\nR² = %.4f', p1(1), p1(2), r2(p1));
text(0, 1450, annotation_str, ...
    'FontSize', 11, ...
    'Color', [1 1 1], ...
    'BackgroundColor', [0.1 0.1 0.1], ...
    'EdgeColor', [1 1 1], ...
    'LineWidth', 1.5, ...
    'Margin', 6, ...
    'FontName', 'Courier New');

xlabel('Soil moisture (ml)', 'FontSize', 12);
ylabel('Sensor ADC value',   'FontSize', 12);
title('Final linear regression', 'FontSize', 13);
legend('Location', 'northeast', 'FontSize', 11);
grid on;
xlim([-2, 62]);
set(gca, 'XTick', 0:5:60);

fprintf('\n--- Polynomial fit coefficients ---\n\n');
fprintf('1st order: ADC = %.4f * ml + %.4f\n', p1(1), p1(2));
%fprintf('2nd order: ADC = %.4f * ml^2 + %.4f * ml + %.4f\n', p2(1), p2(2), p2(3));

% ── Non-linearity calculations (sets 3 & 4 combined) ─────────────────────
ml_m     = ml(mask);
s3_m     = adc_set3(mask);
s4_m     = adc_set4(mask);
combined = (s3_m + s4_m) / 2;

% Terminal point line through combined means
slope_tp = (combined(end) - combined(1)) / (ml_m(end) - ml_m(1));
int_tp   = combined(1) - slope_tp * ml_m(1);
tp_line  = slope_tp * ml_m + int_tp;

% Deviations of ALL 10 points (both sets) from the combined terminal line
tp_all   = slope_tp * [ml_m; ml_m] + int_tp;
adc_34   = [s3_m; s4_m];
devs     = adc_34 - tp_all;
max_dev  = max(abs(devs));
max_out  = max(adc_34);
nonlin   = (max_dev / max_out) * 100;

fprintf('\n--- Non-linearity (sets 3 & 4 combined, terminal point) ---\n\n');
fprintf('Terminal line:  ADC = %.4f * ml + %.4f\n', slope_tp, int_tp);
fprintf('Max deviation:  %.2f ADC counts\n', max_dev);
fprintf('Maximum output: %.2f ADC counts\n', max_out);
fprintf('Nonlinearity:   +/-%.4f%%\n', nonlin);

% ── Figure 2: Non-linearity plot ──────────────────────────────────────────
figure;
hold on;

plot(ml_m, s3_m, 's', 'Color', [0.11 0.62 0.46], ...
    'MarkerFaceColor', [0.11 0.62 0.46], 'MarkerSize', 7, ...
    'DisplayName', 'Set 3 data');
plot(ml_m, s4_m, 'o', 'Color', [0.11 0.62 0.46], ...
    'MarkerFaceColor', [0.11 0.62 0.46], 'MarkerSize', 7, ...
    'DisplayName', 'Set 4 data');
plot(ml_m, tp_line, '-', 'Color', [0.21 0.49 0.72], ...
    'LineWidth', 2.5, ...
    'DisplayName', 'Terminal line (combined means)');
plot(ml_m, tp_line + max_dev, '--', 'Color', [0.10 0.60 0.40], ...
    'LineWidth', 1.2, ...
    'DisplayName', sprintf('+%.2f counts', max_dev));
plot(ml_m, tp_line - max_dev, '--', 'Color', [0.21 0.49 0.72], ...
    'LineWidth', 1.2, ...
    'DisplayName', sprintf('-%.2f counts  (nonlinearity = +/-%.2f%%)', max_dev, nonlin));

hold off;

xlabel('Soil moisture (ml)', 'FontSize', 12);
ylabel('Sensor ADC value',   'FontSize', 12);
title('Non-linearity', 'FontSize', 13);
legend('Location', 'northeast', 'FontSize', 10);
grid on;
set(gca, 'XTick', ml_m);