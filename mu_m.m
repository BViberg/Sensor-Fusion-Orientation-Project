function [x, P] = mu_m(x, P, mag, m0,Rm)
f_m = [0;0;0];
Q=Qq(x);
[Q0, Q1, Q2, Q3] = dQqdq(x);
Hx = [Q0*(m0 + f_m), Q1*(m0 + f_m), Q2*(m0 + f_m), Q3*(m0 + f_m)];
S=Hx*P*Hx'+Rm;
K=P*Hx'/S;
x=x+K*(mag-Q*(m0 + f_m));
P=P-K*S*K';
end