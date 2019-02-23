function mi = MI(im1,im2 )
e1=Entropy(im1);
e2=Entropy(im2);
je=JointEntropy(im1,im2);
mi=e1+e2-je;
end

