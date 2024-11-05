function janee=loodrecht(horcoord,vercoord,raaklijn,maxafwijking,transducerx,transducery)
%er wordt berekend of het speckletje loodrecht op de radiaal staat naar het centrale/zwaartepunt (binnen de tolerantie-
%grenzen van de maxafwijking.In janee komt het antwoord (wel of niet) te staan. Deze informatie kan in een volgende
%stap gebruikt worden om of het speckletje uit he tbeeld weg te filteren, of het in een (oorspronkelijk leeg) beeld
%te tekenen en te kleuren (bijvoorbeeld rood voor wel loodrecht, blauw voor niet loodrecht). Deze tekening kan 
%gebruikt worden om te beoordelen of de methode werkt en hoe we de grenzen eventueel moeten aanpassen.
centrumx=mean(horcoord);
centrumy=mean(vercoord);
radiaal=double([transducerx-centrumx transducery-centrumy]);
tangent=double([1 raaklijn]);
janee=0;
if abs(sum(radiaal.*tangent))<sin(maxafwijking*pi/180)*sqrt(sum(radiaal.*radiaal)*sum(tangent.*tangent))
   janee=1;
end
