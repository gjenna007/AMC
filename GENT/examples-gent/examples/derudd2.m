                                                     % EXAMPLE     GVF snake examples on two simulated object boundaries.
%
% NOTE: 
% 
% traditional snake and distance snake differed from GVF snake only 
%   by using different external force field. In order to produce the
%   corresponding external force field, use the following (all
%   assuming edge map f is in memory).
%
% traditional snake:
%   f0 = gaussianBlur(f,1);
%   [px,py] = gradient(f0);
%
% distance snake:
%   D = dt(f>0.5);  % distance transform (dt) require binary edge map
%   [px,py] = gradient(-D);
%
% [px,py] is the external force field in both cases
%
% balloon model using a different matlab function "snakedeform2"
% instead of "snakedeform". The external force could be any force
% field generated above.
%
% an example of using it is as follows
%       [x,y] = snakedeform2(x,y, alpha, beta, gamma, kappa, kappap, px,py,2);
% do a "help snakedeform2" for more details
 

%   Chenyang Xu and Jerry Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry Prince

   cd ..;   s = cd;   s = [s, '/snake']; path(s, path); cd examples;
   
  
   % Read in the  image
   I= imread('../images/gelaude05.tif'); 
   I=double(I);
   edgemap=input('load edgemap(1=y,2=n)?');
   if edgemap==2
       
      % Compute its edge map
     tic
     disp(' Compute edge map ...');
     f = double(edge(I,'canny',[],3)); 

   % Compute the GVF of the edge map f
     disp(' Compute GVF ...');
     [u,v] = GVF(f, 0.2, 50);
     toc
     save 'gelaude05edgemap' f u v;%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 else
     load 'sispi1gelaude05edgemap';%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 end
     disp(' Normalizing the GVF external force ...');
     mag = sqrt(u.*u+v.*v);
     px = u./(mag+1e-10); py = v./(mag+1e-10); 

  % display the results 
     figure; H=image(I);set(H,'CDataMapping','scaled'); title('test image');
     colormap(gray(256)); 
     set(H,'CDataMapping','scaled');
     figure; imshow(uint8(I)); title('work image');
     colormap(gray(256));
     % display the gradient of the edge map
    % [fx,fy] = gradient(f); 
    % subplot(223); quiver(fx,fy); 
    % axis off; axis equal; axis 'ij';     % fix the axis 
    % title('edge map gradient');

     % display the GVF 
    % subplot(224); quiver(px,py);
    % axis off; axis equal; axis 'ij';     % fix the axis 
    % title('normalized GVF field');

   % snake deformation
   slang=input('new snake? (1=y,2=n)');
   if slang==1
     disp(' Press any key to start GVF snake procedure');
     pause;
      t = 0:0.05:6.28;
     %x = 500 + 100*cos(t);
     %y = 150 + 100*sin(t);
     [x,y]=snakeinit(0.05);
     [x,y] = snakeinterp(x,y,3,1); % this is for student version
     % for professional version, use 
     % [x,y] = snakeinterp(x,y,2,0.5);
       save 'sispi158gelaudesnakestart' x y;%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   else
       load 'sispi158gelaudesnakestart';%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   end
   
snakedisp(x,y,'r')

figure, imshow(uint8(I));
colormap(gray(256));
     
tic
     for i=1:25,
         i
       [x,y] = snakedeform(x,y,0.05,0,1,0.6,px,py,5);
       [x,y] = snakeinterp(x,y,3,1); % this is for student version
       % for professional version, use 
       % [x,y] = snakeinterp(x,y,2,0.5);
       snakedisp(x,y,'r') 
       title(['Deformation in progress,  iter = ' num2str(i*5)])
       
   end
toc
     disp(' Press any key to display the final result');
     pause;
     figure; imshow(uint8(I));
     colormap(gray(256));
     snakedisp(x,y,'r') 
     title(['Final result,  iter = ' num2str(i*5)]);
     disp(' ');
     