function [Ut,rho,eta] = alpha_FAPI(X,beta,alpha,U_tr,lp)

% X:  (n x N) data matrix collecting the N observation (n x 1) vectors
% beta, 0 < beta<= 1: forgetting factor
% alpha: divergence
% U_tr is the set of true subspaces with time
if nargin <= 4
    lp = 1;
else
end


% Initialization
[n, N] = size(X);
r      = min(size(U_tr{1,1}));
W      = eye(n,r);
Z      = eye(r);
c      = (1-alpha)/2;


rho = zeros(1,N);  
eta = zeros(1,N); 

for k = 1:N
    y  = W'*X(:,k);
    h  = Z*y;
    e  = X(:,k) - W*y;
    w  = exp(-c*norm(e)^lp);
    g  = h*w/(beta + y'*h*w);
    gn = norm(g)^2;

    eps = norm(r)^2;  %(norm(X(:,k),'fro'))^2 - (norm(y,'fro'))^2;
    tau = eps/(1+ eps*gn + sqrt(1 + eps*gn) );
    mu  = 1 - tau*gn;
    yp  = mu*y + tau*g;
    hp  = Z'* yp;
    r   = (tau/mu)*(Z*g - (hp'*g)*g);
    Z   = (1/beta)* (Z - g*hp' + r*g');
    ep  = mu* X(:,k) - W*yp;
    W   = W + ep*g';
    
    %% Performance Evaluation
    V       = orth(U_tr{1,k}); % true subspace at time t
    rho(k)  = abs(trace(W'*(eye(n)-V*V')*W)/trace(W'*(V*V')*W));
    eta(k)  = sin(subspace(W,V));
    Ut{1,k} = W;
end

    
