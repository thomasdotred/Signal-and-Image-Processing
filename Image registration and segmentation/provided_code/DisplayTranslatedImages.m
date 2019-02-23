function DisplayTranslatedImages( image, template, tx, ty )
[sy, sx] = size(template);

    RI = imref2d(size(image),[1,size(image,2)+1],[1,size(image,1)+1]);
    RT = imref2d(size(template), [tx tx+sx], [ty ty+sy]);
    figure; imshowpair(image, RI, template, RT);

end

