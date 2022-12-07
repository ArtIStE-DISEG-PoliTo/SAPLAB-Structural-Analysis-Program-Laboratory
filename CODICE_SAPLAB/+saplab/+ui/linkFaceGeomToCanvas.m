function linkFaceGeomToCanvas(self, dl, tag)

nbs = saplab.ui.internal.surfgeom(dl);
d = saplab.ui.internal.surfgeom(dl, 1:nbs);

npts = 50;
X=[];
Y=[];
S=[];
for i = 1 : nbs
    seg = linspace(d(1,i) , d(2,i), npts);
    [x,y] = saplab.ui.internal.surfgeom(dl, i, seg);
    x(1:6) = [];
    y(1:6) = [];
    x(end-6:end) = [];
    y(end-6:end) = [];    
    s = i*ones(size(x));
    X = [X x NaN]; %#ok;
    Y = [Y y NaN]; %#ok;
    S = [S s NaN]; %#ok;
end
pts = [X;Y;zeros(size(X))]';
tags = cell(size(S));
for ii = 1:numel(S)
    tags{ii} = [tag ' - Edge ' num2str(S(ii)) ];
end 

self.Graphics.LinkedCanvasPoints = [self.Graphics.LinkedCanvasPoints; pts];
self.Graphics.CanvasChildrenTags = [self.Graphics.CanvasChildrenTags, tags]; 

vertices = [self.Geometry.Vertices,zeros(size(self.Geometry.Vertices(:,1)))];

for ik = 1:size(vertices,1)
    tagv{ik} = [ tag ' - Vertex ' num2str(ik) ]; %#ok
end

self.Graphics.LinkedCanvasPoints = [self.Graphics.LinkedCanvasPoints; vertices];
self.Graphics.CanvasChildrenTags = [self.Graphics.CanvasChildrenTags, tagv];
