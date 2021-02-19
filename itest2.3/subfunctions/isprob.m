function y = isprob(x)
y=(length(x)==1 && isnumeric(x) &&x<=1 && x>=0);