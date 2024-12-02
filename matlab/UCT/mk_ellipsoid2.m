%  Make the scatteres for a simulation and store
%  it in a file for later simulation use

%   Joergen Arendt Jensen, Feb. 26, 1997
% The following needs to be filled in: (ellipsoid_width,ellipsoid_depth,ellipsoid_length,inner_density,outer_density,inner_scattstrength,outer_scattstrength)
% inner_denstiy and outer_density are the number of scatterers per MM3

[phantom_positions, phantom_amplitudes] = ellipsoid2_pht(25/1000,15/1000,50/1000,2,1,1,1);
save ellipsoid_data.mat phantom_positions phantom_amplitudes
