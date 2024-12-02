fid=fopen('../inputvariabelen_final.txt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    eval(tline)
end
totalinfo=zeros(1000,16,eind-begin+1);
%Hier staat de uitleg van de kolommen:
%1.blobnr, 2.grootte, 3.cgv_hor, 4.cgv_ver, 
%5.-14., de vijf dichtsbijzijnde blobs en hun afstanden
%15. MajorAxisLenght, 16. Orientation
for beeldnr=begin:eind
    name=['00000000' num2str(beeldnr)];name=name(length(name)-8:length(name));
    eval(cIMAGE);
    blobbeeld=imread(IMAGE);
    s=regionprops(blobbeeld,'Area','Orientation','Centroid','MajorAxisLength','MinorAxisLength','Extrema', 'BoundingBox', 'Extent');
    centroids = cat(1, s.Centroid);
    n_o_blobs=size(centroids,1);
    distances=zeros(n_o_blobs);
    for firstblob=2:n_o_blobs
        for secondblob=1:firstblob-1
            distances(secondblob,firstblob)=(centroids(secondblob,1)-centroids(firstblob,1))^2+(centroids(secondblob,2)-centroids(firstblob,2))^2;
        end
    end  
    distances=distances+distances'; 
    for blobnr=1:n_o_blobs
        w=distances(:,blobnr);
        order=sort(w);
        for teller=1:5
            v=order(teller+1);
            totalinfo(blobnr,6+2*(teller-1),beeldnr)=v;
            totalinfo(blobnr,5+2*(teller-1),beeldnr)=find(w==v,'first',1);
            w(find(w==v,'first',1))=0;
        end
    end
    totalinfo(:,1,beeldnr)=(1:n_o_blobs)';
    totalinfo(:,2,beeldnr)=s.Area;
    totalinfo(:,3:4,beeldnr)=s.Centroid; 
    totalinfo(:,15,beeldnr)=s.MajorAxisLength;
    totalinfo(:,16,beeldnr)=s.Orientation;
end
save('blobstats.mat',totalinfo)
