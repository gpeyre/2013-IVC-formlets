function [x,I] = perform_parameterization_shift(x,y)

% perform_parameterization_shift - 
%
%   [x,I] = perform_parameterization_shift(x,y);
%
%   Computes a shift s to miminize norm(x(I)-y)
%   where I=mod(s+(0:n-1),n)+1);
%   
%   Copyright (c) 2009 Gabriel Peyre

n = length(x);
% set of circular shifts
[X,Y] = meshgrid(1:n,1:n);
I = mod(X+Y-2,n)+1;

% distance
d = sum( abs(x(I)-repmat(y(:), [1 n])) );
[tmp,i] = min(d);
I = I(:,i);
x = x(I);