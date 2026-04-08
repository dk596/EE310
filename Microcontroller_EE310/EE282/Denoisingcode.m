% Vinci Aure, 282
% Project Testing, Filtering High Frequency Noise using Low-Pass Circuit Implementation
% And comparing against matlab's inbuilt Signal Processing Functions.
% Given constant Resistance and Capacitance that is randomized every run, the script
% Would solve for a filtered signal.
% Variable Definition:
% R = Resistance in Ohms
% C = Capacitance in microFarads
% f_signal = Desired Signal in the 10-200 Hz range
% fa = Signal Amplitude 0.5 to 1.5
% phi = Phase Constant, random shift
% cs = Clean signal
% f_noise = Randomized High Frequency Noise signal
% fn = Noise signal Amplitude 0.2 to 0.8
% ns = Noisy Signal
% X = combined Clean and Noise induced signals
% Sr = Sampling rate of Frequency
% Ts = Sampling interval
% T = Simulation time in seconds
% Alpha = discrete time coefficient, a lower value results in stronger
% filtering, a higher value results in weaker filtering but less distorted
clc;
clear;
close all;
rng('shuffle'); % Shuffles values of randn/rand every run
Sr = 10000; % Sampling rate in Hz
Ts = 1/Sr; % Sampling interval
T = 0.06; % Simulation time in Seconds... I tried 1s but too big, small time sample only
t = 0:Ts:T; % Time Vector
% Original Signal
f_signal = 10 + (200-10)*rand(); % Original Clean Signal Frequency
fa = 0.5 + (1.5 - .5)*rand(); % Original Clean Signal Amplitude
phi1 = 2*pi*rand(); % Phase Constant
cs = fa * sin(2*pi*f_signal*t + phi1); % Wave equation (From Physics 214)
fprintf('The Frequency of the Clean signal is %.4f Hz and the Amplitude is %.2f. \n', f_signal, fa)
% Induced Noisy Signal
f_noise = 1000 + (2000-1000)*rand(); % Noisy Signal Frequency
fn = 0.2 + (0.6 - 0.2)*rand(); % Noisy Signal Amplitude
phi2 = 2*pi*rand(); % Noisy Signal Phase Constant
ns = fn * sin(2*pi*f_noise*t + phi2); % Noisy Wave Equation
fprintf('The Frequency of the Noise signal is %.4f Hz and the Amplitude is %.2f. \n', f_noise, fn)
X = cs + ns; % Combination of the two Waves
% Define Resistors and Capacitors
R = 500 + (2000-500)*rand(); 
C = 0.2e-6 + (2e-6 - 0.2e-6)*rand();
RC = R*C; % also known as time constant 𝜏
fc = 1/(2*pi*RC);
alpha = Ts / (RC + Ts);
% Resistance Range randomly selected from 500 to 2000 ohms
% Capacitance Range determined by solving C from the Cutoff Frequency
% Equation by solving for C = 1 / 2*pi*R*fc where the range of fc is 200 to
% 500 Hz. Solving for C at 200 and 500 Hz, the range is determined.
% RC = Resistance * Capacitance
% Fc = Frequency Cutoff, anything above such frequency will be omitted by
% the model.
% Alpha = Time Discrete constant that determines how strong or how weak
% filtering strength is but also how much distortion is introduced or
% removed from the output signal.
fprintf('The Resistance of the circuit is %.4f Ohms and the Capacitance is %.10f Farads. \n', R, C)
fprintf('The Cutoff High Frequency is %.4f Hz and the discrete time coefficient of the Circuit is %.4f \n', fc, alpha);
% Simulation
y = zeros(size(X));
y(1) = X(1);
for k = 2:length(X)
   y(k) = alpha*X(k) + (1-alpha)*y(k-1);
   % Differential Equation model Continuous Simulation such that the
   % original differential equation is RC*(dt/dy) ​+ y = x which when
   % solved for a function of y(t) becomes αx[k]+(1−α)y[k−1]. In Simpler terms
   % voltage decay/increase discrete time step
end
% Plot the Clean and Noise Signal
% Subplots allows multiple but smaller graphs to appear on one Figure, use
% this for all comparisons that don't need to be over on top of each other.
figure(1);
subplot(3,1,1);
plot(t, cs, 'b', 'LineWidth', 1.2);
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Original Clean Signal');
subplot(3,1,2);
plot(t, ns, 'r', 'LineWidth', 1.2);
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Noise Signal');
% Create a variable that Handles the Lowpass function built into MatLab and
% then plot the signals where: Noise has been induced to the clean signal,
% Filtered signal, and also the Signal from the Lowpass function.
ylp = lowpass(X, fc, Sr);
% Lowpass function built into matlab taking in arguments for Noisy signal,
% cut off frequency, and Sampling Rate.
figure(2);
subplot(3,1,1);
plot(t, X, 'r');
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Noise Induced Signal');
subplot(3,1,2);
plot(t, y, 'g', 'LineWidth', 1.2);
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Filtered Signal (RC Low-Pass)');
subplot(3,1,3);
plot(t, ylp);
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Matlab LowPass Function');
% Plot just the Signal Filtered through the First Order RC Circuit and
% compare against Original Clean and Induced Noisy Signal
figure(3);
plot(t, cs, 'b', 'LineWidth', 1.7); hold on;
plot(t, X, 'r');
plot(t, y, 'g', 'LineWidth', 1.5);
legend('Clean', 'Noisy', 'Filtered');
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Visual Comparison of Clean Signal, Noisy Signal, and Filtered (RC)');
% Compare the First Order RC Circuit (analog) to the Digital Signal
% Processing function in Matlab (Lowpass)
figure(4);
plot(t, y, 'g', 'LineWidth', 1.2); hold on;
plot(t, ylp);
legend('Filtered Manual Equation', 'Lowpass Toolbox');
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Comparison of Toolbox LowPass Function vs Equation');
% Highpass Filter Portion
% Highpass would now remove the "clean" signal and keep only the noisy
% portion
fcH = 1/(2*pi*RC);
alpha1 = RC / (RC + Ts);
fprintf('The Cutoff Low Frequency is %.4f Hz and the discrete time coefficient of the Circuit is %.4f \n', fcH, alpha1);
y = zeros(size(X));
y(1) = 0;
% Equation for High Pass
for k = 2:length(X)
   y(k) = alpha1*(y(k-1) + X(k)-X(k - 1));
end
yhp = highpass(X, fcH, Sr);
figure(5);
subplot(3,1,1);
plot(t, X, 'r');
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Noise Induced Signal');
subplot(3,1,2);
plot(t, y, 'g', 'LineWidth', 1.2);
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Filtered Signal (RC High Pass)');
subplot(3,1,3);
plot(t, yhp);
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Matlab Highpass Function');
figure(6);
plot(t, y, 'g', 'LineWidth', 1.2); hold on;
plot(t, yhp);
legend('Filtered Manual Equation', 'HighPass Toolbox');
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Comparison of Toolbox HighPass Function vs Equation');
figure(7);
plot(t, ylp); hold on;
plot(t, yhp);
legend('RC LowPass', 'RC HighPass');
ylabel('Amplitude');
xlabel('time (S)');
grid on;
title('Comparison of Low and Highpass Filters');
