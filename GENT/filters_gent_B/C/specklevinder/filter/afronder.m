function resultaat=afronder(origineel, gefilterd, gekleurd)
%vult op de plaats van de rode speckles de waaden van het originele beeld in. zo wordt het filer op 
%die plaatsen ongean gemaakt
resultaat=origineel;
s=size(origineel);
mal=gekleurd(:,:,1)==255;
resultaat(mal)=gefilterd(mal);
%for ver=1:s(1)
%    for hor=1:s(2)
%        if gekleurd(ver,hor,1)==255
 %           resultaat(ver,hor)=gefilterd(ver,hor);
 %       end
 %    end
 %end

