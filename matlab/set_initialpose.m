function [] = set_initialpose(x,y,yaw)
init = rospublisher('/initialpose')
msg = rosmessage(init)

msg.Header.FrameId = 'map';

msg.Pose.Pose.Position.X = 2;%x
msg.Pose.Pose.Position.Y = 2;%y
msg.Pose.Pose.Position.Z = 0;%yaw;

%yawRad = deg2rad(yaw) degrees or radians
% q = eul2quat([0, 0, 0]);
% msg.Pose.Pose.Orientation.W = q(1);
% msg.Pose.Pose.Orientation.X = q(2);
% msg.Pose.Pose.Orientation.Y = q(3);
% msg.Pose.Pose.Orientation.Z = q(4);


msg.Pose.Covariance = [0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
      0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.06853891945200942];

send(init,msg) 
  
end
