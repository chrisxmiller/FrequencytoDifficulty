%Script to read in csv NASATLX Matrix and classify as easy, hard etc. 
%Written by: C. Miller - chris.x.miller@u.northwestern.edu
%argallab - Northwestern University - ShirleyRyan AbilityLab - 2018
%Written: 6/9/2018
%Revised: 6/9/2018

clc
clear all;
close all;

%Read in the matrix
tlxmat = csvread('TLXMAT.csv');

%Since the scores are left skewed, log transform the matrix
%http://onlinestatbook.com/2/transformations/log.html
logtlxmat = log10(tlxmat);

%vectorize both matricies 
tlxvec = tlxmat(:);
logtlxvec = logtlxmat(:);

%Sort the vectors, maybe useful
sortedtlx = sort(tlxvec);
sortedlogtlx = sort(logtlxvec);

%First output, upper 38 that require assitance (see paper citation)
hard38 = zeros(20,26);
%Grab the cutoff TLX score
hard38veccutoff = sortedtlx(end-37);
%Classify as easy or hard based on this
for i = 1:20
    for j = 1:26
        if tlxmat(i,j) >= hard38veccutoff
            hard38(i,j) = 1;
        else
            hard38(i,j) = 0;
        end
    end
end

%Upper 50 percent, using log transform
fiftycutoff = prctile(logtlxvec,50);
fifty = zeros(20,26);

for i = 1:20
    for j = 1:26
        if logtlxmat(i,j) >= fiftycutoff
            fifty(i,j) = 1;
        else
            fifty(i,j) = 0;
        end
    end
end

%Easy, medium, hard using log transformed data
easycutoff = prctile(logtlxvec,33);
medcutoff = prctile(logtlxvec,67);
easymedhard = zeros(20,26);

%Easy = 0
%med = 1
%hard = 2

for i = 1:20
    for j = 1:26
        if logtlxmat(i,j) <= easycutoff
            easymedhard(i,j) = 0;
        elseif logtlxmat(i,j) > easycutoff && logtlxmat(i,j)<=medcutoff
            easymedhard(i,j) = 1;
        else
            easymedhard(i,j) = 2;
        end
    end
end

%Transform matricies to vectors for easier use in Python's keras
hard38 = reshape(hard38',[],1);
fifty = reshape(fifty',[],1);
easymedhard = reshape(easymedhard',[],1);

%Write CSVs
csvwrite('top38.csv',hard38);
csvwrite('easyorhard.csv',fifty);
csvwrite('emh.csv',easymedhard);










