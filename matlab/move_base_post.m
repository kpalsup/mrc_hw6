% ME4823 Justin Komma
% Read the image
clear all
close all
clc

ifile = '~/map.pgm';   % Image file name home/jlkomma/catkin_ws/src/mrc_hw6/
I=imread(ifile);

% the bag file
bag = rosbag('../nav_6.bag')

% Display a list of the topics and message types in the bag file
bag.AvailableTopics
   
% Since the messages on topic /odom are of type Odometry,
% let's see some of the attributes of the Odometry
% This helps determine the syntax for extracting data
msg_odom = rosmessage('nav_msgs/Odometry')
showdetails(msg_odom)
   
% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');
   
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');
% The time vector in the timeseries (ts.Time) is "Unix Time"
% which is a bit cumbersome.  Create a time vector that is relative
% to the start of the log file
tt = ts.Time-ts.Time(1);

% Set the size scaling
xWorldLimits = [-10 9.2];
yWorldLimits = [-10 9.2];
RI = imref2d(size(I),xWorldLimits,yWorldLimits)
 
% Plot
figure(1);
clf()
imshow(flipud(I),RI)
title('Fiveguys Position over Time','fontsize',20)
xlabel('X [m]','fontsize',20)
ylabel('Y [m]','fontsize',20)
set(gca,'YDir','normal')

hold on
a = plot(ts.data(:,1), ts.data(:,2));

% Select by topic
amcl_select = select(bag,'Topic','/amcl_pose');
 
% Create time series object
ts_amcl = timeseries(amcl_select,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

b = plot(ts_amcl.data(:,1), ts_amcl.data(:,2));

% Select by topic
goal_select = select(bag,'Topic','/move_base/goal');
 
% Create time series object
ts_goal = timeseries(goal_select,'Goal.TargetPose.Pose.Position.X','Goal.TargetPose.Pose.Position.Y',...
    'Goal.TargetPose.Pose.Orientation.W','Goal.TargetPose.Pose.Orientation.X',...
    'Goal.TargetPose.Pose.Orientation.Y','Goal.TargetPose.Pose.Orientation.Z');

c = plot(ts_goal.data(:,1), ts_goal.data(:,2));
legend([a b c], 'Position','AMCL','Goal')
saveas(gcf,'~/catkin_ws/src/mrc_hw6/images/rviz_goals.png')