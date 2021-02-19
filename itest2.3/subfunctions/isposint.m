function y = isposint(x)
% check if x is positive integer
y = (length(x)==1 && isnumeric(x) && (abs(round(x)-x)) <= eps('double') && x>0);
