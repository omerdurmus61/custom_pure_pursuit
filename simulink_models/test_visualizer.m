clc;
close all;

%% Check variables

if ~exist('xRef','var') || ~exist('yRef','var')
    error('Reference path (xRef, yRef) not found in workspace.');
end

if ~exist('out','var')
    error('Simulink output variable "out" not found in workspace.');
end

%% Create compact layout

tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

%% Plot

for i = 1:4
    nexttile;
    
    % Reference path
    plot(xRef, yRef, 'r', 'LineWidth', 0.7);
    hold on;
    
    % Regulated PP
    plot(out.tracked_path_x, out.tracked_path_y, 'g', 'LineWidth', 0.7);
    
    % PP
    plot(out.tracked_path_x2, out.tracked_path_y2, 'b', 'LineWidth', 0.7);
    
    grid on;
    axis equal;
    
    xlabel('X [m]');
    ylabel('Y [m]');
    title(['Region ', num2str(i)]);
    
    % Show legend only once (clean look)
    if i == 1
        legend("ref","regulated pp","pp");
    end
end

%% Enable interaction

zoom on;
pan on;

disp('Compact plot with line width = 0.7 ready.');