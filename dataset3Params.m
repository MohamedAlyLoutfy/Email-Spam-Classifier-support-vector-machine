function [C, sigma] = dataset3Params(X, y, Xval, yval)

C = 1;
sigma = 0.3;


error1=zeros(64*1);
a=[0.01,0.03,0.1,0.3,1,3,10,30];
k=1;
min=10000000;
for i=1:8
  C=a(i);
  for j=1:8
    sigma=a(j);
    model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma));
    predict=svmPredict(model,Xval);
    error1(k)= mean(double(predict ~= yval));
    
    if error1(k)<min
      min=error1(k);
      v1=C;
      v2=sigma;
    endif
    k++;
    
  endfor
endfor
C=v1;
sigma=v2;







% =========================================================================

end
