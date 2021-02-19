function y = ispmf(x)
% check if x satisfies requirement for probability mass function
% 1) x is a vector with values between 0 and 1
% 2) sum of all array is 1

numerical_error_tolerance = 10^(-9); 
y= (isvector(x) && all(arrayfun(@isprob,x)) && (abs(sum(x)-1)<numerical_error_tolerance));
