% Deze functie zet alles op wit (255) wat kleiner (zwarter) is dan threshold (type='reverse')
% Deze functie zet alles op zwart (0) wat groter (witter) is dan threshold (type='noreverse')

function image_return = thresholdinverse(image, threshold, type)

if strcmp(type,'reverse')
    im=double(image);
    imboolean= im >= threshold;   %(alles groter dan treshold (witter) op 1)
    im_tussen=imboolean.*im;
    imboolean=~imboolean*255;
    im_tussen=im_tussen+imboolean;
end
 
if strcmp(type,'noreverse')
    im=double(image);
    imboolean= im <= threshold;   %(alles groter dan treshold (witter) op 1)
    im_tussen=imboolean.*im;
    imboolean=~imboolean*0;
    im_tussen=im_tussen+imboolean;
end
image_return=im_tussen;

