function plotDiagrams(ax, m, diagValues, scaleFactor)
%plotnx Plot axial forces
%   Detailed explanation goes here
if ~contains(m.AnalysisType, 'frame')
    error('Functionality not supported')
end

switch m.Dim
    case 1
        if m.Geometry.SysDim == 3
           plotTwoDDiagrams(m.Results, ax, diagValues, scaleFactor)
        else
           plotThreeDDiagrams(m.Results,ax, diagValues,scaleFactor)
        end
end
end

function plotTwoDDiagrams(R, ax, diagValues, scaleFactor)

%build region associativity
packRegionData = mshAssociativity(R, R.ParentModel.Geometry.NumLines);

%compute the maximum size of the bounding box for scaling
xlim = max(abs(ax.XLim));
ylim = max(abs(ax.YLim));
zlim = max(abs(ax.ZLim));

bboxMax=max([xlim,ylim,zlim]);

if isempty(scaleFactor), scaleFactor = bboxMax/(10*max(abs(diagValues{1}))); end

NODAL_LABEL = [];

for i=1:numel(diagValues)

    [~,x,y,~,L]=buildRegionPlotData(R,packRegionData,i);
    xx = linspace(x(1),x(2),numel(diagValues{i}));
    yy = linspace(y(1),y(2),numel(diagValues{i}));
    %formulate tensors to plot
    u = linspace(0,L,numel(diagValues{i}));
    v = scaleFactor*diagValues{i};
    if all(v==0), continue; end

    w = zeros(size(u));

    uu = [0 u u(end)];
    vv = [0 v 0];
    ww = [0 w 0];
    Le = 0.1*norm([x(1)-x(end) y(1)-y(end)]);

    rotComponents = R.ParentModel.Geometry.evalTrasformationMatrix(i,'components');

    d = saplab.graphics.rotate3([uu;vv;ww],[0,0,0],rotComponents); %diagrams function
    p = saplab.graphics.rotate3([uu;ww;ww],[0,0,0],rotComponents); %diagrams fill pattern
    %form diagrams fill pattern
    patt = [d(1:2,1:3*ceil(numel(uu)/(0.5*Le)):end);p(1:2,1:3*ceil(numel(uu)/(0.5*Le)):end)];

    %plot diagrams    
    nel = floor(numel(diagValues{i})/2)
    cb = 'r';

    NODAL_LABEL = [NODAL_LABEL;  vv(2)/scaleFactor d(1,2)+x(1) y(2)-d(2,2)];          %#ok
    NODAL_LABEL = [NODAL_LABEL;  vv(end-1)/scaleFactor d(1,end-1)+x(1) y(2)-d(2,end-1)];  %#ok
    NODAL_LABEL = [NODAL_LABEL;  vv(nel)/scaleFactor xx(nel) yy(nel)-d(2,nel)];  %#ok
    fill(ax,d(1,:)+x(1),-d(2,:)+y(1),[1,1,1], 'EdgeColor', 'none','Tag','DIAGRAM','FaceAlpha',.35);
    plot(ax,[patt(1,:);patt(3,:)]+x(1),-[patt(2,:);patt(4,:)]+y(1), 'Color',cb,'LineStyle', '-','Tag','DIAGRAM');
    plot(ax,d(1,:)+x(1),-d(2,:)+y(1), 'Color', cb,'Tag','DIAGRAM');

end
[~,ia,~] = unique(NODAL_LABEL(:,2:3),'rows','stable');
NODAL_LABEL = NODAL_LABEL(ia,:);

for i=1:size(NODAL_LABEL,1)
     val = NODAL_LABEL(i,1);
     x = NODAL_LABEL(i,2);
     y = NODAL_LABEL(i,3);
     text(ax,x,y,(string([num2str(val,'%.2E')])),'FontSmoothing','on','HorizontalAlignment','center','VerticalAlignment','middle');
end

end

function plotThreeDDiagrams(R, ax, diagValues, scaleFactor)

%build region associativity
packRegionData = mshAssociativity(R, R.ParentModel.Geometry.NumLines);

%compute the maximum size of the bounding box for scaling
xlim = max(abs(ax.XLim));
ylim = max(abs(ax.YLim));
zlim = max(abs(ax.ZLim));

bboxMax=max([xlim,ylim,zlim]);

if isempty(scaleFactor), scaleFactor = bboxMax/(1000*max(abs(diagValues{1}))); end

NODAL_LABEL = [];

for i=1:numel(diagValues)

    [~,x,y,z,L]=buildRegionPlotData(R,packRegionData,i);
    xx = linspace(x(1),x(2),numel(diagValues{i}));
    yy = linspace(y(1),y(2),numel(diagValues{i}));
    zz = linspace(z(1),z(2),numel(diagValues{i}));
    %formulate tensors to plot
    u = linspace(0,L,numel(diagValues{i}));
    v = scaleFactor*diagValues{i};
    if all(v==0), continue; end

    w = zeros(size(u));

    uu = [0 u u(end)];
    vv = [0 v 0];
    ww = [0 w 0];
    Le = 0.005*norm([x(1)-x(end) y(1)-y(end) z(1)-z(end)]);

    rotComponents = R.ParentModel.Geometry.evalTrasformationMatrix(i,'components');

    d = saplab.graphics.rotate3([uu;ww;vv],[0,0,0],rotComponents); %diagrams function
    p = saplab.graphics.rotate3([uu;ww;ww],[0,0,0],rotComponents); %diagrams fill pattern
    %form diagrams fill pattern
    patt = [d(1:3,1:ceil(numel(uu)/Le):end);p(1:3,1:ceil(numel(uu)/Le):end)];

    %plot diagrams    
    nel = floor(numel(diagValues{i})/2);

    NODAL_LABEL = [NODAL_LABEL;  vv(2)/scaleFactor x(1) y(1)+d(3,2) z(1)-d(2,2)];          %#ok
    NODAL_LABEL = [NODAL_LABEL;  vv(end-1)/scaleFactor d(1,end-1)+x(1) d(3,end-1)+y(1) -d(2,end-1)+z(1)];  %#ok
    NODAL_LABEL = [NODAL_LABEL;  vv(end-1)/scaleFactor d(1,nel)+x(1) d(3,nel)+y(1) -d(2,nel)+z(1)];  %#ok
    cb = 'k';
    fill3(ax,d(1,:)+x(1),d(3,:)+y(1),-d(2,:)+z(1),'w', 'EdgeColor', 'k','Tag','DIAGRAM','FaceAlpha',.35);
    plot3(ax,[patt(1,:);patt(4,:)]+x(1),[patt(3,:);patt(6,:)]+y(1),-[patt(2,:);patt(5,:)]+z(1), 'Color','r','LineStyle', '-','Tag','DIAGRAM');

end

% [~,ia,~] = unique(NODAL_LABEL(:,2:4),'rows','stable');
% NODAL_LABEL = NODAL_LABEL(ia,:);
% for i=1:size(NODAL_LABEL,1)
%      val = NODAL_LABEL(i,1);
%      x = NODAL_LABEL(i,2);
%      y = NODAL_LABEL(i,3);
%      z = NODAL_LABEL(i,4);
%      text(ax,x,y,z,(string(num2str(val,'%.2E'))),'FontSmoothing','on');
% end

end


function packRegionData = mshAssociativity(R,nRegion)
     k = 1;
     for i=1:nRegion
          r = find(R.Mesh.Associativity(1,:)==i);
          s = max(R.Mesh.Associativity(2,r));
          for j=1:s
               rs = find(and(R.Mesh.Associativity(1,:)==i,(R.Mesh.Associativity(2,:)==j)));
               packRegionData.RegionID{k} = [i,j];
               packRegionData.ElementsAssociativity{k} = rs;
               k=k+1;
          end
     end
end


function [ne,xx,yy,zz,L]=buildRegionPlotData(Results, packedRegionData, nRegion)
    e  = packedRegionData.ElementsAssociativity{nRegion};
    ne = numel(e);
    elems = Results.Mesh.Elements(:,e);
    nodes = Results.Mesh.Nodes(:,elems);
    xx = [nodes(1,1) nodes(1,end)];
    yy = [nodes(2,1) nodes(2,end)];
    zz = [nodes(3,1) nodes(3,end)];
    L = Results.Mesh.h(e);
    L = sum(L);
end