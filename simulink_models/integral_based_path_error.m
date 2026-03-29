
%% INPUTS
raw_reference_path = data.ActorSpecifications.Waypoints;
reference_path = raw_reference_path(:,1:2);

tracked_path  = out.tracked_path(:,1:2);   % regulated pp
tracked_path2 = out.tracked_path2(:,1:2);  % pp

kernel_size = 3;

%% FUNCTION: projection + area calculation
function [projected_points, total_area] = compute_area(reference_path, tracked_path, kernel_size)

    num_tracked = size(tracked_path, 1);
    num_ref     = size(reference_path, 1);

    projected_points = zeros(num_tracked, 2);
    point_errors     = zeros(num_tracked, 1);

    for i = 1:num_tracked
        
        X = tracked_path(i,:);
        
        % Find the closest reference waypoint
        distance_sp = zeros(num_ref, 1);
        for j = 1:num_ref
            distance_sp(j) = norm(reference_path(j,:) - X);
        end
        
        [~, starting_index] = min(distance_sp);
        
        % Define local segment search range
        if starting_index <= kernel_size
            seg_start = 1;
            seg_end   = min(num_ref - 1, starting_index + kernel_size);
            
        elseif (num_ref - starting_index) <= kernel_size
            seg_start = max(1, starting_index - kernel_size);
            seg_end   = num_ref - 1;
            
        else
            seg_start = starting_index - kernel_size;
            seg_end   = starting_index + kernel_size;
        end
        
        % Find the best projection on candidate segments
        min_error = inf;
        best_T = [0 0];
        
        for k = seg_start:seg_end
            A = reference_path(k,:);
            B = reference_path(k+1,:);
            
            AB = B - A;
            AX = X - A;
            
            denom = dot(AB, AB);
            if denom < 1e-12
                T = A;
            else
                t = dot(AX, AB) / denom;
                t = max(0, min(1, t));
                T = A + t * AB;
            end
            
            e = norm(X - T);
            
            if e < min_error
                min_error = e;
                best_T = T;
            end
        end
        
        projected_points(i,:) = best_T;
        point_errors(i) = min_error;
    end

    % Trapezoidal area calculation
    total_area = 0;
    for i = 1:num_tracked-1
        e1 = point_errors(i);
        e2 = point_errors(i+1);
        ds = norm(tracked_path(i+1,:) - tracked_path(i,:));
        
        total_area = total_area + 0.5 * (e1 + e2) * ds;
    end
end

%% CALCULATIONS
[proj1, area1] = compute_area(reference_path, tracked_path, kernel_size);
[proj2, area2] = compute_area(reference_path, tracked_path2, kernel_size);

%% COMMAND WINDOW OUTPUT
disp(['Regulated PP area error = ', num2str(area1), ' m^2']);
disp(['PP area error           = ', num2str(area2), ' m^2']);

%% FIGURE 1: BOTH METHODS TOGETHER
figure;
hold on;
axis equal;
grid on;

% regulated pp (blue)
for i = 1:size(tracked_path,1)-1
    quad_x = [tracked_path(i,1), tracked_path(i+1,1), ...
              proj1(i+1,1), proj1(i,1)];
    quad_y = [tracked_path(i,2), tracked_path(i+1,2), ...
              proj1(i+1,2), proj1(i,2)];
    
    patch(quad_x, quad_y, [0 0.45 1], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

% pp (yellow)
for i = 1:size(tracked_path2,1)-1
    quad_x = [tracked_path2(i,1), tracked_path2(i+1,1), ...
              proj2(i+1,1), proj2(i,1)];
    quad_y = [tracked_path2(i,2), tracked_path2(i+1,2), ...
              proj2(i+1,2), proj2(i,2)];
    
    patch(quad_x, quad_y, [1 0.8 0], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

legend('regulated pp', 'pp');
title('Area Comparison: regulated pp vs pp');
xlabel('X [m]');
ylabel('Y [m]');

%% FIGURE 2: ONLY REGULATED PP
figure;
hold on;
axis equal;
grid on;

for i = 1:size(tracked_path,1)-1
    quad_x = [tracked_path(i,1), tracked_path(i+1,1), ...
              proj1(i+1,1), proj1(i,1)];
    quad_y = [tracked_path(i,2), tracked_path(i+1,2), ...
              proj1(i+1,2), proj1(i,2)];
    
    patch(quad_x, quad_y, [0 0.45 1], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

legend('regulated pp');
title(['Regulated PP area = ', num2str(area1), ' m^2']);
xlabel('X [m]');
ylabel('Y [m]');

%% FIGURE 3: ONLY PP
figure;
hold on;
axis equal;
grid on;

for i = 1:size(tracked_path2,1)-1
    quad_x = [tracked_path2(i,1), tracked_path2(i+1,1), ...
              proj2(i+1,1), proj2(i,1)];
    quad_y = [tracked_path2(i,2), tracked_path2(i+1,2), ...
              proj2(i+1,2), proj2(i,2)];
    
    patch(quad_x, quad_y, [1 0.8 0], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

legend('pp');
title(['PP area = ', num2str(area2), ' m^2']);
xlabel('X [m]');
ylabel('Y [m]');

%% FIGURE 4: ALL THREE VIEWS SIDE BY SIDE
figure;

% Subplot 1: combined
subplot(1,3,1);
hold on;
axis equal;
grid on;

for i = 1:size(tracked_path,1)-1
    quad_x = [tracked_path(i,1), tracked_path(i+1,1), ...
              proj1(i+1,1), proj1(i,1)];
    quad_y = [tracked_path(i,2), tracked_path(i+1,2), ...
              proj1(i+1,2), proj1(i,2)];
    
    patch(quad_x, quad_y, [0 0.45 1], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

for i = 1:size(tracked_path2,1)-1
    quad_x = [tracked_path2(i,1), tracked_path2(i+1,1), ...
              proj2(i+1,1), proj2(i,1)];
    quad_y = [tracked_path2(i,2), tracked_path2(i+1,2), ...
              proj2(i+1,2), proj2(i,2)];
    
    patch(quad_x, quad_y, [1 0.8 0], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

legend('regulated pp', 'pp');
title('Combined');
xlabel('X [m]');
ylabel('Y [m]');

% Subplot 2: regulated pp only
subplot(1,3,2);
hold on;
axis equal;
grid on;

for i = 1:size(tracked_path,1)-1
    quad_x = [tracked_path(i,1), tracked_path(i+1,1), ...
              proj1(i+1,1), proj1(i,1)];
    quad_y = [tracked_path(i,2), tracked_path(i+1,2), ...
              proj1(i+1,2), proj1(i,2)];
    
    patch(quad_x, quad_y, [0 0.45 1], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

legend('regulated pp');
title('Regulated PP');
xlabel('X [m]');
ylabel('Y [m]');

% Subplot 3: pp only
subplot(1,3,3);
hold on;
axis equal;
grid on;

for i = 1:size(tracked_path2,1)-1
    quad_x = [tracked_path2(i,1), tracked_path2(i+1,1), ...
              proj2(i+1,1), proj2(i,1)];
    quad_y = [tracked_path2(i,2), tracked_path2(i+1,2), ...
              proj2(i+1,2), proj2(i,2)];
    
    patch(quad_x, quad_y, [1 0.8 0], ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.4);
end

legend('pp');
title('PP');
xlabel('X [m]');
ylabel('Y [m]');