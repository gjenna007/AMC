BEGIN=10;Tg1=15;T2=230;Tk1=10;FORMER=.82;NOW=.82;RAND=5;
backg=imread([num2str(BEGIN) '.bmp']);
oldcars = zeros(size(backg,1),size(backg,2));
buffer1 = zeros(size(backg,1),size(backg,2));
buffer0 = zeros(size(backg,1),size(backg,2));
oldcarcount = ones(size(backg,1),size(backg,2));
oldcarcount(1,1)=0;
se=strel('disk',RAND);
for beeld=BEGIN+4:4:BEGIN+28
