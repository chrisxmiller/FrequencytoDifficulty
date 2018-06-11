%jsTopictoVecs: Processes ROS joy node data
%Reads: a ros bag selection of type /sensor_msgs_Joy; 
%Returns: type double vectors containing axis, button, time data
%
%Written by: C. Miller - chris.x.miller@u.northwestern.edu
%argallab - Northwestern University - ShirleyRyan AbilityLab - 2018
%Written: 5/4/2018
%Revised: 5/4/2018

function [ax, but, time] = jsTopictoVecs(jdat)

%Constants
nStoS = 10^9;

%Get the messages from the bag
msgs = jdat.readMessages;
len = length(msgs);

%extract the axis and buttons. : notation can't be used here to extract
%entire rows of data. We're forced to loop
for i = 1:len
    ax(i,:) = double(msgs{i}.Axes);
    but(i,:) = double(msgs{i}.Buttons);
    headers(i) = msgs{i}.Header;
end

%Convert time
%initial times
sec_0 = double(headers(1).Stamp.Sec);
%Preallcoation baby!
time = zeros(len,1);
for i = 1:len
    sec = double(headers(i).Stamp.Sec);
    nsc = double(headers(i).Stamp.Nsec);
    time(i) = sec + (nsc/nStoS);
end
%Subtract off the initial time since epoc stuff
time = time - sec_0;
end
