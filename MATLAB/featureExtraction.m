%Script to extract a bunch of features from the dataset and classify using
%Weka. Opens the binary, top 38, and Easy-Med-Hard outputs and concats with
%the end of the file. Writes everything to CSVs.
%Written by: C. Miller - chris.x.miller@u.northwestern.edu
%argallab - Northwestern University - ShirleyRyan AbilityLab - 2018
%Written: 6/10/2018
%Revised: 6/10/2018
clc
clear all
close all

%Make a titles matrix
num_subs = 20;
num_trials = 26;

for i = 1:num_subs
    for j = 1:num_trials
        if(i < 10)
            title(i,j) = strcat("S0",num2str(i),"_",num2str(j),".csv");
        else
            title(i,j) = strcat("S",num2str(i),"_",num2str(j),".csv");
        end
    end
end

%Open the files and, for each, extract the features
%11 features for all the data sets
counter = 1;
bd = 1;

for i = 1:num_subs
    for j = 1:num_trials
        try
            temp = csvread(char(title(i,j)))';
            %Remove infinities
            temp_noinf = temp(7:end);
            %Extract some features
            devs = std(temp_noinf);
            avg = mean(temp_noinf);
            middle = median(temp_noinf);
            len = length(temp_noinf);
            %anything 10% below the average, count and throw into the epic
            %feats vector for further processing.
            num_below_avg = 0;
            z = 1;
            for k = 1:len
                if temp_noinf(k) < .9*avg
                    num_below_avg = num_below_avg+1;
                    %Store values for processing....
                    epicfeats(z) = temp_noinf(k);
                    z = z + 1;
                end
            end
            %On the feature set...
            %Average, standard dev, median, and the 25, 50, 75%th
            %percentiles
            avg_feats = mean(epicfeats);
            avg_devs = std(epicfeats);
            avg_mid = median(epicfeats);
            th25 = prctile(epicfeats,25);
            th50 = prctile(epicfeats,50);
            th75 = prctile(epicfeats,75);
            low = min(epicfeats);
            %We don't record the highest as that's the average of the above
            %anyway; it's already recorded
            data(counter,:) = [devs, avg, middle, len, avg_feats,...
                avg_devs, avg_mid, th25, th50, th75, low];
        catch
            data(counter,1) = 999999;
            %Count the bad rows
            badrows(bd) = counter;
            bd = bd+1;
        end
        clear epicfeats
        counter = counter + 1;
    end
end

%Read in the three data vecs
best32 = csvread('top38.csv');
easyhard = csvread('easyorhard.csv');
emh = csvread('emh.csv');

%Big CSVs
data32out = zeros(520,12);
dataehout = zeros(520,12);
dataemhout = zeros(520,12);

%Concat the data vecs for use in Weka
data32out(:,1:11) = data;
data32out(:,end) = best32;

dataehout(:,1:11) = data;
dataehout(:,end) = easyhard;

dataemhout(:,1:11) = data;
dataemhout(:,end) = emh;

%Remove the dead rows and write to CSV
data32out(badrows,:) = [];
dataehout(badrows,:) = [];
dataemhout(badrows,:) = [];

csvwrite('data32feats.csv',data32out);
csvwrite('dataehfeats.csv',dataehout);
csvwrite('dataemhfeats.csv',dataemhout);

%And since I need a double average filter on the LSTM on the raw data, I'll
%do that here too.

%-- Run a 10-point moving average filter on the big data set..
in = csvread('combinedData.csv');
rows = 520;

for i = 1:520
    %Pull the bad points
    if(in(i,1)) == 1000000
        newout(i,1:10) = 1000000;
    else
        newout(i,:) = movmean(in(i,:),10);
    end
end

%Pull the infinities
finalout = newout(:,7:end);

%Write to csv and be done, finally
csvwrite('doublefiltered.csv',finalout);









