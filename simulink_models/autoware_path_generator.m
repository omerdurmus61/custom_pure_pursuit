%% define referance path 
poses = [out.autoware_path_array.pose];
pos   = [poses.position];
x = [pos.x];
x = [x.Data];
y = [pos.y];
y = [y.Data];
autoware_path_variable = [x(1,:)' y(1,:)'];
%% ackermann and pure pursuit parameters
L = 3; % wheel base

ld = 5; % lookahead distance
min_ld = 3;
max_ld = 10;
max_steer_cmd = 0.5;
min_steer_cmd = 0.0;

min_vel = 5;
max_vel = 10;

X_o = autoware_path_variable(1,1); % initial x position
Y_o = autoware_path_variable(1,2); % initial y position 
autoware_path_x = autoware_path_variable(:,1);
autoware_path_y = autoware_path_variable(:,2);
psi_o = 0; % initial yaw angle

