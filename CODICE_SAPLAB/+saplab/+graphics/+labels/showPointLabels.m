function showPointLabels(ax, m, OnOff)
%showPointLabels display the line labels

if strcmpi(OnOff,'on') && contains(m.AnalysisType,'frame')

appearance = m.Graphics.Appearance;

fxyz = m.Geometry.GeometricBoundaries;
fxyz(fxyz(:,5)==1,:) = [];

xyzloc = unique(fxyz(:,1:3), "rows", "stable");
labels = 'P'+string(1:size(xyzloc,1)); 
labels = cellstr(labels'); 

text(ax,xyzloc(:,1),xyzloc(:,2),xyzloc(:,3),labels,'HorizontalAlignment','left','VerticalAlignment','bottom',...
    'Color',appearance.PointLabelColor,'FontSize',12,'Tag','POINTLABELS','FontName','Times New Romans','FontAngle','italic');

    
else
    return;
end