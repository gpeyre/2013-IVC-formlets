function y = compute_iterative_warping(y, m, options, direction)

% compute_iterative_warping - applies several warpings
%
%   y = compute_iterative_warping(y, m, options, direction);
%
%   m is a list of warping parameters, m(:,i) being the ith parameters.
%   set direction=-1 to apply inverse mappings.
%
%   Copyright (c) 2009 Gabriel Peyre

options.null = 0;
display = getoptions(options, 'display', 1);
normalize = getoptions(options, 'normalize', 1);
resample = getoptions(options, 'resample', 1);
if nargin<7
    direction = 0;
end

nwarps = size(m,2);
for i=1:nwarps
    % applies warps and re-sample to avoid loss of resolution
    y = perform_radial_warping(y, m(:,i), options, direction);
    if resample
        y = perform_curve_resampling(y);
    end
    if normalize
        y = y-mean(y);
        y = y/max(abs(y));
    end
    if display
        clf;
        plot_shape(y);
        pause(0);
    end
end