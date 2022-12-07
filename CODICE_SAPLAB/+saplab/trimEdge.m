function tag = trimEdge(g,geom,varargin)

p = inputParser();
p.addParameter('Edge',[],@(x) isnumeric(x) && numel(x)==2);
p.parse(varargin{:});

pr = p.Results.Edge;
edgeID = pr(1);
dist   = pr(2);

if isa(g,'sap.FEModel')
     g = g.Geometry;
end

if ~isstruct(geom) && (isstring(geom) || ischar(geom))
    gdata = g.csgdb;
    tag = geom;
    numFac = size(gdata.tag,1);
    id=findfacet(gdata, numFac, tag);
    geom = [];
    geom.class = g.csgdb.class{id};
    geom.tag = g.csgdb.tag{id};
    geom.sf = g.csgdb.dl{id,3};
    geom.dl = g.csgdb.dl{id};
    geom.dl1 = g.csgdb.dl1{id};
    geom.gd = g.csgdb.gd{id};
    geom.msb = g.csgdb.msb{id};
    geom.bt = g.csgdb.bt{id};
    geom.bt1 = g.csgdb.bt1{id};
end

if edgeID > size(geom.dl,2)
    error(['Edge (' num2str(edgeID) ') not found']);
end


x1 = geom.dl(2,edgeID);
x2 = geom.dl(3,edgeID);
y1 = geom.dl(4,edgeID);
y2 = geom.dl(5,edgeID);

if geom.dl(1,edgeID) == 2
    
    L = norm([x2-x1 y2-y1]);
    
    if dist>L
        error('Distance exceeds edge length.');
    end
    if dist==0 || dist==L
        return
    end
    if dist<0
        error('Invalid distance value');
    end

    lVect = linspace(0,L,L*1000);
    xVect = linspace(x1,x2,L*1000);
    yVect = linspace(y1,y2,L*1000);

    [~,i] = min(abs(lVect-dist));

    xOut = xVect(i);
    yOut = yVect(i);

end

theEdgedx = geom.dl(:,edgeID);
theEdgedx(3) = xOut;
theEdgedx(5) = yOut;

theEdgesx = geom.dl(:,edgeID);
theEdgesx(2) = xOut;
theEdgesx(4) = yOut;

if edgeID < size(geom.dl,2)
    newGeom = [geom.dl(:,1:edgeID-1) theEdgedx theEdgesx geom.dl(:,edgeID+1:end)];
elseif edgeID == size(geom.dl,2)
    newGeom = [geom.dl(:,1:edgeID-1) theEdgedx theEdgesx];
end

geom.dl = newGeom;
geom.dl1 = newGeom;

geom=g.cobjtodb(geom.dl,geom.sf,geom.bt,geom.dl1,geom.bt1,geom.msb,geom.class);
tag = geom.tag;
end

function id=findfacet(gdata, numFac, tag)
    id = 0;
    for ii = 1:numFac
        if strcmpi(gdata.tag{ii}, tag)
          id=ii;
        end
    end 
    if id == 0
       error(['Face with label (' tag ') not found!']);        
    end
end
