%% load generated path data
% pathArrayFromPathMsg must already exist in workspace

refPose = pathArrayFromPathMsg;
xRef = refPose(:,1);
yRef = refPose(:,2);
referance_path = refPose(:,1:2);

L = 3;
ld = 5;
min_ld = 3;
max_ld = 10;
max_steer_cmd = 0.5;
min_steer_cmd = 0.0;

min_vel = 5;
max_vel = 10;

X_o = refPose(1,1);
Y_o = refPose(1,2);

dx0 = referance_path(2,1) - referance_path(1,1);
dy0 = referance_path(2,2) - referance_path(1,2);
psi_o = atan2(dy0, dx0);

figure;
plot(xRef, yRef);
grid on;
axis equal;
xlabel('X [m]');
ylabel('Y [m]');
title('Reference Path');