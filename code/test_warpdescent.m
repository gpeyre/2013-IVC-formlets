% test for gradient descent of the parameters of the transform 

path(path, 'toolbox/');

n = 256;
t = (0:n-1)/n;

x = cos(2*pi*t) + 1i*sin(2*pi*t);

x0 = 1+1i; x0 = x0/abs(x0)*.6;
s = .8;
a = .1;
c = 0;
y = perform_radial_warping(x, x0,a,c,s);

clf; hold on;
plot(x, 'k'); plot(y, 'r');
plot(x0, 'xb'); plot(x0 + s*x, 'b:');
axis tight;


% gradient step size
options.tau_x0 = 1;
options.tau_s = 1;
options.tau_a = 1;
options.tau_c = 1;
options.niter = 500;

% initialization for the descent
options.x0 = x0 + .1*(randn+1i*randn);
options.s = s + .1*randn;
options.c = c + .1*(randn+1i*randn);
options.a = rand*.4;

[err, x0_mem, c_mem, s_mem, a_mem] = perform_shape_descent(x, y, options);


clf;
plot(err, '.-');
axis tight;