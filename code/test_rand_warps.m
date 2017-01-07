%%
% Apply a series of randomized warping.

nwarps = 50;
x0 = 2*( (rand(1,nwarps)-.5)+ (rand(1,nwarps)-.5)*1i );
if strcmp(options.warptype, 'spline')
    s = 1.5*rand(1,nwarps);
    a = rand(1,nwarps)*4;
else
    s = .5*rand(1,nwarps);
    amin = .1;
    a = amin + (1-2*amin)*rand(1,nwarps);
end
c = zeros(1,nwarps);
y = compute_iterative_warping(x, [x0;a;c;s], options);
