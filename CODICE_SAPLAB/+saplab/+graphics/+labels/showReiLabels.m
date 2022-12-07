function showReiLabels(ax, m, OnOff)
    if isempty(m)
        return
    end
    if ~isprop(m, 'StructuralReinforcement')
        return
    end
    if strcmpi(OnOff,'off')
        return;
    end
    GeomTag = m.Geometry.geomTag;
    if isempty(m.StructuralReinforcement)
        return
    end
    for i = 1:numel(m.StructuralReinforcement.StructuralReinforcementAssignments)
        ThisRei = m.StructuralReinforcement.StructuralReinforcementAssignments(i);
        EdgeID  = ThisRei.RegionID;
        gObject = findobj(ax,'Tag', [GeomTag, ' - Edge ' num2str(EdgeID)]);
        Data    = [gObject.XData; gObject.YData];
        numData = size(Data,2);
        pos     = ceil(.75*numData);
        x       = Data(1,pos);
        y       = Data(2,pos);
        text(ax,x,y,['R', num2str(i)],'HorizontalAlignment','center','VerticalAlignment','bottom',...
            'Color',[0,0,0],'Tag','REINFORCEMENTLABELS');
    end
end