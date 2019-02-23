function entr = Entropy( image )
%calculates entropy of an image matrix

%Step 1: Create normalized histogram of the image
p=ProbabilityMass(image);

%Step 2: Find all non-zero elements for calculation of log
i=find(p);

%Step 3: Calculate the entropy
entr = -sum(p(i).*log2(p(i)));

end

