%Script to read in csv files of NASATLX scores and put them into a matrix
%TLX scores are in different folders
%Written by: C. Miller - chris.x.miller@u.northwestern.edu
%argallab - Northwestern University - ShirleyRyan AbilityLab - 2018
%Written: 6/9/2018
%Revised: 6/9/2018

clc;
clear all;
close all;

%Matrix to store everything
tlx = zeros(20,26);

%generate list of paths
for i = 1:20
    if i <10
        path = strcat('s0',num2str(i));
    else
        path = strcat('s',num2str(i));
    end 
    
    for j = 1:26
        title = strcat(path,'\',path,'_',num2str(j),'_*.csv');
        name = dir(title);
        proptitle = strcat(path,'\',name.name);
        tab = readtable(proptitle);
        try
            val = str2double(tab{1,35}{1,1});
        catch
            val = tab{1,35};
        end
        tlx(i,j) = val;
    end
end

%Write matrix to csv
csvwrite('TLXMAT.csv',tlx);
