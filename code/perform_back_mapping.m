function [D,Dcenter] = perform_back_mapping(x0,a,c,s,options)


K = length(x0);
x0mapped = [];
options.normalize = 0;
options.resample = 0;
options.display = 0;

%% centers
for i=2:K
    Dcenter(i) = compute_iterative_warping(x0(i), x0(i-1:-1:1),a(i-1:-1:1),c(i-1:-1:1),s(i-1:-1:1), options, -1);
end
Dcenter(1) = x0(1);

%% domains
options.resample = 1;
n = 128;
t = (0:n-1)/n;
w = cos(2*pi*t) + 1i*sin(2*pi*t);
for i=2:K
    D{i} = compute_iterative_warping(x0(i)+s(i)*w, x0(i-1:-1:1),a(i-1:-1:1),c(i-1:-1:1),s(i-1:-1:1), options, -1);
end
D{1} = x0(1)+s(1)*w;