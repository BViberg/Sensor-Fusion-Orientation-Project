function [x, P] = mu_g(x, P, yacc, Ra, g0)

Q=Qq(x);
[Q0, Q1, Q2, Q3] = dQqdq(x);
Hx = [Q0, Q1, Q2, Q3]*repmat((g0 + f_a),[4 1]);
S=Hx*P*Hx'+Ra;
K=P*Hx'/S;
x=x+K*(yacc-Q*(g0 + f_a));
P=P-K*S*K';
end