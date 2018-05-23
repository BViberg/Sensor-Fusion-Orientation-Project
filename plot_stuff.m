clc
clf
clear all
close all
%load('meas_flatGround');
%load('meas_magnometer.mat');
load('measGyro.mat');
meas = measGyro;

% meas.t=meas.t(:,100:1100);
% meas.acc=meas.acc(:,100:1100);
% meas.gyr=meas.gyr(:,100:1100);
% meas.mag=meas.mag(:,100:1100);

acc_t = meas.t(:,~any(isnan(meas.acc)));
gyr_t = meas.t(:,~any(isnan(meas.gyr)));
mag_t = meas.t(:,~any(isnan(meas.mag)));

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

% PLOT acceleration data histogram
figure(1)
axis_vec=['X','Y','Z'];
for i = 1:3
subplot(3,1,i)
histogram(acc_data(i,:),'Normalization','pdf','Displayname',[axis_vec(i),'-axis acceleration data'])
hold on
x_interval = acc_mean(i)-3*sqrt(acc_cov(i)):0.0001:acc_mean(i)+3*sqrt(acc_cov(i));
subplot(3,1,i)
plot(x_interval,normpdf(x_interval,acc_mean(i),sqrt(acc_cov(i))),'Displayname','Normal distribution fitted to data')
legend('show')
xlabel('Acceleration (m/s^2)')
ylabel('Sample propability')
end


% PLOT gyro data histogram
figure(2)
for i = 1:3
subplot(3,1,i)
histogram(gyr_data(i,:),'Normalization','pdf','Displayname',[axis_vec(i),'-axis gyro data'])
hold on
x_interval = gyr_mean(i)-3*sqrt(gyr_cov(i)):0.0001:gyr_mean(i)+3*sqrt(gyr_cov(i));
subplot(3,1,i)
plot(x_interval,normpdf(x_interval,gyr_mean(i),sqrt(gyr_cov(i))),'Displayname','Normal distribution fitted to data')
legend('show')
xlabel('Angular velocity (rad/s)')
ylabel('Sample propability')
end


% PLOT mag data histogram
figure(3)
for i = 1:3
subplot(3,1,i)
histogram(mag_data(i,:),'Normalization','pdf','Displayname',[axis_vec(i),'-axis magnometer data'])
hold on
x_interval = mag_mean(i)-3*sqrt(mag_cov(i)):0.0001:mag_mean(i)+3*sqrt(mag_cov(i));
subplot(3,1,i)
plot(x_interval,normpdf(x_interval,mag_mean(i),sqrt(mag_cov(i))),'Displayname','Normal distribution fitted to data')
legend('show')
xlabel('Magnetic flow density (\mu T)')
ylabel('Sample propability')
end

%PLOT OVER TIME
figure(4)
subplot(3,1,1)
plot(acc_t-acc_t(1),acc_data)
axis([-inf inf -1 11])
title('Accelerometer data')
legend('X-axis','Y-axis','Z-axis')
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
subplot(3,1,2)
plot(gyr_t-gyr_t(1),gyr_data)
axis([-inf inf -inf inf])
title('Gyro data')
legend('X-axis','Y-axis','Z-axis')
xlabel('Time (s)')
ylabel('Angular velocity (rad/s)')
subplot(3,1,3)
plot(mag_t-mag_t(1),mag_data)
axis([-inf inf -inf inf])
title('Magnometer data')
legend('X-axis','Y-axis','Z-axis')
xlabel('Time (s)')
ylabel('Magnetic flow density (\mu T)')


