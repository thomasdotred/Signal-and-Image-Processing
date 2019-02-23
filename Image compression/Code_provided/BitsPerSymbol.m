function bpp = BitsPerSymbol( code, p )
% Calculates how many bits per symbol will be used for given Huffman coding.
% code - Huffman code
% p - normalized histogram

%Step 0: make sure the codes are the same dimension
dimc = size(code);
dimp = size(p);
if dimc(1)~= dimp(1)
    error('code and p must be the same dimensions.');
end

%Step 1: Create structure code_length
code_length = zeros(length(code),1);
for i=1:length(code)
 code_length(i)=length(code{i});
end
bpp = sum(code_length.*p);
end

