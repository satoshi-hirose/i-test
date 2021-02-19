function y = isp(p)
% check if p is in specified format 
%  first row  : possible value of D-Acc
%  second, third... row: Probability mass function (PMF)
% 
% 1) ([Number of PMF]+1) x [Number of possible D-Acc] matrix
% 2) each elements is a number >=0 and <=1
% 3) sum of second row and below should be 1

numerical_error_tolerance = 10^(-9);
y  =(size(p,1)>=3 && all(arrayfun(@isprob,p),'all') && all((sum(p(2:end,:),2)-1)<numerical_error_tolerance));

