function p = ProbabilityDistribution2D( im1,im2 )

p=zeros(256);

% number of pixels
N = numel(im1);

% for pair of intensity values of ith pixel increase value in histogram 9
% by 1
for i=1:N
    p(im1(i)+1,im2(i)+1)=p(im1(i)+1,im2(i)+1)+1;
end

% normalize histogram to obtain probability distribution
p=p/N;

end

