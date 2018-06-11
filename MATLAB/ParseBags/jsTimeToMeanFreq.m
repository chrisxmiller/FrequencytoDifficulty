%jsTimeToMeanFreq
%Reads: a time vector (0 to end) and the mean window (int) 
%Returns: type double vector of the averaged frequency across the raw time
%measurements. vector length is one less than the input time vector
%
%Written by: C. Miller - chris.x.miller@u.northwestern.edu
%argallab - Northwestern University - ShirleyRyan AbilityLab - 2018
%Written: 5/12/2018
%Revised: 5/12/2018


function freq = jsTimeToMeanFreq(time,wind)
%Constants - none

%Convert from raw time to time between data values
new = zeros(1,length(time));
for i = 2:length(time)
    new(i) = time(i) - time(i-1);
end
%Convert time to freq
f = 1./new;
%Average and return
freq = movmean(f,wind);
end
