function showFaceLabels(ax, m, OnOff)
%showFaceLabels display the face labels

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
    pdegplot(g, 'FaceLabels', 'on');
    FaceLabels = findall(gca, 'Type', 'Text');
    for ii =1:numel(FaceLabels)
        FaceLabels(ii).FontSize = 11;
        FaceLabels(ii).FontWeight = 'normal';
        FaceLabels(ii).Color = 'r';
        FaceLabels(ii).Tag = 'FACELABELS';
    end
    copyobj(FaceLabels, ax);
    delete(fig);
else
    return;
end
end
