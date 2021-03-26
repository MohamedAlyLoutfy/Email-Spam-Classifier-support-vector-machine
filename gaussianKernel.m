function sim = gaussianKernel(x1, x2, sigma)

x1 = x1(:); x2 = x2(:);


sim = 0;

dif=x1-x2;
sq=dif.^2;
sm=sum(sq);
ans=(-1*sm)/(2*(sigma^2));
sim=exp(ans);






    
end
