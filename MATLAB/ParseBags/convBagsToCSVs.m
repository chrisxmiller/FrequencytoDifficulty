%Script to read in bag files with the JS node present
%Convert the JS node data to frequency and save as a CSV
%Does this in batch.
%Written by: C. Miller - chris.x.miller@u.northwestern.edu
%argallab - Northwestern University - ShirleyRyan AbilityLab - 2018
%Written: 5/15/2018
%Revised: 5/15/2018

%Clear the workspace
clc
clear all
close all

num_subs = 20;
num_trials = 26;
%Window size for the moving mean
mov_mean_wind = 10;

%Make a titles matrix
for i = 1:num_subs
    for j = 1:num_trials
        if(i < 10)
            title(i,j) = strcat("S0",num2str(i),"_",num2str(j),".bag");
        else
            title(i,j) = strcat("S",num2str(i),"_",num2str(j),".bag");
        end
    end
end

%Extract the data and write to CSV
Errors = [];
err_cnt = 1;
for i = 1:num_subs
    for j = 1:num_trials
        %Open the bag file
        try
            bag = rosbag(char(title(i,j)));
            disp(title(i,j))
        catch
            Errors(err_cnt) = title(i,j);
            err_cnt = err_cnt+1;
            disp(title(i,j))
            disp("Error^")
            continue;
        end
        %Extract the joy node
        js = select(bag, 'Topic','/joy');
        %Extract the time vec
        [~,~,timeraw] = jsTopictoVecs(js);
        %Convert to mean frequency
        freq = jsTimeToMeanFreq(timeraw,mov_mean_wind);
        %Title extraction for CSV
        name = char(title(i,j));
        name = name(1:end-3);
        name = strcat(name,"csv");
        %Write to CSV
        csvwrite(name,freq');        
        %Clear the old stuff
        clear bag js timeraw freq name  
        %Increment loop and run
    end
end
