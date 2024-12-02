%  Create a computer model of a cyst phantom. The phantom contains
%  fiven point targets and 6, 5, 4, 3, 2 mm diameter waterfilled cysts, 
%  and 6, 5, 4, 3, 2 mm diameter high scattering regions. All scatterers 
%  are situated in a box of (x,y,z)=(50,10,60) mm and the box starts 
%  30 mm from the transducer surface.
%
%  Calling: [positions, amp, total] = cyst_phantom (inner,outer);
%
%  Parameters:  N - Number of scatterers in the phantom
%
%  Output:      positions  - Positions of the scatterers.
%               amp        - amplitude of the scatterers.
%
%  Version 2.2, April 2, 1998 by Joergen Arendt Jensen

function [positions, amp] = ellipsoid_phantom (width,depth,long,inner,outer,innerscat,outerscat)
%The variables width, depth, long denote the DIAMETERS of the various axes 
%inner and outer are the number of scatterers in the phantom per MM3

x_size = width+20/1000;   %  Width of phantom [mm]
y_size = depth+20/1000;   %  Transverse width of phantom [mm]
z_size = long+20/1000;   %  Height of phantom [mm]
z_start = 30/1000;  %  Start of phantom surface [mm];

fin_x=[];
fin_y=[];
fin_z=[];
amp=[];

for i=1:2
%  Create the general scatterers
if (i==1) N=round(inner*x_size*1000*y_size*1000*z_size*1000); end
if (i==2) N=round(outer*x_size*1000*y_size*1000*z_size*1000); end
x = (rand (N,1)-0.5)*x_size;
y = (rand (N,1)-0.5)*y_size;
z = rand (N,1)*z_size;

% Determine which scatterers belong to the ellipsoid
long_axis=(z-z_size/2)/(long/2);
short_axisd=y/(depth/2);
short_axisw=x/(width/2);
ellipsoid=long_axis.*long_axis+short_axisd.*short_axisd+short_axisw.*short_axisw<=1;

%  Make the total ellipisoid_phantom
if (i==2) ellipsoid=1-ellipsoid; innerscat=outerscat;end
fin_x=[fin_x; x(find(ellipsoid))];
fin_y=[fin_y; y(find(ellipsoid))+depth/2];
fin_z=[fin_z; z(find(ellipsoid))+z_start];
amp = [amp; innerscat*randn(sum(ellipsoid),1)]; 
end

%  Return the variables
positions=[fin_x fin_y fin_z];
