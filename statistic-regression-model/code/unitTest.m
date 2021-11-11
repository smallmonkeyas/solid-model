[x1,x2,x3] = deal(1342.6,23.08,3833.94);
for ii = 1:numel(b_estimate)
    eval(['b' num2str(ii) '= ' num2str(b_estimate(ii)) ';'])
end

y = b1.*x1.^3+b2.*x1.^2+b3.*x1.^1+b4.*x1.^0+b5.*x2.^3+b6.*x2.^2+b7.*x2.^1+b8.*x2.^0+b9.*x3.^3+b10.*x3.^2+b11.*x3.^1+b12.*x3.^0;
disp(['y = ' num2str(y)])