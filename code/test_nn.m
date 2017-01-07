% test for nn computing

path(path,'toolbox/');
path(path,'data/');

n = 128*2;

x = load_shape('chicken',n);
y = load_shape('camel',n);

I = compute_nn(x,y);

clf;
plot([x' y(I)']','.-');
axis equal;