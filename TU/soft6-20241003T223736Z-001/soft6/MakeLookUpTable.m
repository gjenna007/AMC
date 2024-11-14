function lookup=MakeLookUpTable(v_in,hw,vw)
transl_x=v_in(1);
transl_y=v_in(2);
rot=v_in(3);
lmatrix=zeros(8*vw+1,8*hw+1,2);
lookup=zeros(8*vw+1,8*hw+1,2);
for ver=1:8*vw+1
    lmatrix(ver,:,1)=(-4*hw:4*hw);
end
for hor =1:8*hw+1
    lmatrix(:,hor,2)=(-4*vw:4*vw)';
end
lookup(:,:,1)=round(cosd(rot)*lmatrix(:,:,1)-sind(rot)*lmatrix(:,:,2)+transl_x);
lookup(:,:,2)=round(sind(rot)*lmatrix(:,:,1)+cosd(rot)*lmatrix(:,:,2)+transl_y);