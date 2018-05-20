function [MEAN,COV,T,meas] = VizualizeNoise(meas)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

type={'acc','gyr','mag'};
for i=1:length(type)
    % Clean meas from timeinstances with NaN
    meas.(type{i}) = meas.(type{i})(:,~any(isnan(meas.(type{i}))));
    % Create corresponding timevectors
    T.(type{i}) = meas.t(~any(isnan(meas.(type{i}))));
    % Calculate mean
    MEAN.(type{i}) = mean(meas.(type{i}),2);
    % Calculate covariance
    COV.(type{i}) = cov(meas.(type{i})');
end

