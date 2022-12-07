function showVertexLabels(ax, m, OnOff)
%showVertexLabels display the vertex labels

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
    pdegplot(g, 'VertexLabels', 'on');
    VertexLabels = findall(gca, 'Type', 'Text');
    for ii =1:numel(VertexLabels)
        VertexLabels(ii).FontSize = 11;
        VertexLabels(ii).FontWeight = 'normal';
        VertexLabels(ii).Color = 'k';
        VertexLabels(ii).Tag = 'VERTEXLABELS';
    end
    copyobj(VertexLabels, ax);
    delete(fig);
else
    return;
end
end
