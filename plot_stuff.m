
% meas.x(1,:);
% meas.t
% plot(meas.t,meas.x(1,:))
clc
clf

acc_data = meas.acc(:,~any(isnan(meas.acc), 1));
histogram(acc_data(3,:),'Normalization','pdf')
hold on
mean_acc_z = mean(acc_data(3,:));
cov_acc_z = cov(acc_data(3,:));

x_interval = 9.8:0.001:9.95;
plot(x_interval,normpdf(x_interval,mean_acc_z,sqrt(cov_acc_z)))

