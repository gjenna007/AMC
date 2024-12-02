===========================================================================
			WaterMerge
===========================================================================
Universiteit Gent
Faculteit Toegepaste Wetenschappen
Vakgroep TELIN (Telecommunicatie en Informatieverwerking)

"Interactieve segmentatie van echografie- en MR beelden"
	
		Kris Bonnarens 
		Ruben Cantaert

Promotor: Prof. dr. ir. W. Philips
Begeleider: drs. G. Stippel

Scriptie ingediend tot het behalen van de academische graad 
van gediplomeerde in de aanvullende studies informatica

==========================================================================

Installatie instructies WaterMerge:
benodigd: Matlab (minstens Version 6) met Matlab Image Processing Toolbox
Kopieer de watermerge map naar de harde schijf.
		bv. C:\Matlab\work\watermerge

Opstarten WaterMerge:
Zet de Matlab 'current directory' window op de WaterMerge map.
Typ watermerge in de Matlab 'command window'.
Het pad naar WaterMerge kan ingesteld worden via het menu Extra/Set Path, 
van dan af aan kan WaterMerge vanuit gelijk welke Matlab 'current directory' 
opgestart worden. Het pad moet maar éénmalig ingesteld worden.

=========================================================================
WaterMerge bronbestanden:

about.fig
about.m
about.tif
closewindow.tif
closewindow.m
coocc.m
exitwindow.fig
exitwindow.m
isedge.m
loadsession.m
mergen.m
outeredge.m
resethandles.m
savesession.m
show_outeredge.m
showsegments.m
texture.m
thresholdinverse.m
watermerge.fig
watermerge.m
zoompointer.m

Extra's:

De segmentatiedemonstratie voor een echografiefoto uit de thesis is als WaterMerge 
session opgeslaan en is beschikbaar onder de map 'sessions' als:
thesisdemo.mat
Via File/load session kan deze session ingeladen worden.

Het rapport van deze sessie bevindt zich onder de map 'reports' als:
thesisdemo.xls en thesisdemo.tiff

Het originele beeldbestand bevindt zich onder de map 'images' als:
echoimage.tiff
	

------------------------------------------------------------------------------------