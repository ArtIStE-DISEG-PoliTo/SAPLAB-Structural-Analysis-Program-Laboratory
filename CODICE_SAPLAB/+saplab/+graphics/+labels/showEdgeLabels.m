function showEdgeLabels(ax, m, OnOff)
%showEdgeLabels display the edge labels

if strcmpi(OnOff,'on') 
    
    if isa(m,'sap.StructuralModel')
        if ~contains(m.AnalysisType, 'frame')
            g = m.Geometry.geom;
        else
            return;
        end
    else
        g = m;
    end
    
    %get the label string text
    fig = figure('Visible','off'); 
    pdegplot(g, 'EdgeLabels', 'on');
    EdgeLabels = findall(gca, 'Type', 'Text');
    for ii =1:numel(EdgeLabels)
        EdgeLabels(ii).FontSize = 11;
        EdgeLabels(ii).FontWeight = 'normal';
        EdgeLabels(ii).Color = 'k';
        EdgeLabels(ii).Tag = 'EDGELABELS';
    end
    copyobj(EdgeLabels, ax);
    delete(fig);
else
    return;
end
end
