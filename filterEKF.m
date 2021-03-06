function [xhat, meas] = filterEKF(calAcc, calGyr, calMag)
% FILTERTEMPLATE  Filter template
%
% This is a template function for how to collect and filter data
% sent from a smartphone live.  Calibration data for the
% accelerometer, gyroscope and magnetometer assumed available as
% structs with fields m (mean) and R (variance).
%
% The function returns xhat as an array of structs comprising t
% (timestamp), x (state), and P (state covariance) for each
% timestamp, and meas an array of structs comprising t (timestamp),
% acc (accelerometer measurements), gyr (gyroscope measurements),
% mag (magnetometer measurements), and orint (orientation quaternions
% from the phone).  Measurements not availabe are marked with NaNs.
%
% As you implement your own orientation estimate, it will be
% visualized in a simple illustration.  If the orientation estimate
% is checked in the Sensor Fusion app, it will be displayed in a
% separate view.
%
% Note that it is not necessary to provide inputs (calAcc, calGyr, calMag).

%% Setup necessary infrastructure
import('com.liu.sensordata.*');  % Used to receive data.

%% Filter settings
t0 = [];  % Initial time (initialize on first data received)
nx = 4;   % Assuming that you use q as state variable.
% Add your filter settings here.

% Current filter state.
x = [1; 0; 0 ;0];
P = eye(nx, nx);

% Saved filter states.
xhat = struct('t', zeros(1, 0),...
    'x', zeros(nx, 0),...
    'P', zeros(nx, nx, 0));

meas = struct('t', zeros(1, 0),...
    'acc', zeros(3, 0),...
    'gyr', zeros(3, 0),...
    'mag', zeros(3, 0),...
    'orient', zeros(4, 0));

Rw = 1.0e-06 * [0.6553    0.0425    0.0183;
    0.0425    0.7682   -0.0305;
    0.0183   -0.0305    0.6355];

Ra = 1.0e-03 * [0.5094   -0.0211   -0.0081;
    -0.0211    0.1245   -0.0174;
    -0.0081   -0.0174    0.3352];
T = 0.01;

g0 = [0.0770;
    -0.0392;
    9.9097];

mx = 11.5906; my = -0.5585; mz = -48.8893; % [T]
m0 = 1e-4*[0;
    0.2041;
   -0.5931];




  Rm =1.0e-12*[0.4063    0.0346   -0.0043;
              0.0346    0.7238    0.0066;
               -0.0043    0.0066    0.5532];
L = norm(m0);


%   Rm =  1.0e+11 * [4.5313   -0.0111    0.3947;
%         -0.0111    7.1439    0.4856;
%          0.3947    0.4856    6.7148];
%   m0 = 1.0e+07 * [0 0.4685 -4.4832]';
%   L = norm(m0);
try
    %% Create data link
    server = StreamSensorDataReader(3400);
    % Makes sure to resources are returned.
    sentinel = onCleanup(@() server.stop());
    
    server.start();  % Start data reception.
    
    % Used for visualization.
    figure(1);
    subplot(1, 2, 1);
    ownView = OrientationView('Own filter', gca);  % Used for visualization.
    googleView = [];
    counter = 0;  % Used to throttle the displayed frame rate.
    
    %% Filter loop
    while server.status()  % Repeat while data is available
        % Get the next measurement set, assume all measurements
        % within the next 5 ms are concurrent (suitable for sampling
        % in 100Hz).
        data = server.getNext(5);
        
        if isnan(data(1))  % No new data received
            continue;        % Skips the rest of the look
        end
        t = data(1)/1000;  % Extract current time
        
        if isempty(t0)  % Initialize t0
            t0 = t;
        end
        
        gyr = data(1, 5:7)';
        %gyr = [0;0;0];
        if ~any(isnan(gyr))  % Gyro measurements are available.
            [x, P] = tu_qw(x, P, gyr, T, Rw);
            [x, P] = mu_normalizeQ(x, P);
        elseif sum(~any(isnan(meas.gyr)))>0
                    gyrTempIndex = find(~any(isnan(meas.gyr)),1,'last');
                    gyrTemp = meas.gyr(:,gyrTempIndex);
                    dT=t - t0-meas.t(:,gyrTempIndex);
            
                    RwIncMat = (dT*17.4261).^2*eye(3);
                    [x, P] = tu_qw(x, P, gyrTemp, T, Rw+RwIncMat);
                    [x, P] = mu_normalizeQ(x, P);
        else
            [x, P] = tu_qw(x, P, [0;0;0], T, 10000*Rw);
            [x, P] = mu_normalizeQ(x, P);
        end
        acc = data(1, 2:4)';
        if ~any(isnan(acc))  % Acc measurements are available.
            if norm(acc)>10
                [x, P] = mu_g(x, P, Ra, g0);
                [x, P] = mu_normalizeQ(x, P);
                ownView.setAccDist(1);
            else
                [x, P] = mu_g(x, P, Ra, g0,acc);
                [x, P] = mu_normalizeQ(x, P);
                ownView.setAccDist(0);
            end
        end
        
        
        
        mag = 1e-6*data(1, 8:10)';
        if ~any(isnan(mag))  % Mag measurements are available.
            alpha = 0.01;
            L = (1-alpha)*L+alpha*norm(mag);
            if abs(L-norm(mag))>0.1*L
%                 [x, P] = mu_m(x, P, m0,Rm);
%                 [x, P] = mu_normalizeQ(x, P);
                ownView.setMagDist(1);
            else
                [x, P] = mu_m(x, P, m0,Rm,mag);
                [x, P] = mu_normalizeQ(x, P);
                ownView.setMagDist(0);
            end
        end
        
        orientation = data(1, 18:21)';  % Google's orientation estimate.
        
        % Visualize result
        if rem(counter, 10) == 0

            setOrientation(ownView, x(1:4));
            title(ownView, 'OWN', 'FontSize', 16);
            if ~any(isnan(orientation))
                if isempty(googleView)
                    subplot(1, 2, 2);
                    % Used for visualization.
                    googleView = OrientationView('Google filter', gca);
                end
                setOrientation(googleView, orientation);
                title(googleView, 'GOOGLE', 'FontSize', 16);
            end
        end
        counter = counter + 1;
        
        % Save estimates
        xhat.x(:, end+1) = x;
        xhat.P(:, :, end+1) = P;
        xhat.t(end+1) = t - t0;
        
        meas.t(end+1) = t - t0;
        meas.acc(:, end+1) = acc;
        meas.gyr(:, end+1) = gyr;
        meas.mag(:, end+1) = mag;
        meas.orient(:, end+1) = orientation;
        
        
        
        
    end
catch e
    fprintf(['Unsuccessful connecting to client!\n' ...
        'Make sure to start streaming from the phone *after*'...
        'running this function!']);
end
assignin('base','measMag180524',meas);
end
