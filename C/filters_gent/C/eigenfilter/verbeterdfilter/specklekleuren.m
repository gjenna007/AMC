function uitbeeld= specklekleuren(inbeeld,horcoord,vercoord,janee)
%kleurt de puntenverzameling met de coordinaten horcoord en vercoord in op inbeeld. Als janee=1,dwz. als het inderdaad
%speckle is, wordt ie rood gekleurd, anders blauw.
uitbeeld=inbeeld;
s=size(horcoord);
rood=255*janee;
blauw=255*(1-janee);
for kwast=1:s(2)
   uitbeeld(vercoord(kwast),horcoord(kwast),1)=rood;
   uitbeeld(vercoord(kwast),horcoord(kwast),3)=blauw;
end
