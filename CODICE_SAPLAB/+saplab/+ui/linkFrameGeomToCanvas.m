function linkFrameGeomToCanvas(self)

narginchk(1,1);
L = self.Geometry.GeometricDomain;
P = self.Geometry.GeometricBoundaries;

if isempty(L) && isempty(P)
    return;
end
self.Graphics.LinkedCanvasPoints = [];
self.Graphics.CanvasChildrenTags = [];
if ~isempty(L)
    for ii = 1:size(L,1) %link line elements to the canvas
        x = linspace(L(ii,5), L(ii,6), 50);
        y = linspace(L(ii,7), L(ii,8), 50);
        z = linspace(L(ii,9), L(ii,10),50);
    
        %calculate linked points
        x(:,1:4) = []; y(:,1:4) = []; z(:,1:4) =[];
        x(:,end-6:end) = []; y(:,end-6:end) = []; z(:,end-6:end) = [];
        linkpts = [x' y' z'];
        self.Graphics.LinkedCanvasPoints = [self.Graphics.LinkedCanvasPoints; linkpts];
    
        %calculate linked tags
        tag = ['Line ' num2str(L(ii,1)) '-' num2str(L(ii,2))];
        tags = repmat(cellstr(tag),numel(x),1);
        self.Graphics.CanvasChildrenTags = [self.Graphics.CanvasChildrenTags; tags];
    end
end

for ii = 1:size(P,1)
    x = P(ii,1);
    y = P(ii,2);
    z = P(ii,3);
    linkpts = [x y z];
    self.Graphics.LinkedCanvasPoints = [self.Graphics.LinkedCanvasPoints; linkpts];
    tag = cellstr(['Point ' num2str(ii)]);
    self.Graphics.CanvasChildrenTags = [self.Graphics.CanvasChildrenTags; tag];
end


end