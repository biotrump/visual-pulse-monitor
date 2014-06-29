
% Demonstration code for the Whitening Transform 

s=5000;  % number of uniform rvs uses in the sum
n=10000; % number of samples


% Make normal rv as the sum of uniform rvs
uniform=rand(n,s);
uniform=uniform-0.5;
uniform=uniform/sqrt(s/12);
normal=sum(uniform,2);

% show that the new rv looks normal
bins=25;
h=hist(normal,bins);
figure(1); bar(h)

% choose the first feature to be normal
x_1=normal;

% repeat this again for the second feature
uniform=rand(n,s);
uniform=uniform-0.5;
uniform=uniform/sqrt(s/12);
normal=sum(uniform,2);

% however, take the second feature as combo of the first plus new normal rv
x_2= 1.5*x_1+normal;

% plot the samples in the 2D feature space
figure(2); scatter(x_1,x_2); axis equal;

% compute the mean for x
x=[x_1,x_2];
mu=sum(x)/n;

% compute the covariance for x
COV=zeros(2,2);
for i=1:n
   COV=COV+(x(i,:)-mu)'*(x(i,:)-mu);
end
COV=COV/(n-1)

% decompose COV using SVD
[PHI,LAMBDA,PHIT]=svd(COV);

% computer the whitening transform
Aw=PHI*LAMBDA^(-0.5)*PHIT;

% apply is to x to get a new feature space
y=(Aw*x')';

% compute the mean for y
muy=sum(y)/n;

% compute the COV for y
COVy=zeros(2,2);
for i=1:n
   COVy=COVy+(y(i,:)-muy)'*(y(i,:)-muy);
end
COVy=COVy/(n-1)



