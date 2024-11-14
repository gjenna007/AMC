function out=cutwith (in,cver,chor)
if cver<=size(in,1)/2
    in=cat(1,zeros(size(in,1)-2*cver+1,size(in,2)),in);
end
if cver>size(in,1)/2
    in=cat(1,in,zeros(2*cver-size(in,1)-1,size(in,2)));
end
if chor<=size(in,2)/2
    in=cat(2,zeros(size(in,1),size(in,2)-2*chor+1),in);
end
if chor>size(in,2)/2
    in=cat(2,in,zeros(size(in,1),2*chor-size(in,2)-1));
end
out=in;