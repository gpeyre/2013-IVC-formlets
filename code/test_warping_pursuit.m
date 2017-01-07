% test for iterative decomposition of a warped shape

path(path, 'toolbox/');
path(path, 'data/');

%%
% Kind of warpings.

options.warptype = 'affine';
options.warptype = 'spline';


%%
% Initial shape.

n = 256;
x = load_shape('circle',n);

%%
% Target shape.

name = 'chicken';
y = load_shape(name,n);


%%
% Apply warping pursuit.

% gradient step size
options.tau = [1;1;1;1];
options.niter = 400;
% parameters of the warping pursuit
options.nwarps = 50;
options.ntrials = 1;
options.initialization = 'tracking';
options.initialization = 'random';
% number of steps between update of the matchings
options.nupdate = 40;

[x1, m, error] = perform_warping_pursuit(x, y, options);

%%
% Displays.

clf;
plot(error, '.-'); axis tight;

clf; hold on;
plot_shape(x1, 'r');
plot_shape(y, 'b:');

%%
% Display the scale, should somehow decay.

clf;
plot(m(4,:), '.-');
axis tight;

return;

%%
% Map back the center points and the domain

[D,Dcenter] = perform_back_mapping(x0,m,options);

clf;
hold on;
plot_shape(D, 'r:');
plot_shape(x, 'b');
h = plot(Dcenter, 'k.'); set(h, 'MarkerSize', 10);
axis tight; axis equal;
