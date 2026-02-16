function slBusOut = PathPoint(msgIn, slBusOut, varargin)
%#codegen
%   Copyright 2021-2022 The MathWorks, Inc.
    currentlength = length(slBusOut.pose);
    for iter=1:currentlength
        slBusOut.pose(iter) = bus_conv_fcns.ros2.msgToBus.geometry_msgs.Pose(msgIn.pose(iter),slBusOut(1).pose(iter),varargin{:});
    end
    slBusOut.pose = bus_conv_fcns.ros2.msgToBus.geometry_msgs.Pose(msgIn.pose,slBusOut(1).pose,varargin{:});
    slBusOut.longitudinal_velocity_mps = single(msgIn.longitudinal_velocity_mps);
    slBusOut.lateral_velocity_mps = single(msgIn.lateral_velocity_mps);
    slBusOut.heading_rate_rps = single(msgIn.heading_rate_rps);
    slBusOut.is_final = logical(msgIn.is_final);
end
