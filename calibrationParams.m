function [acc,gyr,mag] = calibrationParams(meas)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[MEAN,COV,~, ~] = VizualizeNoise(meas);
acc.g0=MEAN.acc;
acc.P=COV.acc;

gyr.P = COV.gyr;

mag.P=COV.mag;
magMean=MEAN.mag;
mag.m0 =[0;sqrt(magMean(1)^2+magMean(2)^2);magMean(3)];



end