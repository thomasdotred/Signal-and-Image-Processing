function gn = CannyNonMaximaSuppression( M,alpha )
%%% non maximum suppression
gn=zeros(size(M));
gnz=gn;
for ii=2:size(M,1)-1
    for jj=2:size(M,2)-1
        %%% get dir
        aa = alpha(ii,jj);
        if aa<0
            aa=aa+180;
        end
        if (aa<22.5)||(aa>157.5)
            zn=1;
        else
            if (aa<67.5)
                zn=2;
            else
                if (aa<112.5)
                    zn=3;
                else 
                    zn=4;
                end
            end
        end
        gnz(ii,jj)=zn;
        
        %%% suppression based on zone
        switch zn
            case 1 % vertical edge => look left and right
                if (M(ii,jj)>M(ii,jj-1))&&(M(ii,jj)>M(ii,jj+1))
                    gn(ii,jj)=M(ii,jj);
                end
            case 2 % -45deg edge
                if (M(ii,jj)>M(ii-1,jj-1))&&(M(ii,jj)>M(ii+1,jj+1))
                    gn(ii,jj)=M(ii,jj);
                end
            case 3 % horiz. edge => look up and down
                if (M(ii,jj)>M(ii-1,jj))&&(M(ii,jj)>M(ii+1,jj))
                    gn(ii,jj)=M(ii,jj);
                end
            case 4 % +45deg edge
                if (M(ii,jj)>M(ii-1,jj+1))&&(M(ii,jj)>M(ii+1,jj-1))
                    gn(ii,jj)=M(ii,jj);
                end
        end
    end
end

end

