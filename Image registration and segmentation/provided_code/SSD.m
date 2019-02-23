function ssd = SSD(im1,im2)
  diff = double(im1)-double(im2);
  ssd = sum(sum(diff.^2))/length(diff(:));
end

