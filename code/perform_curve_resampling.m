function x1 = perform_curve_resampling(x,p)

% perform_curve_resampling - resample a curve to arc length parameterization
%
%   x1 = perform_curve_resampling(x,p);
%
%   p is the number of point in the re-sampled curve.
%
%   Copyright (c) 2009 Gabriel Peyre

n = length(x);
if nargin<2
    p = n;
end

% periodicity
x(end+1) = x(1);

% arc length
d = abs(x(1:end-1)-x(2:end));
d = [0 cumsum(d)];
d = d/d(end);

% compute arc length
t = (0:p-1)/p;

x1 = interp1(d,x,t);