%% ========================================================================
%  SME3701 - ASSIGNMENT 1, QUESTION 1
%  Undamped Free Vibration of a Single-Degree-of-Freedom (SDOF)
%  Mass-Spring System
%
%  Author      : [Mbalabu Israel Mbalabu 66926203]
%  Module      : SME3701 - Mechanical Vibrations
%  Institution : University of South Africa (UNISA)
%  Date        : [28/04/2026]
%
%  Description :
%      This script analyses the undamped free vibration response of a
%      single-degree-of-freedom (SDOF) mass-spring system. It computes the
%      natural angular frequency, displacement, velocity, and acceleration
%      responses, verifies energy conservation, and produces publication-
%      quality plots for each quantity.
%
%  Governing ODE :
%      m * x_ddot + k * x = 0
%
%  Analytical Solution (with v0 = 0) :
%      x(t) = x0 * cos(omega_n * t)
%      v(t) = -x0 * omega_n * sin(omega_n * t)
%      a(t) = -x0 * omega_n^2 * cos(omega_n * t)
% =========================================================================

%% ------------------------------------------------------------------------
%  HOUSEKEEPING - prepare a clean MATLAB environment
%  ------------------------------------------------------------------------
clear;            % Remove all variables from the workspace
clc;              % Clear the Command Window
close all;        % Close any figure windows from previous runs
format short g;   % Use compact, readable numerical output

%% ------------------------------------------------------------------------
%  SECTION 1 : SYSTEM PARAMETERS
%  ------------------------------------------------------------------------
m  = 5;           % Mass [kg]
k  = 2000;        % Spring stiffness [N/m]
x0 = 0.02;        % Initial displacement [m]
v0 = 0;           % Initial velocity [m/s]
c  = 0;           % Damping coefficient [N.s/m] (zero for this problem)

% Validate inputs to ensure the script fails gracefully on bad data
%%
% 
%   for x = 1:10
%       disp(x)
%   end
% 
assert(m  > 0, 'Mass must be positive.');
assert(k  > 0, 'Stiffness must be positive.');
assert(c >= 0, 'Damping coefficient cannot be negative.');

%% ------------------------------------------------------------------------
%  1.1  NATURAL ANGULAR FREQUENCY
%  For an undamped SDOF system: omega_n = sqrt(k/m)
%  ------------------------------------------------------------------------
omega_n = sqrt(k/m);          % Natural angular frequency [rad/s]
f_n     = omega_n/(2*pi);     % Natural cyclic frequency [Hz]
T_n     = 1/f_n;              % Natural period [s]
zeta    = c/(2*sqrt(k*m));    % Damping ratio (dimensionless) - zero here

% Pretty-printed results to the Command Window
fprintf('\n==========================================================\n');
fprintf('  SME3701 - Q1 : Undamped SDOF Free Vibration Analysis\n');
fprintf('==========================================================\n');
fprintf('  System Parameters\n');
fprintf('    Mass, m              = %8.4f kg\n',   m);
fprintf('    Stiffness, k         = %8.4f N/m\n',  k);
fprintf('    Initial disp., x0    = %8.4f m\n',    x0);
fprintf('    Initial vel., v0     = %8.4f m/s\n',  v0);
fprintf('----------------------------------------------------------\n');
fprintf('  1.1  Natural Frequency Results\n');
fprintf('    Angular freq., wn    = %8.4f rad/s\n', omega_n);
fprintf('    Cyclic freq., fn     = %8.4f Hz\n',    f_n);
fprintf('    Period, Tn           = %8.4f s\n',     T_n);
fprintf('    Damping ratio, zeta  = %8.4f\n',       zeta);
fprintf('----------------------------------------------------------\n');

%% ------------------------------------------------------------------------
%  1.2  DISPLACEMENT  x(t) = x0 * cos(omega_n * t)
%  Use a fine time step so the sinusoid is rendered smoothly.
%  ------------------------------------------------------------------------
dt = 1e-3;                                 % Time step [s]
t  = 0:dt:5;                               % Time vector 0 to 5 s
x  = x0 * cos(omega_n * t);                % Displacement [m]

%% ------------------------------------------------------------------------
%  1.4  VELOCITY  v(t) = -x0 * omega_n * sin(omega_n * t)
%  Obtained analytically by differentiating x(t).
%  Acceleration is computed for completeness and the energy check below.
%  ------------------------------------------------------------------------
v = -x0 * omega_n    * sin(omega_n * t);   % Velocity [m/s]
a = -x0 * omega_n^2  * cos(omega_n * t);   % Acceleration [m/s^2]

% Peak amplitudes (theoretical)
v_max = x0 * omega_n;                      % Peak velocity [m/s]
a_max = x0 * omega_n^2;                    % Peak acceleration [m/s^2]

fprintf('  1.4  Velocity Results\n');
fprintf('    Peak velocity        = %8.4f m/s\n',     v_max);
fprintf('    Peak acceleration    = %8.4f m/s^2\n',   a_max);
fprintf('----------------------------------------------------------\n');

%% ------------------------------------------------------------------------
%  ENERGY CONSERVATION CHECK
%  In an undamped system, KE + PE must remain constant in time.
%  ------------------------------------------------------------------------
KE     = 0.5 * m * v.^2;        % Kinetic energy [J]
PE     = 0.5 * k * x.^2;        % Potential energy [J]
E_tot  = KE + PE;               % Total mechanical energy [J]
E_var  = max(E_tot) - min(E_tot);

fprintf('  Energy Conservation Check\n');
fprintf('    Mean total energy    = %12.6f J\n', mean(E_tot));
fprintf('    Energy variation     = %12.3e J  (numerical noise)\n', E_var);
fprintf('==========================================================\n\n');

%% ------------------------------------------------------------------------
%  COMMON PLOT STYLING
%  Centralised settings keep all figures visually consistent.
%  ------------------------------------------------------------------------
lw     = 1.6;                   % Line width
fs_ax  = 12;                    % Axis label font size
fs_ttl = 13;                    % Title font size
fs_leg = 11;                    % Legend font size

%% ------------------------------------------------------------------------
%  1.3  PLOT : DISPLACEMENT vs TIME
%  ------------------------------------------------------------------------
figure('Name','Q1.3 Displacement vs Time', ...
       'Color','w','Position',[100 550 850 380]);
plot(t, x, 'b-', 'LineWidth', lw); hold on;

% Annotate the initial condition point on the curve
plot(0, x0, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'k');
text(0.05, x0, sprintf('  x(0) = %.3f m', x0), ...
     'FontSize', 10, 'VerticalAlignment','bottom');

grid on; grid minor;
xlabel('Time, t  [s]',                 'FontSize', fs_ax);
ylabel('Displacement, x(t)  [m]',      'FontSize', fs_ax);
title('Q1.3  Undamped SDOF Free Vibration: Displacement Response', ...
      'FontSize', fs_ttl);
legend('x(t) = x_0 cos(\omega_n t)', 'Initial condition', ...
       'Location','northeast','FontSize',fs_leg);
xlim([0 5]);
ylim([-1.30*x0, 1.30*x0]);
set(gca,'FontSize',11,'LineWidth',1.0,'Box','on');

%% ------------------------------------------------------------------------
%  1.4  PLOT : VELOCITY vs TIME
%  ------------------------------------------------------------------------
figure('Name','Q1.4 Velocity vs Time', ...
       'Color','w','Position',[100 100 850 380]);
plot(t, v, 'r-', 'LineWidth', lw); hold on;
plot(0, v0, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'k');
text(0.05, v0, sprintf('  v(0) = %.3f m/s', v0), ...
     'FontSize', 10, 'VerticalAlignment','bottom');

grid on; grid minor;
xlabel('Time, t  [s]',                 'FontSize', fs_ax);
ylabel('Velocity, v(t)  [m/s]',        'FontSize', fs_ax);
title('Q1.4  Undamped SDOF Free Vibration: Velocity Response', ...
      'FontSize', fs_ttl);
legend('v(t) = -x_0 \omega_n sin(\omega_n t)', 'Initial condition', ...
       'Location','northeast','FontSize',fs_leg);
xlim([0 5]);
ylim([-1.30*v_max, 1.30*v_max]);
set(gca,'FontSize',11,'LineWidth',1.0,'Box','on');

%% ------------------------------------------------------------------------
%  BONUS PLOT : COMBINED DISPLACEMENT & VELOCITY (PHASE COMPARISON)
%  Uses two y-axes so the 90 degree phase lead is clearly visible.
%  ------------------------------------------------------------------------
figure('Name','Phase Comparison: x(t) and v(t)', ...
       'Color','w','Position',[975 550 850 380]);
yyaxis left
plot(t, x, 'b-', 'LineWidth', lw);
ylabel('Displacement, x(t)  [m]','FontSize',fs_ax);
ylim([-1.30*x0, 1.30*x0]);

yyaxis right
plot(t, v, 'r-', 'LineWidth', lw);
ylabel('Velocity, v(t)  [m/s]','FontSize',fs_ax);
ylim([-1.30*v_max, 1.30*v_max]);

grid on; grid minor;
xlabel('Time, t  [s]','FontSize',fs_ax);
title('Phase Comparison: Velocity Leads Displacement by \pi/2', ...
      'FontSize',fs_ttl);
legend('Displacement x(t)','Velocity v(t)', ...
       'Location','northeast','FontSize',fs_leg);
xlim([0 1]);   % Zoom to first second for clarity
set(gca,'FontSize',11,'LineWidth',1.0,'Box','on');

%% ------------------------------------------------------------------------
%  BONUS PLOT : ENERGY CONSERVATION
%  ------------------------------------------------------------------------
figure('Name','Energy Conservation Check', ...
       'Color','w','Position',[975 100 850 380]);
plot(t, KE,    'r-',  'LineWidth', lw); hold on;
plot(t, PE,    'b-',  'LineWidth', lw);
plot(t, E_tot, 'k--', 'LineWidth', lw);
grid on; grid minor;
xlabel('Time, t  [s]',             'FontSize', fs_ax);
ylabel('Energy  [J]',              'FontSize', fs_ax);
title('Energy Exchange in Undamped SDOF System','FontSize',fs_ttl);
legend('Kinetic energy, KE','Potential energy, PE', ...
       'Total energy, E = KE + PE', ...
       'Location','east','FontSize',fs_leg);
xlim([0 1]);
ylim([0, 1.15*max(E_tot)]);
set(gca,'FontSize',11,'LineWidth',1.0,'Box','on');

%% ------------------------------------------------------------------------
%  EXPORT FIGURES TO HIGH-RESOLUTION PNG FILES (FOR THE REPORT)
%  Comment out this block if you do not want files saved automatically.
%  ------------------------------------------------------------------------
try
    exportgraphics(figure(1), 'Q1_3_Displacement.png',     'Resolution', 300);
    exportgraphics(figure(2), 'Q1_4_Velocity.png',         'Resolution', 300);
    exportgraphics(figure(3), 'Q1_PhaseComparison.png',    'Resolution', 300);
    exportgraphics(figure(4), 'Q1_EnergyConservation.png', 'Resolution', 300);
    fprintf('  Figures exported successfully to the current folder.\n\n');
catch ME
    fprintf('  [Warning] Figure export skipped: %s\n\n', ME.message);
end

%% ========================================================================
%  END OF SCRIPT
% =========================================================================
