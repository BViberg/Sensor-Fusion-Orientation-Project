clc
clf
clear all
close all
load('meas_flatGround.mat');

acc_data = meas.acc(:,~any(isnan(meas.acc)));
gyr_data = meas.gyr(:,~any(isnan(meas.gyr)));
mag_data = meas.mag(:,~any(isnan(meas.mag)));

acc_mean = mean(acc_data,2);
gyr_mean = mean(gyr_data,2);
mag_mean = mean(mag_data,2);

all_mean = 

acc_cov = cov(acc_data(1,:));
acc_cov(2) = cov(acc_data(2,:));
acc_cov(3) = cov(acc_data(3,:));

gyr_cov = cov(gyr_data(1,:));
gyr_cov(2) = cov(gyr_data(2,:));
gyr_cov(3) = cov(gyr_data(3,:));

mag_cov = cov(mag_data(1,:));
mag_cov(2) = cov(mag_data(2,:));
mag_cov(3) = cov(mag_data(3,:));

% PLOT acceleration data histogram
figure(1)
axis_vec={'X','Y','Z'};
for i = 1:3
histogram(acc_data(i,:),'Normalization','pdf','Displayname',[axis_vec(i),'Z-axis acceleration data'])
hold on
x_interval = 9.8:0.001:10;
plot(x_interval,normpdf(x_interval,acc_mean(i),sqrt(acc_cov(i))),'Displayname','Normal distribution fitted to data')
legend('show')
end

% PLOTgyro data histogram
figure(3)
histogram(gyr_data(1,:),'Normalization','pdf','Displayname','X-axis gyro data')
hold on
x_interval = -0.01:0.001:0.01;
plot(x_interval,normpdf(x_interval,gyr_mean(1),sqrt(gyr_cov(1))),'Displayname','Normal distribution fitted to data')
legend('show')

% PLOT mag data histogram
figure(4)
histogram(mag_data(1,:),'Normalization','pdf','Displayname','X-axis magnometer data')
hold on
x_interval = -40:0.001:-33;
plot(x_interval,normpdf(x_interval,mag_mean(1),sqrt(mag_cov(1))),'Displayname','Normal distribution fitted to data')
legend('show')



