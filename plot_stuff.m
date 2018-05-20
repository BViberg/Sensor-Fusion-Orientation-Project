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

acc_cov = cov(acc_data(1,:));
acc_cov(2) = cov(acc_data(2,:));
acc_cov(3) = cov(acc_data(3,:));

gyr_cov = cov(gyr_data(1,:));
gyr_cov(2) = cov(gyr_data(2,:));
gyr_cov(3) = cov(gyr_data(3,:));

mag_cov = cov(mag_data(1,:));
mag_cov(2) = cov(mag_data(2,:));
mag_cov(3) = cov(mag_data(3,:));

% PLOT Z-axis acceleration data histogram
figure(1)
histogram(acc_data(3,:),'Normalization','pdf','Displayname','Z-axis acceleration data')
hold on
x_interval = 9.8:0.001:10;
plot(x_interval,normpdf(x_interval,acc_mean(3),sqrt(acc_cov(3))),'Displayname','Normal distribution fitted to data')
legend('show')

% PLOT X-axis acceleration data histogram
figure(2)
histogram(acc_data(1,:),'Normalization','pdf','Displayname','X-axis acceleration data')
hold on
x_interval = -1:0.001:1;
plot(x_interval,normpdf(x_interval,acc_mean(1),sqrt(acc_cov(1))),'Displayname','Normal distribution fitted to data')
legend('show')

% PLOT x-axis gyro data histogram
figure(3)
histogram(gyr_data(1,:),'Normalization','pdf','Displayname','X-axis gyro data')
hold on
x_interval = -0.01:0.001:0.01;
plot(x_interval,normpdf(x_interval,gyr_mean(1),sqrt(gyr_cov(1))),'Displayname','Normal distribution fitted to data')
legend('show')

% PLOT x-axis mag data histogram
figure(4)
histogram(mag_data(1,:),'Normalization','pdf','Displayname','X-axis magnometer data')
hold on
x_interval = -40:0.001:-33;
plot(x_interval,normpdf(x_interval,mag_mean(1),sqrt(mag_cov(1))),'Displayname','Normal distribution fitted to data')
legend('show')
