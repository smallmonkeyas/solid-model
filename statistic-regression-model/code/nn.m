% [x,t] = simplefit_dataset; 
% plot(x,t) 
% net = fitnet(10);
% net = train(net,x,t); 
% view(net)
% y = net(x); plot(net,x,t);


[x,t] = simplecluster_dataset; 
plot(x(1,:),x(2,:),'+') 
net = selforgmap([8 8]); 
net = train(net,x,t); 
view(net) 
y = net(x); 
classes = vec2ind(y);