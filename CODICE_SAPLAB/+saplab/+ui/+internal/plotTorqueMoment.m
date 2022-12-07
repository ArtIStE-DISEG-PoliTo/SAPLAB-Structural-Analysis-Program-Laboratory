function plotTorqueMoment(Model,Axes,s)

narginchk(0,3);
if isempty(Model), return; end
if isempty(Model.Results), return; end
g = Model;

colorbar(Axes,'off');

if nargin < 3, s=[]; end
canvas.Axes = Axes;
canvas.Appearance = Model.Graphics.Appearance;
Model.Graphics.Appearance.LineStyle = '-';
switch g.Dim
    case 1       
        r = g.Results;
        if g.Geometry.SysDim == 3
           return
        elseif g.Geometry.SysDim == 6
           plotThreeDAxialForces(canvas,r,s); 
        end
    otherwise
        return

end
end


function plotTwoDAxialForces(canvas,r,s)
    
ndata = r.evaluateAxialForces();
diagValues = ndata.Diagramvalues.Fx;

xmax = max(abs(canvas.Axes.XLim));
ymax = max(abs(canvas.Axes.YLim));
zmax = max(abs(canvas.Axes.ZLim));

ii=max([xmax,ymax,zmax])/100;

if isempty(s), s = ii/2*max(abs(cell2mat(diagValues))); end

nr = numel(ndata.RegionID);
for i = 1:nr

    [ne,x,y,~,L]=extractRegionData(ndata,r,i);

    %formulate tensors to plot
    u = linspace(0,L,ne);
    v = s*diagValues{i};
    w = zeros(size(u));

    uu = [0 u u(end)];
    vv = [0 v 0];
    ww = [0 w 0];
    
    R = r.ParentModel.Geometry.evalTrasformationMatrix(i,'components');

    d = rotate3D([uu;vv;ww],R,[0,0,0]); %diagrams function
    p = rotate3D([uu;ww;ww],R,[0,0,0]); %diagrams fill pattern
    
    %form diagrams fill pattern
    patt = [d(1:2,1:ceil(numel(uu)/16):end); ...
            p(1:2,1:ceil(numel(uu)/16):end)];

    %plot diagrams
    fill(canvas.Axes,d(1,:)+x,-d(2,:)+y,'r', 'EdgeColor', 'none','Tag','DIAGRAM','FaceAlpha',.55);
    plot(canvas.Axes,[patt(1,:);patt(3,:)]+x,-[patt(2,:);patt(4,:)]+y, 'Color','r','LineStyle', ':','Tag','DIAGRAM');
    plot(canvas.Axes,d(1,:)+x,-d(2,:)+y, 'Color', 'r','Tag','DIAGRAM');

    text(canvas.Axes,d(1,2)+x,-d(2,2)+y, ['Nx: ' num2str(vv(2)/s)],'FontName','Monospac821 BT','EdgeColor','k');
    text(canvas.Axes,d(1,end-1)+x,-d(2,end-1)+y, ['Nx: ' num2str(vv(end-1)/s)],'FontName','Monospac821 BT','EdgeColor','k');
    
end
end


function plotThreeDAxialForces(canvas,r,s)
    
ndata = r.evaluateTorqueMoment();
diagValues = ndata.Diagramvalues.Mx;

xmax = max(abs(canvas.Axes.XLim));
ymax = max(abs(canvas.Axes.YLim));
zmax = max(abs(canvas.Axes.ZLim));

ii=max([xmax,ymax,zmax])/10;

if isempty(s), s = ii/max(abs(cell2mat(diagValues))); end

nr = numel(ndata.RegionID);
for i = 1:nr
    
    [ne,x,y,z,L]=extractRegionData(ndata,r,i);

    %formulate tensors to plot
    u = linspace(0,L,ne);
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
%     fill3(canvas.Axes,d(1,:)+x,d(3,:)+y,-d(2,:)+z,'r', 'EdgeColor', 'none','Tag','DIAGRAM','FaceAlpha',.55);
    plot3(canvas.Axes,[patt(1,:);patt(4,:)]+x,[patt(3,:);patt(6,:)]+y,-[patt(2,:);patt(5,:)]+z, 'Color','r','LineStyle', ':','Tag','DIAGRAM');
    plot3(canvas.Axes,d(1,:)+x,d(3,:)+y,-d(2,:)+z,'Color', 'r','Tag','DIAGRAM');

    text(canvas.Axes,d(1,2)+x,-d(3,2)+y, -d(2,2)+z,['Nx: ' num2str(vv(2)/s)],'FontName','Monospac821 BT','EdgeColor','k');
    text(canvas.Axes,d(1,end-1)+x,-d(3,end-1)+y, -d(2,end-1)+z, ['Nx: ' num2str(vv(end-1)/s)],'FontName','Monospac821 BT','EdgeColor','k');


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