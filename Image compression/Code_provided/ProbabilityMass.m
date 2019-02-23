function p = ProbabilityMass(image)
% Creates normalized histogram of an image

%Step 1: Create the historgram 
p = histc(image(:),min(image(:)):max(image(:)));

%Step 2: Normalize histogram by number of samples 
%to calculate probabilities
p=p/numel(image);

end

