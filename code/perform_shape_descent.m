function [err, m_mem] = perform_shape_descent(x, y, options)

% perform_shape_descent - compute best warping parameters
%
%   [err,m_mem] = perform_shape_descent(x, y, options);
%
%   Find parameters m=m_mem(:,end) 
%   so that y is as close as possible to
%       y1 = perform_radial_warping(x,m);
%
%   Copyright (c) 2009 Gabriel Peyre

% initial point
m = getoptions(options, 'm', [0 .1 0 1]);
% step size
tau = getoptions(options, 'tau', [2 .1 .5 .5]);
verb = getoptions(options, 'verb', 1);
niter = getoptions(options, 'niter', 200);
nupdate = getoptions(options, 'nupdate', 1);

n = length(x);
err = [];
m_mem = [];

for i=1:niter
    
    if mod(i-1, nupdate)==0
        % update the sampling of the curve to match
        xw = perform_radial_warping(x, m, options);
        xw = perform_curve_resampling(xw);
        x1 = perform_radial_warping(xw, m, options, -1);
        % update the matchings
        Iy = compute_nn(xw,y);
        Ix = compute_nn(y,xw);
        % record error
        err(end+1) = norm(xw - y(Iy))^2 + norm(xw(Ix) - y)^2;
    end
    
    % gradient
    G1 = compute_gradient(x1,y(Iy), m, options);
    G2 = compute_gradient(x1(Ix),y, m, options);
    % descend
    m = m - tau.*(G1+G2)/2;
    % projection on constraints
    m(2) = max(m(2),0);
    % bookeeping
    m_mem(:,end+1) = m;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function G = compute_gradient(x,y, m, options)

% compute gradient of 
%   E(m) = norm(psi_m(x)-y)^2
% with respect to m.

x0 = m(1); a = m(2);
c = m(3); s = m(4);

xw = perform_radial_warping(x, m, options);

% compute gradients
z = (x0 - x) ./ abs(x-x0);
Delta  = s * phi( abs(x-x0)/s, a, 0, options );
DeltaD = phi( abs(x-x0)/s, a, 1, options );
delta = xw-y;

% multi gradient
ai = 1-Delta./abs(x-x0);
Grad_x0 = ai.*delta + dotp(z,delta).*(Delta./abs(x-x0) - DeltaD).*z;
Grad_c = delta;
Grad_s = dotp(-z,delta).*( Delta - DeltaD.*abs(x-x0) )/s;
Grad_a = s * dotp(delta,-z) .* phi( abs(x-x0)/s, a, 2, options );
% flatten gradient
G = [mean(Grad_x0);mean(Grad_a);mean(Grad_c);mean(Grad_s)];