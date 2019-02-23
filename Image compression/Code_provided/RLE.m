function rle = RLE(image)
%calculates run-legth encoding of an image matrix

%linearise the image
im = reshape(image,[1 numel(image(:))]);
%index for rle
index=1;
% current value and count for the first element
val = im(1);
count=1;

%start from second element
for(i=2:length(im))
%new pair for RLE
if val ~= im(i) || count>=255 
    rle(index)=val;
    rle(index+1)=count;
    val=im(i);
    count = 1;
    index = index+2;
else %increase count
    count = count+1;
end

%add the last pair
if i==length(im)
  rle(index)=val;
  rle(index+1)=count;  
end
end

