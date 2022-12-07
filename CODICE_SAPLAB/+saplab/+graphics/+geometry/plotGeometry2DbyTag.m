function m = plotGeometry2DbyTag(ax, m, tag)
tag
%plot not imported 2D geometry by tag
if ~isempty(tag) && ~contains(m.AnalysisType,'frame') 
     dl = extractdl(m, tag);
     if ~strcmpi(tag, 'all')
          saplab.graphics.geometry.plotGeometry2DNumeric(ax, dl, tag, m.Graphics.Appearance)
     else
         for i=1:numel(dl)
          saplab.graphics.geometry.plotGeometry2DNumeric(ax, dl{i}, '', m.Graphics.Appearance)   
         end
     end
     m = dl;
else
     return;
end
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

function dl = extractdl(m, tag)
     csgdb = m.Geometry.csgdb;
     alldl = csgdb.dl;
     if ~strcmpi(tag, 'all')
     numFac = size(csgdb.tag,1);
     dlpos=findfacet(csgdb, numFac, tag);
     dl = alldl{dlpos};
     else
     dl = alldl;
     end
end