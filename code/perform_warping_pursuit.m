function [x1, m, error] = perform_warping_pursuit(x1, y, options)

% perform_warping_pursuit - warping pursuit algorithm
%
%   [x1, m, error] = perform_warping_pursuit(x1, y, options);
%   
%   m are the parameter for the sequence of warps, m(:,i) is the ith warp.
%   x1 is the warped image after all the warpings.
%
%   options.nwarps controls the number of steps.
%   options.ntrials controls the number of trials per pursuit step.
%   options.initialization can be 'random' (randomized initialization for
%       the descends) or 'tracking' (seed center to the point where the
%       matching error is large).
%
%   Copyright (c) 2009 Gabriel Peyre

options.null = 0;
display = getoptions(options, 'display', 1);
nwarps = getoptions(options, 'nwarps', 20);
ntrials = getoptions(options, 'ntrials', 10);
initialization = getoptions(options, 'initialization', 'random');
warptype = getoptions(options, 'warptype', 'spline');

n = length(x1);

%%
% Parameters for sampling
if strcmp(warptype, 'spline')
    amin = 0; amax = 4; 
    amid = 1;
    smax = 1.5;
    dist_mult = 1.5;
else
    amin = .1; amax = .9; 
    amid = 1/2;
    smax = .5;
    dist_mult = 1.2;
end


%%
% Extract iteratively warps.
m = [];
error = [];
for iwarp=1:nwarps
        
    mtrials = []; 
    etrials = [];
    
    for k=1:ntrials
        % random initialization for the descent
        % x0,a,c,s
        c = 0;
        a = amin + (amax-amin)*rand;
        a = amid;
        s = smax*rand;
        if strcmp(initialization,'random')            
            % random point number 
            l = floor(rand*n)+1;
            % random radius/rangle
            x0 = x1(l) + s*rand*exp(2i*pi*rand);       
            dist = 0;
        else
            [dist,i] = max(abs(x1-y)); dist = dist/2;
            x0 = (x1(i)+y(i))/2;
        end        
        if dist>0
            s = dist_mult*1.5;
        end
        options.m = [x0;a;c;s];
        % the descend
        [err, m_mem] = perform_shape_descent(x1, y, options);
        % applies the warping
        msel = m_mem(:,end);
        x2 = perform_radial_warping(x1, msel, options);
        if isnan(msel(1))
            msel(1) = 0;
        end
        x2 = perform_curve_resampling(x2);
        % compute hausdorff distance        
        etrials(end+1) = compute_hausdorff_distance(x2,y);
        mtrials(:,end+1) = msel;
    end
    
    [e,k] = min(etrials);
    msel = mtrials(:,k);
    
    % applies the warping
    x2 = perform_radial_warping(x1, msel, options);
    x2 = perform_curve_resampling(x2);
    
    % check for decay of the RMS distance
    d = compute_hausdorff_distance(x2,y);    
    if length(error)>0 && d>error(end)
        disp('Problem, not improving');
    else        
        % record the parameters
        m(:,end+1) = msel;
        error(end+1) = d;
        x1 = x2;
    end
    
    %clf;
    %plot(err, '.-');
    
    if display
        clf; hold on;
        plot_shape(x1, 'r');
        plot_shape(y, 'b:');
    end
end

