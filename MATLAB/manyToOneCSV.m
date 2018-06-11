%Script to read in csvs of frequency data and concat them into one csv file
%for easier python usage. Lazy method vs doing in Python. Tired. 
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

%Open the files and write to matrix. HUGELY zeropadded matrix to make
%things easier. Assumes no data set was longer than 5000

outmatrix = zeros(20*26, 3000);
counter = 1;

for i = 1:num_subs
    for j = 1:num_trials
        try
            temp = csvread(char(title(i,j)))';
            [~,len] = size(temp);
            for k = 1:len
                outmatrix(counter,k) = temp(k);
            end
        catch
            outmatrix(counter,1:7) = 999999;
        end
        counter = counter +1;
    end
end

%Remove the infinities
outmatrix = outmatrix(:,7:end);




%Write to csv
csvwrite('combinedData.csv',outmatrix);