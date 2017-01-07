function c = load_shape(M,n)

% load_shape - load curve from a binary image
%
%   c = load_shape(M,n);
%
%   M can be a 2D matrix or a filename.
%   n is the length of the curve.
%
%   Copyrighr (c) 2009 Gabriel Peyre

if isstr(M)
    if strcmp(M, 'circle')
        t = (0:n-1)/n;
        c = cos(2*pi*t) + 1i*sin(2*pi*t);
        return;      
    end    
    M = load_image(M);
end

M = rescale(M);

c = contourc(M,[.5 .5]);
p = c(2);
c = c(:,2:p+1);
c = c(1,:)+1i*c(2,:);
[tmp,I] = unique(c); I = sort(I); c = c(I);
c = perform_curve_resampling(c,n);

c = c-mean(c); c = c/max(c);