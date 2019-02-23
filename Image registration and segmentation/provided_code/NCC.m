function ncc = NCC( im1,im2 )
    
    % convert to double
    im1=double(im1);
    im2=double(im2);
    
    % calculate standard deviation
    s1 = std(im1(:));
    s2 = std(im2(:));
    
    % take away image mean
    im1=im1-mean(im1(:));
    im2=im2-mean(im2(:));
    
    % calculate NCC
    ncc=sum(sum(im1.*im2))/(length(im1(:)) * s1 * s2); 
end
