bw = imread('text.png');
        L = bwlabel(bw);
        s  = regionprops(L, 'centroid');
        centroids = cat(1, s.Centroid);
        imshow(bw)
        hold on
        plot(centroids(:,1), centroids(:,2), 'b*')
        hold off
        BW = imread('text.png');
   s  = regionprops(BW, 'centroid');
   centroids = cat(1, s.Centroid);
   imshow(BW)
   hold on
   plot(centroids(:,1), centroids(:,2), 'b*')
   hold off
   totalinfo=zeros(1000,50,eind-begin+1);
for beeldnr=begin:eind
    name=;
    blobbeeld=imread(name);
    s=regionprops(blobbeeld,'Area','Orientation','Centroid','MajorAxisLength','MinorAxisLength','Extrema', 'BoundingBox', 'Extent');
    centroids = cat(1, s.Centroid);
    distances=zeros(size(centroids,1));
    for firstblob=2:size(centroids,1)
        for secondblob=1:firstblob-1
            distances(secondblob,firstblob)=(centroids(secondblob,1)-centroids(firstblob,1))^2+(centroids(secondblob,2)-centroids(firstblob,2))^2;
        end
    end  
    distances=distances+distances';
    
    for blobnr=1:max(blobs(:))
        blob=blobs==blobnr;
        %Hier staat de uitleg van de kolommen:
        %1.blobnr, 2.grootte, 3.cgv_hor, 4.cgv_ver, 
        %5.-14., de vijf dichtsbijzijnde blobs en hun afstanden
        totalinfo(blobnr,1,beeldnr)=blobnr;
        totalinfo(blobnr,2,beeldnr)=sum(blob(:));
        [v,h]=find(blob);
        totalinfo(blobnr,3,beeldnr)=mean(h);
        totalinfo(blobnr,4,beeldnr)=mean(v);
    end 
end
totalinfo=zeros(1000,50,eind-begin+1);
for beeldnr=begin:eind
    name=;
    blobbeeld=imread(name);
    blobs=bwlabel(blobbeeld);
    distances=zeros(max(blobs(:)));
    for firstblob=2:max(blobs(:))
        for secondblob=1:firstblob-1
            cgv_hor_first=totalinfo(firstblob,3,beeldnr);
            cgv_ver_first=totalinfo(firstblob,4,beeldnr);
            cgv_hor_second=totalinfo(secondblob,3,beeldnr);
            cgv_ver_second=totalinfo(secondblob,4,beeldnr);
            distances(secondblob,firstblob)=(cgv_hor_second-cgv_hor_first)^2+(cgv_ver_second-cgv_ver_first)^2;
        end
    end
    distances=distances+distances';
    for blobnr=1:max(blobs(:))
        blob=blobs==blobnr;
        %Hier staat de uitleg van de kolommen:
        %1.blobnr, 2.grootte, 3.cgv_hor, 4.cgv_ver, 
        %5.-14., de vijf dichtsbijzijnde blobs en hun afstanden
        totalinfo(blobnr,1,beeldnr)=blobnr;
        totalinfo(blobnr,2,beeldnr)=sum(blob(:));
        [v,h]=find(blob);
        totalinfo(blobnr,3,beeldnr)=mean(h);
        totalinfo(blobnr,4,beeldnr)=mean(v);
        w=distances(:,blobnr);
        order=sort(w);
        for teller=1:5
            v=order(teller+1);
            totalinfo(blobnr,6+2*(teller-1),beeldnr)=v;
            totalinfo(blobnr,5+2*(teller-1),beeldnr)=find(w==v,'first',1);
            w(find(w==v,'first',1))=0;
        end
    end
    %je moet niet alleen het aantal pixels, maar ook de lengte (en breedte)
    %van de blobs in de tabel zetten
    
end