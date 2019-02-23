function measure = SearchTranslations(template,image,similarity )
% measure = SearchTranslations(template,image,similarity )
[ty tx] = size(template);
[sy sx] = size(image);
for i=1:(sy-ty)
    for j=1:(sx-tx)
        tmp=image(i:(i+ty-1),j:(j+tx-1));
        switch similarity
            case 'SSD'
                measure(i,j)=SSD(template,tmp);
            case 'NCC'
                measure(i,j)=NCC(template,tmp);
            case 'MI'
                measure(i,j)=MI(template,tmp);
        end
    end
end
end