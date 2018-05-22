function [x, P] = tu_qw(x, P, omega, T, Rw)
%UNTITLED6 Summary of this function goes here
%   This funtion assumes the statevector x to have the quaternions as the
%   four first elements
n=size(x,1);
F=eye(n)+Somega(omega)*T*0.5;
G=Sq(x)*T*0.5;


x=F*x;
P = F*P*F'+G*Rw*G';
end

