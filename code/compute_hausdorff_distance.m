function d = compute_hausdorff_distance(x,y)

% compute_hausdorff_distance - compute RMS Hausdorff distance
%
%   d = compute_hausdorff_distance(x,y);
%
%   Copyright (c) 2009 Gabriel Peyre

Iy = compute_nn(x,y);
Ix = compute_nn(y,x);
d = norm(x-y(Iy))^2 + norm(x(Ix)-y)^2;