function bbox=set_CanvasBoundingBox(xlim,ylim,zlim)
%evaluate bounding box
bbox(1,1) = xlim(1);
bbox(1,2) = xlim(2);
bbox(2,1) = ylim(1);
bbox(2,2) = ylim(2);
bbox(3,1) = zlim(1);
bbox(3,2) = zlim(2);
% lim = abs([xlim(1),xlim(2),ylim(1),ylim(2),zlim(1),zlim(2)]); 
% gradients = (max(lim));
% bbox = gradients/20;
end