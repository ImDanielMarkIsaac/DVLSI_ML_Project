function [val,err] = grosserror(a,b)
%FIXEDPOINT Summary of this function goes here
%   Detailed explanation goes here
if(size(a) ~= size(b))
    err = 1;
else
    err = 0;
    temp = size(a);
    val = sum(abs(a-b),"all")/(temp(1)*temp(2));
end