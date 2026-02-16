function slBusOut = Path(msgIn, slBusOut, varargin)
%#codegen
%   Copyright 2021-2022 The MathWorks, Inc.
    currentlength = length(slBusOut.header);
    for iter=1:currentlength
        slBusOut.header(iter) = bus_conv_fcns.ros2.msgToBus.std_msgs.Header(msgIn.header(iter),slBusOut(1).header(iter),varargin{:});
    end
    slBusOut.header = bus_conv_fcns.ros2.msgToBus.std_msgs.Header(msgIn.header,slBusOut(1).header,varargin{:});
    maxlength = length(slBusOut.points);
    recvdlength = length(msgIn.points);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'points', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.points_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.points_SL_Info.CurrentLength = uint32(currentlength);
    for iter=1:currentlength
        slBusOut.points(iter) = bus_conv_fcns.ros2.msgToBus.autoware_planning_msgs.PathPoint(msgIn.points(iter),slBusOut(1).points(iter),varargin{:});
    end
    maxlength = length(slBusOut.left_bound);
    recvdlength = length(msgIn.left_bound);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'left_bound', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.left_bound_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.left_bound_SL_Info.CurrentLength = uint32(currentlength);
    for iter=1:currentlength
        slBusOut.left_bound(iter) = bus_conv_fcns.ros2.msgToBus.geometry_msgs.Point(msgIn.left_bound(iter),slBusOut(1).left_bound(iter),varargin{:});
    end
    maxlength = length(slBusOut.right_bound);
    recvdlength = length(msgIn.right_bound);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'right_bound', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.right_bound_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.right_bound_SL_Info.CurrentLength = uint32(currentlength);
    for iter=1:currentlength
        slBusOut.right_bound(iter) = bus_conv_fcns.ros2.msgToBus.geometry_msgs.Point(msgIn.right_bound(iter),slBusOut(1).right_bound(iter),varargin{:});
    end
end
