function plotModel(self, M)

narginchk(1,2);
if nargin == 1
    M = [];
end
if isempty(M)
    M    = self.ModelToPlot;
    geom = self.ModelToPlot.Geometry;
    dim  = M.Dim;
    size = M.FEMSystemSize;
end

if isa(M,'sap.StructuralModel')
    geom = M.Geometry;
    dim  = M.Dim;
    size = M.FEMSystemSize;
end
if isa(M, 'sap.Geometry')
    geom = M;
    dim  = M.Dim;
    size = M.FEMSystemsize;
end

canv = self.Canvas;
reset(canv);

%Set the canvas dim
canvasDim=2;
if dim==1 && size==6, canvasDim=3;  end

%build canvas structure
canvas.Axes = canv;
canvas.Appearance = self.Appearance;


if ~isempty(geom)
    if isa(geom,'sap.Geometry')
        if geom.Dim == 1
        self.plot1DElementGeometry(geom, canvas.Axes, canvasDim, canvas);
        return;
        else
        self.plot2DElementGeometry(g.geom, g.geomTag, canvas.Axes, canvas);
        return;
        end
    end 
    
    if isnumeric(g) || isa(g, 'function_handle') || isa(g, 'struct')
        self.plot2DElementGeometry(g, '', canvas.Axes, canvas);
    end  
end

self.plotAxisTriad(canvas.Axes)
canvas.Axes.Projection = 'perspective';
axis(canvas.Axes,'equal')
axis(canvas.Axes,'tight')
axis(canvas.Axes,'off')
canvas.Axes.Clipping = 'off';
end