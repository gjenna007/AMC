cd ..;   s = cd;   s = [s, '/snake']; path(s, path); cd examples;

disp(' Normalizing the GVF external force ...');
     mag = sqrt(u.*u+v.*v);
     px = u./(mag+1e-10); py = v./(mag+1e-10);    
% display the results 
     figure; imdisp(I); title('test image');
     figure; imdisp(I); title('work image');

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
     disp(' Press any key to start GVF snake procedure');
     pause;
      t = 0:0.05:6.28;
     %x = 500 + 100*cos(t);
     %y = 150 + 100*sin(t);
     [x,y]=snakeinit(0.05);
     [x,y] = snakeinterp(x,y,3,1); % this is for student version
     % for professional version, use 
       % [x,y] = snakeinterp(x,y,2,0.5);

snakedisp(x,y,'r')

figure, imdisp(I);
     

     for i=1:25,
       [x,y] = snakedeform(x,y,0.05,0,1,0.6,px,py,5);
       [x,y] = snakeinterp(x,y,3,1); % this is for student version
       % for professional version, use 
       % [x,y] = snakeinterp(x,y,2,0.5);
       snakedisp(x,y,'r') 
       title(['Deformation in progress,  iter = ' num2str(i*5)])
       
   end

     disp(' Press any key to display the final result');
     pause;
     figure; imdisp(I); 
     snakedisp(x,y,'r') 
     title(['Final result,  iter = ' num2str(i*5)]);
     disp(' ');
     