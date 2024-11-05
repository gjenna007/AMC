% EXAMPLE     an example of distance snake on U shape boundary          
%

%   Chenyang Xu and Jerry Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry Prince

   cd ..;   s = cd;   s = [s, '/snake']; path(s, path); cd examples;
   
  

   % Read in the 64x64 U-shape image
   I = imread('../images/deruddere03.tif');  
   I=double(I);
     
   % Compute its edge map
     disp(' Compute edge map ...');
     f = I>100; 

   % Compute the distance transform
     disp(' Compute distance transform ...');
     D = dt(f>0.5);   % (f>0.5) to gurantee the binary input for dt
     disp(' Compute the distance external force ...');
     [px,py] = gradient(-D);

   % display the results
     figure(1); 
     subplot(121); imdisp(D); title('distance transform');
     subplot(122); quiver(px,py); 
     axis('image', 'off', 'ij');     % fix the axis 
     title('distance force');

   % snake deformation
     disp(' ');
     disp(' Press any key to start the deformation');
     pause;
     figure(1); subplot(121); 
     colormap(gray); image(((1-f)+1)*40); 
     axis('square', 'off');
     t = 0:0.05:6.28;
     x = 500 + 100*cos(t);
     y = 150 + 100*sin(t);
     [x,y] = snakeinterp(x,y,3,1); % this is for student version
     % for professional version, use 
     %   [x,y] = snakeinterp(x,y,2,0.5);
     snakedisp(x,y,'r') 
     pause(1);

     for i=1:25,
       [x,y] = snakedeform(x,y,0.05,0,1,0.5,px,py,5);
       [x,y] = snakeinterp(x,y,3,1); % this is for student version
       % for professional version, use 
       %   [x,y] = snakeinterp(x,y,2,0.5);
       snakedisp(x,y,'r') 
       title(['Deformation in progress,  iter = ' num2str(i*5)])
       pause(0.5);
     end

     disp(' ');
     disp(' Press any key to display the final result');
     pause;
     figure(1); subplot(121); 
     colormap(gray); image(((1-f)+1)*40); 
     axis('square', 'off');
     snakedisp(x,y,'r') 
     title(['Final result,  iter = ' num2str(i*5)]);
