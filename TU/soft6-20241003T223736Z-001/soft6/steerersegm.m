cd smallpaint
orig=double(imread('bFrame04700.png'));
cd ..
%a=sum(w2,1);
%w2=a;
result=zeros(size(orig,1),size(orig,2));
avg=(orig(:,:,1)+orig(:,:,2)+orig(:,:,3))/3;
dist=abs(orig(:,:,1)-avg)+abs(orig(:,:,2)-avg)+abs(orig(:,:,3)-avg);
for ver=1:size(orig,1)
        for hor=1:size(orig,2)
            pg=round(avg(ver,hor));
            pp=round(dist(ver,hor));
            %pp=0;
            if pp<=45 
                if w2(pp+1,pg+1)>200
                    result(ver,hor)=1;
                end
            end
        end
end
figure,imshow(result,[]) 