clc;
clear;
close all;

%% User settings

% ROS 2 bag folder path
bagPath = '/home/omer/bags/mlk_dataset_path';

% Path topic
pathTopic = '/dlio/odom_node/path';

%% Open ROS 2 bag

% Create a ROS 2 bag reader object
bagReader = ros2bagreader(bagPath);

%% ------------------------------------------------------------------------
% PART 1: Read only the last Path message
% Output format:
% pathArrayFromPathMsg = [x y z qx qy qz qw]
% Each row corresponds to one pose in the last Path message
% -------------------------------------------------------------------------

% Select messages from the Path topic
pathSel = select(bagReader, 'Topic', pathTopic);

% Check whether any Path message exists
if pathSel.NumMessages < 1
    error('No messages found on topic: %s', pathTopic);
end

% Read only the last Path message for faster execution
lastMsgIndex = pathSel.NumMessages;
lastPathMsgCell = readMessages(pathSel, lastMsgIndex);
lastPathMsg = lastPathMsgCell{1};

% Get all poses from the last Path message
posesField = lastPathMsg.poses;

% Convert poses to cell array if necessary
if iscell(posesField)
    poseList = posesField;
else
    poseList = num2cell(posesField);
end

numPathPoses = numel(poseList);

% Preallocate array
% Columns: [x y z qx qy qz qw]
pathArrayFromPathMsg = zeros(numPathPoses, 7);

% Fill the array with pose data
for i = 1:numPathPoses
    poseStamped = poseList{i};

    position = poseStamped.pose.position;
    orientation = poseStamped.pose.orientation;

    pathArrayFromPathMsg(i, :) = [ ...
        double(position.x), ...
        double(position.y), ...
        double(position.z), ...
        double(orientation.x), ...
        double(orientation.y), ...
        double(orientation.z), ...
        double(orientation.w)];
end

%% ------------------------------------------------------------------------
% PART 2: Visualize the path in XY plane
% -------------------------------------------------------------------------

figure;
plot(pathArrayFromPathMsg(:,1), pathArrayFromPathMsg(:,2));
grid on;
axis equal;

xlabel('X [m]');
ylabel('Y [m]');
title('Last Path Message');

%% ------------------------------------------------------------------------
% PART 3: Save the array
% -------------------------------------------------------------------------

save('mlk_dataset_last_path.mat', 'pathArrayFromPathMsg');

disp('Last Path message was converted to array, plotted, and saved.');