% Volume (ml)
%y = [0 5 10 20 25 
y = [30 35 40 42.5 50 55 60];

% ADC values
%x = [(4020.75+4018.75+4023.3+4018.75) (4024+4009.4)*2 (4019.6+4024.1+4006.3+4015.25) (3851.75+3646.55+3795.05+3898.25) (3536.15+3752.55)*2 
x = [(3585.9+3446.1+3345.85+3489.85)  (3436.1+3392.25)*2 (3442.0+3133.6+3160.95+3518.65) (3167.15+3377.05)*2 (3297.15+2978.9+3064.85+3245.2) (3034.5+3117.15)*2 (3115.6+3000.05+2992.95+3032.4)]/4;

%0: 4020.38 5: 4016.7 10: 4016.3125 17.5:3770 20: 3797.7 25: 3644.35 30: 3466.925 35:3414.05 40:3313.8
%42.5:3272.1 50:3146.53 55:3075.825 60:3035.25

% Linear fit (degree = 1)
p = polyfit(x,y,1);

% Extract slope and intercept
m = p(1);
c = p(2);

% Display results
fprintf('Slope (m) = %.4f\n', m);
fprintf('Y-intercept (c) = %.4f\n', c);

% Plot the data and fitted line
x_fit = linspace(min(x),max(x),100);
y_fit = polyval(p,x_fit);

figure;
plot(x,y,'o','LineWidth',2);
hold on;
plot(x_fit,y_fit,'-','LineWidth',2);
xlabel('Volume (ml)');
ylabel('ADC Value');
title('Linear Fit using polyfit');
legend('Data','Best Fit Line');
grid on;


%------------------------------Second
%attempt-------------------------------
% Volume 2 (ml)
y1 = [0 5 10 20 25 30 35 40 42.5 50 55 60];

% ADC values
x1 = [4019*2 4014.15+4024.0 4018.05*2 4022.05*2 3858.4+4022.0 3776.25*2 3726.55+3735.2 3253.55*2 3438.3+3688.65 3557.25*2 3288.05*2 3292.65*2]/2;

% Linear fit (degree = 1)
p1 = polyfit(x1,y1,1);

% Extract slope and intercept
m1 = p1(1);
c1 = p1(2);

% Display results
fprintf('Slope (m1) = %.4f\n', m1);
fprintf('Y-intercept (c1) = %.4f\n', c1);

% Plot the data and fitted line
x_fit1 = linspace(min(x),max(x),100);
y_fit1 = polyval(p,x_fit);

figure;
plot(x1,y1,'o','LineWidth',2);
hold on;
plot(x_fit1,y_fit1,'-','LineWidth',2);
xlabel('Volume (ml)');
ylabel('ADC Value');
title('Linear Fit using polyfit');
legend('Data','Best Fit Line');
grid on;