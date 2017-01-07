function I = compute_nn(x,y)

% compute_nn - compute nearest neighbors
%
%   I = compute_nn(x,y);
%
%   for each i, compute
%       I(i) = argmin_j |x(i)-y(j)|
%   ie. y(I) are the closest points to x.
%
%   Copyright (c) 2009 Gabriel Peyre

X = repmat( transpose(x(:)), [length(y),1]);
Y = repmat( y(:), [1,length(x)]);

[tmp,I] = min(abs(X-Y), [], 1);