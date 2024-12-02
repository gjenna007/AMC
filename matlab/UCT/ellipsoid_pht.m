%  Create a computer model of a cyst phantom. The phantom contains
%  fiven point targets and 6, 5, 4, 3, 2 mm diameter waterfilled cysts, 
%  and 6, 5, 4, 3, 2 mm diameter high scattering regions. All scatterers 
%  are situated in a box of (x,y,z)=(50,10,60) mm and the box starts 
%  30 mm from the transducer surface.
%
%  Calling: [positions, amp] = cyst_phantom (N);
%
%  Parameters:  N - Number of scatterers in the phantom
%
%  Output:      positions  - Positions of the scatterers.
%               amp        - amplitude of the scatterers.
%
%  Version 2.2, April 2, 1998 by Joergen Arendt Jensen

function [positions, amp] = ellipsoid_phantom (N)

x_size = 20/1000;   %  Width of phantom [mm]
y_size = 15/1000;   %  Transverse width of phantom [mm]
z_size = 50/1000;   %  Height of phantom [mm]
z_start = 30/1000;  %  Start of phantom surface [mm];

%  Create the general scatterers

x = (rand (N,1)-0.5)*x_size;
y = (rand (N,1)-0.5)*y_size;
z = rand (N,1)*z_size + z_start;

%  Generate the amplitudes with a Gaussian distribution

amp=randn(N,1);

%  Make the seperate points and set the amplitudes to zero inside

long_axis=(z-55/1000)/z_size;
short_axis1=y/y_size;
short_axis2=x/x_size;
ellipsoid=long_axis.*long_axis+short_axis1.*short_axis1+short_axis2.*short_axis2<=1;

%  Make the ellipsoid and set the amplitudes to 10 times inside
amp = amp .* (1-ellipsoid) + 10*amp .* ellipsoid; 
  
%  Return the variables
positions=[x y z];
end
