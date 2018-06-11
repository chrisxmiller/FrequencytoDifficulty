%Christopher Miller
%Argallab - ShirleyRyan AbilityLab - Northwestern University - 2018
%Script to parse joy topic into a time vector of float seconds and the
%three axes of the joystick. To be turned into a function

%--- Not in the function ---
clc
clear all
close all

%path to bag file
path = 'C:\Users\chris\Desktop\S20_1.bag';
%Read in the bag
bag = rosbag(path);
%Pull the joy topic
jdat = select(bag, 'Topic', 'joy');

%%% In the function
%Constants 
nStoS = 10^9;

%Get the messages from the bag
msgs = jdat.readMessages;
len = length(msgs);

%extract the data
for i = 1:len
    ax(i,:) = double(msgs{i}.Axes);
    but(i,:) = double(msgs{i}.Buttons);
    headers(i) = msgs{i}.Header;
end

%Convert time
%initial times 
sec = double(headers(1).Stamp.Sec);
sec_0 = sec(1);
time = zeros(len,1);
for i = 1:len
    sec = double(headers(i).Stamp.Sec);
    nsc = double(headers(i).Stamp.Nsec);
    time(i) = sec + (nsc/nStoS);
end
time = time - sec_0;


disp('done')