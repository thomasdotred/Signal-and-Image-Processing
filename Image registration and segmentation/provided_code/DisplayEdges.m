function DisplayEdges( image, edges )

% imRGB = repmat(image, [1, 1, 3]);
% [indx, indy] = find(edges > 0);
% indx = indx(:);
% indy = indy(:);
% imRGB(indx, indy, 1) = 255;
% imRGB(indx, indy, 2) = 0;
% imRGB(indx, indy, 3) = 0;

imR = image;
ind = find(edges > 0);
imR(ind) = 255;

imG = image;
imG(ind) = 0;

imB = imG;

imRGB = cat(3, imR, imG, imB);

%figure;
imshow(imRGB);

end

