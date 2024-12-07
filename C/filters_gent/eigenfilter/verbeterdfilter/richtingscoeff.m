function r=richtingscoeff(horcoord, vercoord)
%Berekent de richtingscoeffiecient van de rechte lijn, die de gegeven punten het best fit volgen de kleinste
%kwadraten methode. Als positive x-as wordt de horizontale as gekozen (horcoord dus), als positieve y-as de verikale
%as (vercoord). De oorsprong zit in de linkerbovenhoek. We werken dus eigenlijk in het vierde kwadrant.
%De hier gebruikte formules zijn die uit het statistiekdictaat 2e kan van Filip Rooms.
%De gedachte hierachter is dat als de punten een speckletje vormen (een dun wit lijnstukje dus), dan zou de berekende 
%lijn de raaklijn aan dit lijnstukje moeten zijn.
s=size(horcoord);
teller=s(2)*sum(horcoord.*vercoord)-sum(horcoord)*sum(vercoord);
noemer=s(2)*sum(horcoord.*horcoord)-sum(horcoord)*sum(horcoord);
if noemer==0 
   r=pi;
else r=teller/noemer;
end

