clf
clear
clc
mag1 = 1e-6*[0 -18 -25]';
m0 =1e-6* [0;sqrt((-3.5608)^2 + (-3.0440)^2);-44.8322]; 
  
Rm = 1e-12*   [0.4531   -0.0011    0.0395;
                -0.0011    0.7144    0.0486;
                0.0395    0.0486    0.6715];
            Rw = 1.0e-03 * [0.6553    0.0425    0.0183;
                  0.0425    0.7682   -0.0305;
                  0.0183   -0.0305    0.6355];
x = [1; 0; 0 ;0];
P = eye(4, 4);  
N = 100;
T=0.01;
for i = 1:N
   
    gyr=[0 0 0]';
      
    [x, P] = tu_qw(x, P, gyr, T, Rw);  
    [x, P] = mu_normalizeQ(x, P);      
    
      
    [x, P] = mu_m(x, P, m0,Rm,mag1); 
    euler(:,i) = q2euler(x);
    
end

plot(0:N,[q2euler([1;0;0;0]), euler]*180/pi)

rotm1 = eul2rotm(euler(:,N)');

hold on
mag2 = 1e-6*[0 25 -27]';
for i = N:N+10000
    gyr=[0 0 0]';
    [x, P] = tu_qw(x, P, gyr, T, Rw);  
    [x, P] = mu_normalizeQ(x, P);  
    
    [x, P] = mu_m(x, P, m0,Rm,mag2); 
    euler(:,i) = q2euler(x);
    
end
plot(1:N+10000,euler*180/pi)

rotm2 = eul2rotm(euler(:,N+10000)');
