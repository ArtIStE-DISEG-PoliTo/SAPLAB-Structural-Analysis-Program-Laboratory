function mplot(m, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p = inputParser();
addParameter(p,'ElementLabels',[]);
addParameter(p,'NodeLabels',[]);
addParameter(p,'FRPElementLabels',[]);
addParameter(p,'FRPNodeLabels',[]);
addParameter(p,'p',[]);
addParameter(p,'t',[]);
addParameter(p,'Parent',[]);
parse(p, varargin{:});

if isempty(p.Results.Parent)
    ax = gca;
else
    ax = p.Results.Parent;
end
cla(ax);
pr = p.Results;

if isempty(m.Mesh)
     error('Model does not have mesh properties');
end
 
if contains(m.AnalysisType, 'frame')
   
   p = m.Mesh.Nodes;
   t = m.Mesh.Elements;
   
   %plot nodes
   X = p(1,:);
   Y = p(2,:);
   Z = p(3,:);
   
   Xe = X(t);
   Ye = Y(t);
   Ze = Z(t);

   if contains(m.AnalysisType, 'plane')
      plot(X,Y,'ob','Parent',ax,'MarkerSize',3.5);
      hold(ax,'on')
      plot(Xe,Ye,'-b','Parent',ax);
   else
      plot3(X,Y,Z,'ob','Parent',ax,'MarkerSize',3.5);
      hold(ax,'on')
      plot3(Xe,Ye,Ze,'-b','Parent',ax);
   end

   if ~isempty(pr.NodeLabels)
      labels = 'n' + string(1:numel(X)); 
      labels = cellstr(labels');
      text(ax,X,Y,Z,labels,'FontSmoothing','off','HorizontalAlignment','center')
   end
   
   xm = mean(Xe,1);
   ym = mean(Ye,1);
   zm = mean(Ze,1);

   if ~isempty(pr.ElementLabels)
      labels = 'e' + string(1:size(t,2)); 
      labels = cellstr(labels');
      text(ax,xm,ym,zm,labels,'FontSmoothing','off','HorizontalAlignment','center')
   end
    axis(ax,'equal');
    axis(ax,'tight')
    box(ax,'off');  
else
    if ~contains(m.AnalysisType, 'coupled')
        p = m.Mesh.Nodes;

        X = p(1,:);
        Y = p(2,:);
       
        TR = triangulation(m.Mesh.Elements',[X(:) Y(:)]);
        POLYOUT = boundaryshape(TR);
        triplot(TR,'Parent',ax,'Color',[.5,.5,.5])
        hold(ax,'on');
        plot(POLYOUT,'FaceAlpha',0,'EdgeColor','r','LineWidth',1);

        if ~isempty(pr.NodeLabels)
          labels = 'n' + string(1:numel(X)); 
          text(ax,X,Y,labels,'FontSmoothing','off','HorizontalAlignment','center')
        end
        Xm = mean(X(m.Mesh.Elements),1);
        Ym = mean(Y(m.Mesh.Elements),1);

        if ~isempty(pr.ElementLabels)
          labels = 'e' + string(1:numel(Xm)); 
          text(ax,Xm,Ym,labels,'FontSmoothing','off','HorizontalAlignment','center')
        end
        axis(ax,'equal');
        axis(ax,'tight')
        box(ax,'off');  
    else
        tri = find(m.Mesh.Elements(3,:)~=0);
        p = m.Mesh.Nodes;

        X = p(1,:);
        Y = p(2,:);
        
        t = m.Mesh.Elements(:,tri);
        warning off
        TR = triangulation(t',[X(:) Y(:)]);
        warning on
        POLYOUT = boundaryshape(TR);
        triplot(TR,'Parent',ax,'Color',[.5,.5,.5])
        hold(ax,'on');
        plot(POLYOUT,'FaceAlpha',0,'EdgeColor','r','LineWidth',1);

        if ~isempty(pr.NodeLabels)
          labels = 'n' + string(1:numel(X)); 
          text(ax,X,Y,labels,'FontSmoothing','off','HorizontalAlignment','center')
        end
        Xm = mean(X(t),1);
        Ym = mean(Y(t),1);

        if ~isempty(pr.ElementLabels)
          labels = 'e' + string(1:numel(Xm)); 
          text(ax,Xm,Ym,labels,'FontSmoothing','off','HorizontalAlignment','center')
        end      

        if isempty(m.StructuralReinforcement)
           return;
        else
            rei = m.StructuralReinforcement.StructuralReinforcementAssignments;
            findReiNodes = [];
            findReiElems = [];
            for i=1:numel(rei)
                findReiNodes = [findReiNodes, saplab.findFRPInMesh(m.Mesh,'Parameter','Node','Reinforcement',i)];  %#ok
                findReiElems = [findReiElems, saplab.findFRPInMesh(m.Mesh,'Parameter','Element','Reinforcement',i)]; %#ok
            end
            p = m.Mesh.Nodes;
            t = m.Mesh.Elements([1,2],findReiElems);

           %plot nodes
           X = p(1,:);
           Y = p(2,:);
           
           Xe = X(t);
           Ye = Y(t);
           p = m.Mesh.Nodes(:,findReiNodes);

           %plot nodes
           X = p(1,:);
           Y = p(2,:);

           plot(X,Y,'ob','Parent',ax,'MarkerSize',3.5);
           hold(ax,'on')
           plot(Xe,Ye,'-b','Parent',ax,'LineWidth',1.25);

           if ~isempty(pr.FRPNodeLabels)
              labels = 'n' + string(findReiNodes(1):findReiNodes(end)); 
              labels = cellstr(labels');
              text(ax,X,Y,labels,'FontSmoothing','off','HorizontalAlignment','center')
           end
           
           xm = mean(Xe,1);
           ym = mean(Ye,1);
        
           if ~isempty(pr.FRPElementLabels)
              labels = 'e' + string(findReiElems(1):findReiElems(end)); 
              labels = cellstr(labels');
              text(ax,xm,ym,labels,'FontSmoothing','off','HorizontalAlignment','center')

           end
        end
        axis(ax,'equal');
        axis(ax,'tight')
        box(ax,'off');  
    end

end