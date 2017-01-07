function y = phi(x,a, deriv, options)

% phi - Compute 1D radial warping
%
%   y = phi(x,a, deriv, options);
%
%	a is a shape parameter.
%
%   if a<a_crit, phi is contractant on [0,t_crit], dilation on [t_crit,1], identity on [1,+infty].
%   if a>a_crit, phi is dilation on [0,t_crit],  contractant on [t_crit,1], identity on [1,+infty].
%   
%   deriv=0 : compute phi
%   deriv=1 : computes d/dt(phi)(t)
%   deriv=2 : computes d/da(phi)(t)
%   deriv=-1 : compute phi^{-1}, inverse mapping
%
%	options.warptype can be 'spline' or 'affine'.
%
%   Copyright (c) 2009 Gabriel Peyre

if nargin<3
    deriv=0;
end
options.null = 0;
warptype = getoptions(options, 'warptype', 'spline');

switch warptype
    case 'spline'
        if a<0 || a>4
            disp('Wrong warping parameter');
            a = min(max(a,0),4);
        end
        if deriv==0
            y = ( a*x + 2*(1-a)*x.^2 + (a-1)*x.^3 );
            y = y.*(x<=1) + x.*(x>1);
        elseif deriv==1
            y = a + 4*(1-a)*x + 3*(a-1)*x.^2;
            y = y.*(x<=1) + (x>1);
        elseif deriv==2
            y = ( x - 2*x.^2 + x.^3 ).*(x<=1);
        else
            % inverse mapping, 3rd degree equation
            A = a-1; B = 2*(1-a); C = a; D = -x;
            if a<1
                y = -B./(3.*A) + ((1 - 1i.*sqrt(3)).*(-B.^2 + 3.*A.*C))./(3.*2.^(2./3).*A.*(-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D + sqrt(4.*(-B.^2 + 3.*A.*C).^3 + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D).^2)).^(1/3)) - (1 + 1i.*sqrt(3)).*(-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D + sqrt(4.*(-B.^2 + 3.*A.*C).^3 + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D).^2)).^(1/3)./(6.*2.^(1/3).*A);
            elseif a>1
                % y = -B./(3.*A) + ((1 + 1i.*sqrt(3)).*(-B.^2 + 3.*A.*C))./(3.*2.^(2./3).*A.*(-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D + sqrt(4.*(-B.^2 + 3.*A.*C).^3 + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D).^2)).^(1/3)) - (1 - 1i.*sqrt(3)).*(-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D + sqrt(4.*(-B.^2 + 3.*A.*C).^3 + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D).^2)).^(1/3)./(6.*2.^(1/3).*A);
                y = -B./(3.*A) - (2.^(1/3).*(-B.^2 + 3.*A.*C))./(3.*A.*(-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D + sqrt( 4.*(-B.^2 + 3.*A.*C).^3 + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D).^2)).^(1/3)) + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D + sqrt( 4.*(-B.^2 + 3.*A.*C).^3 + (-2.*B.^3 + 9.*A.*B.*C - 27.*A.^2.*D).^2)).^(1/3)./(3.*2.^(1/3).*A);            
            else
                y = x;
            end
            y = real(y);
            y = y.*(x<=1) + x.*(x>1);
        end
    case 'affine'
        if a<0 || a>1
            disp('Wrong warping parameter');
            a = min(max(a,0),1);
        end
        if deriv==0
            y = (1/a-1)*x.*(x<=a) + ( a/(1-a)*x + (1-2*a)/(1-a) ).*(x>a & x<1) + x.*(x>=1);
        elseif deriv==1
            y = (1/a-1)*(x<=a) + a/(1-a)*(x>a & x<1) + (x>=1);
        elseif deriv==2
            y = ( -1/a^2*x ).*(x<=a) + ( (a*(x-2)+1)/(1-a)^2 + (x-2)/(1-a) ).*(x>a & x<1);
        else
            % inverse mapping  
            y = phi(x,1-a, 0, options);
        end
    otherwise
        error('Unknown');
end