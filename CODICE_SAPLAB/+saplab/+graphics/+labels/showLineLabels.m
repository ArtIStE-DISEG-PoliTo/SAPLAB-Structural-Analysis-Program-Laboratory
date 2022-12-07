function showLineLabels(ax, m, OnOff)
%showLineLabels display the line labels

if strcmpi(OnOff,'on') && contains(m.AnalysisType,'frame')

fxyz = m.Geometry.GeometricDomain;

appearance = m.Graphics.Appearance;

xyzloc = unique(fxyz(:,11:13), "rows","stable");
labels = 'L'+string(1:size(xyzloc,1)); 
labels = cellstr(labels'); 

%plot labels
text(ax,xyzloc(:,1),xyzloc(:,2),xyzloc(:,3),labels,'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'Color','k','Tag','LINELABELS','FontName','Times New Romans','FontAngle','italic','FontSize',12);
    
else
    return;
end