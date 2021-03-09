function y = isp(p,num_p)
% check if p is in specified format
%  first row  : possible value of D-Acc
%  second, third... row: Probability mass function (PMF)
% 
% 1) ([Number of PMF]+1) x [Number of possible D-Acc] matrix
%  * if specified, number of PMF should be num_p
% 2) each elements is a number >=0 and <=1
% 3) sum of second row and below should be 1

numerical_error_tolerance = 10^(-9);
if nargin ==2 && (size(p,1)~=(num_p+1)); y=false; return; end
y  = isnumeric(p) && all(p(:)<=1) && all(p(:)>=0) && all((sum(p(2:end,:),2)-1)<numerical_error_tolerance);
