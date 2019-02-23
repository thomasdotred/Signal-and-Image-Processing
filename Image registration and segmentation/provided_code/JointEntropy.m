function je = JointEntropy( im1,im2)

% Calculate 2D probability disptribution
p=ProbabilityDistribution2D(im1,im2);

%Find all non-zero elements for calculation of log
i=find(p);

%Calculate the entropy
je = -sum(p(i).*log2(p(i)));
end

