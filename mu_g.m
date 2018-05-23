function [x, P] = mu_g(x, P, Ra, g0,yacc)
if nargin<5
    f_a = [0;0;0];
    [Q0, Q1, Q2, Q3] = dQqdq(x);
    Hx = [Q0*(g0 + f_a), Q1*(g0 + f_a), Q2*(g0 + f_a), Q3*(g0 + f_a)];
    S=Hx*P*Hx'+Ra;
    K=P*Hx'/S;
    P=P-K*S*K';
        
else
    f_a = [0;0;0];
    Q=Qq(x);
    [Q0, Q1, Q2, Q3] = dQqdq(x);
    Hx = [Q0*(g0 + f_a), Q1*(g0 + f_a), Q2*(g0 + f_a), Q3*(g0 + f_a)];
    S=Hx*P*Hx'+Ra;
    K=P*Hx'/S;
    x=x+K*(yacc-Q*(g0 + f_a));
    P=P-K*S*K';
end