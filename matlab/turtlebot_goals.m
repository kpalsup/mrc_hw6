% ipaddress = '192.168.154.131';
% rosinit(ipaddress);
% 
% rosaction list
% 
% [client,goalMsg] = rosactionclient('/turtlebot_move');
% waitForServer(client)
% 
% goalMsg.ForwardDistance = 2;
% goalMsg.TurnDistance = 0;
% 
% client.FeedbackFcn = [];
% 
% [resultMsg,~,~] = sendGoalAndWait(client,goalMsg)
% 
% 
% rosshutdown
% 
% %UNTITLED3 Summary of this function goes here

%% Init
% Setup ROS with defaults
rosinit()

% Get a list of available actions to see what servers are available
rosaction list

%% Connect to move_base action server
% This initiates the client and prints out some diagnostic information
[client,goalMsg] = rosactionclient('/move_base')
waitForServer(client);

% Is the client connected to the server?
client.IsServerConnected

%% Setup call back functions for the action client
client.ActivationFcn=@(~)disp('Goal active');
client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f, Y=%.2f, yaw=%.2f, pitch=%.2f, roll=%.2f  \n',msg.BasePosition.Pose.Position.X,...
    msg.BasePosition.Pose.Position.Y,quat2eul([msg.BasePosition.Pose.Orientation.W,...
    msg.BasePosition.Pose.Orientation.X,msg.BasePosition.Pose.Orientation.Y, ...
    msg.BasePosition.Pose.Orientation.Z]));

client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f\n',msg.BasePosition.Pose.Position.X);
client.ResultFcn=@(~,res)fprintf('Result received: State: <%s>, StatusText: <%s>\n',res.State,res.StatusText);

%% Populate the goal to be sent to the server
% A good way to determine the syntax is to use tab-complete in the command
% window
goalMsg.TargetPose.Header.FrameId = 'map';
goalMsg.TargetPose.Pose.Position.X = 0.5;
goalMsg.TargetPose.Pose.Position.Y = 0.0;
yawtgt = pi/2;   % Setting the target heading
q = eul2quat([yawtgt, 0,0]);
goalMsg.TargetPose.Pose.Orientation.W=q(1);
goalMsg.TargetPose.Pose.Orientation.X=q(2);
goalMsg.TargetPose.Pose.Orientation.Y=q(3);
goalMsg.TargetPose.Pose.Orientation.Z=q(4);


%% Start the action and wait for it to finish - successfully or not
resultmsg = sendGoalAndWait(client,goalMsg);
fprintf('Action completed: State: <%s>, StatusText: <%s>\n',resultmsg.State,resultmsg.StatusText);

%% If necessary, cancel the action 
cancelAllGoals(client)

%% Shutdown
rosshutdown()
delete(client)
