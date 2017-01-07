function y = perform_radial_warping(x, m, options, direction)

% perform_radial_warping - compute the radial warping
% 
%   y = perform_radial_warping(x, m, direction);
%
%   m = [x0,a,c,s] where
%
%   x0 is center
%   c is translation
%   s is scale
%   a is shape (alpha=1 implies identity)
%   set direction=-1 to apply inverse mappings.
%
%   options.warptype is the non-linearity type.
%
%   Copyright (c) 2009 Gabriel Peyre

x0 = m(1);
a = m(2);
c = m(3);
s = m(4);

if nargin<4
    direction = 0;
end

options.null = 0;
if direction>=0
    r = max(abs(x-x0), 1e-9);
    y = c+x0+s*(x-x0)./r.*phi(r/s, a, 0, options);
else
    r = max(abs(x-x0-c), 1e-9);
    y = x0+s*(x-x0-c)./r.*phi(r/s, a, -1, options);
end