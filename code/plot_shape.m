function hh = plot_shape(y, s)

% plot_shape - display a 2D shape
%
%    hh = plot_shape(y, s);
%
%   Copyright (c) 2009 Gabriel Peyre

if iscell(y)
    for i=1:length(y)
        hh{i} = plot_shape(y{i}, s);
    end
    return;
end

y = [y(:); y(1)];
if nargin<2
    s = 'b';
end
hh = plot(y, s); 
set(hh, 'LineWidth', 1.5);
axis([-1 1 -1 1]*1.1); 
axis equal;
axis off;
drawnow;