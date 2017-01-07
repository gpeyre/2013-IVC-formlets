function c = dotp(a,b)

% dotp - dot product between 2D vectors represented as complex numbers.
%
%   c = dotp(a,b);
%
%   Copyright (c) 2009 Gabriel Peyre

c = real(a.*conj(b));