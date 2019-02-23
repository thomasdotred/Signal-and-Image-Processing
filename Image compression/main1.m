% Toby Thomas, 2017
%% Question  1
% a)
pic = imread('picture.png');
imshow(pic);
pic_rle = RLE(pic);
eff1 = length(pic_rle)*8/length(pic(:));
fprintf('Efficiency of RLE= %.2f\n', eff1);
% 320x400=128000
% This is compressed to 91246 so yes there are spacial redundancies 


% b) 
pic_lzw = norm2lzw(pic);
eff2 = length(pic_lzw)*16/length(pic(:));
fprintf('Efficiency of LZW= %.2f\n', eff2);
% LZW coding is more efficient - this must be due to many repeating
% patterns in the image which make LZW more efficient.

% c)
entr_rle = Entropy(pic_rle);
entr_lzw = Entropy(pic_lzw);
fprintf('Entropy of RLE is %.2f\nEntropy of LZW is %.2f\n',entr_rle, entr_lzw);
% RLE -  Efficiency is above Entropy ==> may be further compressable.
% LZW -  Effiecince is below Entropy ==> cannot be compressed any further.

% d)
p_bar_pic_rle = ProbabilityMass(pic_rle);
p_bar_pic_rle = p_bar_pic_rle(find(p_bar_pic_rle));
Huff_RLE_pic = huffman(p_bar_pic_rle); 
average_huff_rle = BitsPerSymbol(Huff_RLE_pic, p_bar_pic_rle);
fprintf('Length for RLE with huff is %.2f\n',average_huff_rle);
fprintf('Compression efficiency is %.2f\n',length(pic_rle)*entr_rle/length(pic(:)));

% e)
p_bar_pic_lzw = ProbabilityMass(pic_lzw);
p_bar_pic_lzw = p_bar_pic_lzw(find(p_bar_pic_lzw));
Huff_pic_lzw = huffman(p_bar_pic_lzw);  
fprintf('Length for LZW with huff is %.2f\n',length(Huff_pic_lzw)*entr_rle/length(pic(:)));

average_huff_rle = BitsPerSymbol(Huff_RLE_pic, p_bar_pic_rle);
fprintf('Length for RLE with huff is %.2f\n',average_huff_rle);
fprintf('Compression efficiency is %.2f\n',length(pic_rle)*entr_rle/length(pic(:)));

% f)
entr_pic = Entropy(pic);
fprintf('Entropy of original picture is %.2f\n',entr_pic);

% LZW then Huffman coding is the best methof becaause it exploits the
% spacial redundancies within the image.
% This is not a lossy compression since all the information was retained. 