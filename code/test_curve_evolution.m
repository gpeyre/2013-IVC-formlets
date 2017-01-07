% perform curve evolution

n = 256;

% random sobolev smooth curve
alpha = 2;
x = abs(-n/2+1:n/2) + 1;
x = ( x.^(-alpha) ).*(randn(1,n) + 1i*randn(1,n)); x(end/2) = 0;
x = ifft(fftshift(x)); x = x/max(abs(x));

clf;
plot(x); axis tight;

niter = 10000;
w = [1 2 1]; w = w/sum(w);
a = [2:n 1]; b = [n 1:n-1];
for i=1:niter
    % smooth
    x = x(a)*w(1) + x*w(2) + x(b)*w(3);
    % re-sample
    x = perform_curve_resampling(x);
    if mod(i,20)==0
        clf; plot(x, '.-'); axis tight; drawnow;
    end
end