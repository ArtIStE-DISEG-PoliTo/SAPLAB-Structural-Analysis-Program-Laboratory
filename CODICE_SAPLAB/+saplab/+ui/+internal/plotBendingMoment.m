function plotBendingMoment(Model,Axes,Field,s)

narginchk(1,4);
if isempty(Model), return; end
if isempty(Model.Results), return; end

g = Model;
colorbar(Axes,'off');

if strcmpi(Field,'MY')
    Field = 'My';
else
    Field = 'Mz';
end

if nargin == 2, s=[]; end

canvas.Axes = Axes;
canvas.Appearance = Model.Graphics.Appearance;
Model.Graphics.Appearance.LineStyle = '-';

switch g.Dim
    case 1
        r = g.Results;
        if g.Geometry.SysDim == 3
           plotTwoDBendingMoment(canvas,r,Field,s);
        elseif g.Geometry.SysDim == 6
           plotThreeDBendingMoment(canvas,r,Field,s);
        end
    otherwise
        return

end
end


function plotTwoDBendingMoment(canvas,r,f,s)

if strcmpi(f,"My"), return; end

validatestring(f,"Mz");

ndata = r.evaluateBendingMoment();
diagValues = ndata.Diagramvalues.(f);

xmax = max(abs(canvas.Axes.XLim));
ymax = max(abs(canvas.Axes.YLim));
zmax = max(abs(canvas.Axes.ZLim));

ii=max([xmax,ymax,zmax])/10;

if isempty(s), s = ii/(max(abs(cell2mat(diagValues)))); end

nr = numel(ndata.RegionID);
for i = 1:nr

    [ne,x,y,~,L]=extractRegionData(ndata,r,i);

    %formulate tensors to plot
    u = linspace(0,L,ne+1);
    v = s*diagValues{i};
    w = zeros(size(u));

    uu = [0 u u(end)];
    vv = [0 v 0];
    ww = [0 w 0];
    
    R = r.ParentModel.Geometry.evalTrasformationMatrix(i,'components');

    d = rotate3D([uu;vv;ww],R,[0,0,0]); %diagrams function
    p = rotate3D([uu;ww;ww],R,[0,0,0]); %diagrams fill pattern
    
    %form diagrams fill pattern
    patt = [d(1:2,1:ceil(numel(uu)/20):end); ...
            p(1:2,1:ceil(numel(uu)/20):end)];

    %plot diagrams
%     fill(canvas.Axes,d(1,:)+x,-d(2,:)+y,'r', 'EdgeColor', 'none','Tag','DIAGRAM','FaceAlpha',.25);
    plot(canvas.Axes,[patt(1,:);patt(3,:)]+x,-[patt(2,:);patt(4,:)]+y, 'Color','r','LineStyle', ':','Tag','DIAGRAM');
    plot(canvas.Axes,d(1,:)+x,-d(2,:)+y, 'Color', 'r','Tag','DIAGRAM');

    text(canvas.Axes,d(1,2)+x,-d(2,2)+y, [f ': ', num2str(vv(2)/s)],'FontName','Monospac821 BT','EdgeColor','k');
    text(canvas.Axes,d(1,end-1)+x,-d(2,end-1)+y, [f ': ' num2str(vv(end-1)/s)],'FontName','Monospac821 BT','EdgeColor','k');
    text(canvas.Axes,d(1,floor(end/2))+x,-d(2,floor(end/2))+y, [f ': ' num2str(vv(floor(end/2))/s)],'FontName','Monospac821 BT','EdgeColor','k');

end
end


function plotThreeDBendingMoment(canvas,r,f,s)

validatestring(f,["My","Mz"]);

ndata = r.evaluateBendingMoment();
diagValues = ndata.Diagramvalues.(f);

if isempty(s), s = 1/max(abs(cell2mat(diagValues))); end

nr = numel(ndata.RegionID);
for i = 1:nr
    
    [ne,x,y,z,L]=extractRegionData(ndata,r,i);

    %formulate tensors to plot
    u = linspace(0,L,ne+1);
    v = s*diagValues{i};
    w = zeros(size(u));

    uu = [0 u u(end)];
    vv = [0 v 0];
    ww = [0 w 0];
    
    R = r.ParentModel.Geometry.evalTrasformationMatrix(i,'components');

    d = rotate3D([uu;ww;vv],R,[0,0,0]); %diagrams function
    p = rotate3D([uu;ww;ww],R,[0,0,0]); %diagrams fill pattern
    
    %form diagrams fill pattern
    patt = [d(1:3,1:ceil(numel(uu)/16):end); ...
            p(1:3,1:ceil(numel(uu)/16):end)];

    %plot diagrams
    fill3(canvas.Axes,d(1,:)+x,d(3,:)+y,-d(2,:)+z,canvas.Appearance.DiagramFillColor, 'EdgeColor', 'none','Tag','DIAGRAM','FaceAlpha',.65);
    plot3(canvas.Axes,[patt(1,:);patt(4,:)]+x,[patt(3,:);patt(6,:)]+y,-[patt(2,:);patt(5,:)]+z, 'Color',canvas.Appearance.DiagramBorderColor,'LineStyle', ':','Tag','DIAGRAM');
    plot3(canvas.Axes,d(1,:)+x,d(3,:)+y,-d(2,:)+z,'Color', canvas.Appearance.DiagramBorderColor,'Tag','DIAGRAM');

end
end


function [ne,x,y,z,L]=extractRegionData(n,r,i)
    e  = n.Elements{i};
    ne = numel(e);
    n = r.Mesh.Elements(1,e(1));
    x = r.Mesh.Nodes(1,n);
    y = r.Mesh.Nodes(2,n);
    z = r.Mesh.Nodes(3,n);    
    L = r.Mesh.h(e);
    L = sum(L);
end

