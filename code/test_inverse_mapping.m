% test for inverse mappings

options.warptype = 'spline';
options.warptype = 'affine';

% 1D

e = [];
alist = linspace(.001,3.99,50);
for a=alist
    t = linspace(0,1,1000);
    y = phi(t,a,0,options);
    t1 = phi(y,a,-1,options);
    e(end+1) = norm(t-t1);
end
plot(alist,e);

% 2D 

nwarps = 10;
x0u = 2*( (rand(nwarps,1)-.5)+ (rand(nwarps,1)-.5)*1i );
su = 1.5*rand(nwarps,1);
if strcmp(options.warptype,'spline')
    au = rand(nwarps,1)*4;
else
    au = .8*rand(nwarps,1)+.1;
end
cu = .05*randn(nwarps,1);
options.normalize = 0
y1 = compute_iterative_warping(x, x0u,au,cu,su, options, +1);
x2 = compute_iterative_warping(y1, x0u(end:-1:1),au(end:-1:1),cu(end:-1:1),su(end:-1:1), options, -1);