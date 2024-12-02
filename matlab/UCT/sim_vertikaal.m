%  Example of use of the new Field II program running under 
%  Matlab 5. The version is also compatible with Matlab 4.
%
%  This example shows how a linear array B-mode system scans an image
%
%  This script assumes that the field_init procedure has been called
%  Here the field simulation is performed and the data is stored
%  in rf-files; one for each rf-line done. The data must then
%  subsequently be processed to yield the image. The data for the
%  scatteres are read from the file pht_data.mat, so that the procedure
%  can be started again or run for a number of workstations.
%
%  Example by Joergen Arendt Jensen and Peter Munk, 
%  Version 1.2, August 14, 1998, JAJ.

%  Ver. 1.1: 1/4-98: Procedure xdc_focus_center inserted to use the new
%                    focusing scheme for the Field II program

%  Generate the transducer apertures for send and receive

function sim_linkscriel(no_linesstart,no_linesend,step,directory,filename)

f0=7.5e6;                %  Transducer center frequency [Hz]
fs=100e6;                %  Sampling frequency [Hz]
c=1540;                  %  Speed of sound [m/s]
lambda=c/f0;             %  Wavelength [m]
width=lambda;            %  Width of element
element_height=5/1000;   %  Height of element [m]
kerf=width/4;            %  Kerf [m]
focus=[0 0 65]/1000;     %  Fixed focal point [m]
N_elements=192;          %  Number of physical elements
N_active=64;             %  Number of active elements 

% Do not use triangles

set_field('use_triangles',0);

%  Set the sampling frequency

set_sampling(fs);

%  Generate aperture for emission

xmit_aperture = xdc_linear_array (N_elements, width, element_height, kerf, 1, 10,focus);

%  Set the impulse response and excitation of the xmit aperture

impulse_response=sin(2*pi*f0*(0:1/fs:2/f0));
impulse_response=impulse_response.*hanning(max(size(impulse_response)))';
xdc_impulse (xmit_aperture, impulse_response);

excitation=sin(2*pi*f0*(0:1/fs:2/f0));
xdc_excitation (xmit_aperture, excitation);

%  Generate aperture for reception

receive_aperture = xdc_linear_array (N_elements, width, element_height, kerf, 1, 10,focus);

%  Set the impulse response for the receive aperture

xdc_impulse (receive_aperture, impulse_response);

%   Load the computer phantom
cd(directory)
load(filename) 
cd ..

%  Set the different focal zones for reception

focal_zones=[60:200]'/1000;
Nf=max(size(focal_zones));
focus_times=(focal_zones-10/1000)/1540;
z_focus=115/1000;          %  Transmit focus

%  Set the apodization

apo=hanning(N_active)';

%   Do linear array imaging

no_lines=50;                    %  Number of lines in image
image_width=50/1000;            %  Size of image sector
d_x=image_width/(no_lines);       %  Increment for image

% Do imaging line by line

for i=[no_linesstart:step:no_linesend]
%for i=[24]
i
   %  The the imaging direction

   x= -image_width/2 +(i-1)*d_x;

   %   Set the focus for this direction with the proper reference point

  xdc_center_focus (xmit_aperture, [x 0 0]);
  xdc_focus (xmit_aperture, 0, [x 0 z_focus]);
  xdc_center_focus (receive_aperture, [x 0 0]);
  xdc_focus (receive_aperture, focus_times, [x*ones(Nf,1), zeros(Nf,1), focal_zones]);

   %  Calculate the apodization 
   
  N_pre  = round(x/(width+kerf) + N_elements/2 - N_active/2);
  N_pre=min(max(0,N_pre),N_elements-N_active);%0<=N_pre<=N_element-N_active
  N_post = N_elements - N_pre - N_active;
  apo_vector=[zeros(1,N_pre) apo zeros(1,N_post)];
  %  size(apo_vector)
  xdc_apodization (xmit_aperture, 0, apo_vector);
  xdc_apodization (receive_aperture, 0, apo_vector);
  
  %   Calculate the received response

  [rf_data, tstart]=calc_scat(xmit_aperture, receive_aperture, phantom_positions, phantom_amplitudes);

  %  Store the result
cd(directory)
  cmd=['save rf_ln',num2str(i),'.mat rf_data tstart'];
  eval(cmd);
cd ..
  end

%   Free space for apertures

xdc_free (xmit_aperture)
xdc_free (receive_aperture)

