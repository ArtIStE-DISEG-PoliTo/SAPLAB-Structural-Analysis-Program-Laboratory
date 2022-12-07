function updateLayersAnalysis(app)

model = app.MODEL;

delete(app.Tree.Children);

if isempty(app.MODEL)
    return;
end

addpath('icons\');

%icons
warning off;
genDataIcon = struct(matlab.ui.internal.toolstrip.Icon.SET_PATH_16).ImageSource;
attrIcon = struct(matlab.ui.internal.toolstrip.Icon.COMPARE_16).ImageSource;

genData = uitreenode(app.Tree,'Text','General Data (3)','Icon',genDataIcon);
uitreenode(genData,'Text',['File Name: ' app.PREFERENCES.NAME],'Icon',attrIcon);
uitreenode(genData,'Text',['Project Title: ' app.PREFERENCES.PTITLE],'Icon',attrIcon);
uitreenode(genData,'Text',['Analysis: ' app.PREFERENCES.ANALYSIS],'Icon',attrIcon);
mTree = uitreenode(app.Tree,'Text','Structural Model (2)','Icon',genDataIcon);
gem = uitreenode(mTree,'Text','Geometry And Mesh (2)','Icon',attrIcon);

attr = sap.internal.importAnalysisAttributes(app.MODEL.AnalysisType);
layer = uitreenode(mTree,'Text',['Model Attributes (', num2str(numel(attr)) ')'],'Icon',attrIcon);


for i = 1:numel(attr)
    uitreenode(layer,'Text',attr{i},'Icon','props_01.png','Tag',attr{i});
end
if isempty(model), return; end

%% geometry node
if ~isempty(model.Geometry)
    geometry= uitreenode(gem,'Text','Geometry','Icon',attrIcon);
    if isprop(model.Geometry,'NumPoints')
        if or(~isempty(model.Geometry.NumPoints),model.Geometry.NumPoints > 0)
            points = uitreenode(geometry,'Text','Points','Icon','unknownicon.gif');
            for i=1:model.Geometry.NumPoints
                uitreenode(points,'Text',[num2str(i) ': Point ', num2str(i)],'ContextMenu',app.ContextMenu,'UserData',model.Geometry.GeometricBoundaries(i,:));
            end
        end
        points.Text = ['Points (', num2str(numel(points.Children)), ')'];
        if or(~isempty(model.Geometry.NumLines),model.Geometry.NumLines > 0)
            lines = uitreenode(geometry,'Text','Straight Lines','Icon','unknownicon.gif');
            model.Geometry.NumLines
            for i=1:model.Geometry.NumLines
                uitreenode(lines,'Text',[num2str(i) ': Line ', num2str(i)],'ContextMenu',app.ContextMenu,'UserData',model.Geometry.GeometricDomain(i,:));
            end
        end
        lines.Text = ['Straight Lines (', num2str(numel(lines.Children)), ')'];
    else
        if ~isempty(model.Geometry.csgdb.tag)
            primco = uitreenode(geometry,'Text','Primitives/Composite Objects','Icon','unknownicon.gif');
            for i=1:numel(model.Geometry.csgdb.tag)
                uitreenode(primco,'Text',[num2str(i) ': Tag: ', model.Geometry.csgdb.tag{i}],'Icon','line02.png','ContextMenu',app.ContextMenu);
            end
        end

        if ~isempty(model.Geometry.geom)
            defgeo = uitreenode(geometry,'Text','Default Geometry','Icon','unknownicon.gif');
            uitreenode(defgeo,'Text',[num2str(1) ': Tag: ', model.Geometry.geomTag],'Icon','line02.png','ContextMenu',app.ContextMenu);
            uitreenode(defgeo,'Text',[num2str(2) ': Number of Vertices: ', num2str(model.Geometry.NumVertices)],'Icon','line02.png','ContextMenu',app.ContextMenu);
            uitreenode(defgeo,'Text',[num2str(3) ': Number of Edges: ', num2str(model.Geometry.NumEdges)],'Icon','line02.png','ContextMenu',app.ContextMenu);
            uitreenode(defgeo,'Text',[num2str(4) ': Number of Faces: ', num2str(model.Geometry.NumFaces)],'Icon','line02.png','ContextMenu',app.ContextMenu);
        end
    end
    geometry.Text = ['Geometry (' num2str(numel(geometry.Children)) ')'];
end

%end geometry node

%% material properties node
if ~isempty(model.MaterialProperties)
    material=findobj(app.Tree,'Tag','MaterialProperties');
    for i = 1:numel(model.MaterialProperties.MaterialPropertiesAssignments)
        matAss = model.MaterialProperties.MaterialPropertiesAssignments(i);
        tRegion = matAss.RegionType;
        nRegion = matAss.RegionID;
        uitreenode(material,'Text',char([num2str(i) ': Properties Assigned To ', char(tRegion), ' ',num2str(nRegion)]),'Icon','material01.png','ContextMenu',app.ContextMenu,'UserData',matAss);
    end
    material.Text = [material.Text, ' (', num2str(numel(material.Children)) ')'];
end

%% section properties node
if isprop(model,'SectionProperties')
    section=findobj(app.Tree,'Tag','SectionProperties');
    if ~isempty(model.SectionProperties)
        for i = 1:numel(model.SectionProperties.SectionPropertiesAssignments)
            matAss = model.SectionProperties.SectionPropertiesAssignments(i);
            tRegion = matAss.RegionType;
            nRegion = matAss.RegionID;
    
            uitreenode(section,'Text',char([num2str(i) ': Properties Assigned To ', char(tRegion), ' ',num2str(nRegion)]),'Icon','section01.png','ContextMenu',app.ContextMenu);
        end
        section.Text = [section.Text, ' (', num2str(numel(section.Children)) ')'];
    end
    
end

if (~isempty(model.BoundaryConditions))
    boundCons =findobj(app.Tree,'Tag','BoundaryConditions');
    constr = uitreenode(boundCons,'Text','Constraint','Icon','unknownicon.gif');
    boundForces = uitreenode(boundCons,'Text','Boundary Forces','Icon','unknownicon.gif');
    boundMoms = uitreenode(boundCons,'Text','Boundary Moments','Icon','unknownicon.gif');
    boundDispl = uitreenode(boundCons,'Text','Enforced Displacements','Icon','unknownicon.gif');
    boundRotat = uitreenode(boundCons,'Text','Enforced Rotations','Icon','unknownicon.gif');
    boundPress = uitreenode(boundCons,'Text','Pressure','Icon','unknownicon.gif');
    for i=1:numel(model.BoundaryConditions.BoundaryConditionAssignments)
        bcAss = model.BoundaryConditions.BoundaryConditionAssignments(i);
        tRegion = bcAss.RegionType;
        nRegion = bcAss.RegionID;
        if ~isempty(bcAss.Constraint)
            uitreenode(constr,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - Constraint: ', char(bcAss.Constraint)], 'Icon', 'bc01.png')
        end
        if ~isempty(bcAss.XForce) 
            uitreenode(boundForces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - FX: ', num2str(bcAss.XForce)], 'Icon', 'bc02.png')
        end
        if ~isempty(bcAss.YForce) 
            uitreenode(boundForces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - FY: ', num2str(bcAss.YForce)], 'Icon', 'bc02.png')
        end
        if ~isempty(bcAss.ZForce) 
            uitreenode(boundForces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - FZ: ', num2str(bcAss.ZForce)], 'Icon', 'bc02.png')
        end
        if ~isempty(bcAss.XMoment) 
            uitreenode(boundMoms,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - MX: ', num2str(bcAss.XMoment)], 'Icon', 'bc02.png')
        end
        if ~isempty(bcAss.YMoment) 
            uitreenode(boundMoms,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - MY: ', num2str(bcAss.YMoment)], 'Icon', 'bc02.png')
        end
        if ~isempty(bcAss.ZMoment) 
            uitreenode(boundMoms,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - MZ: ', num2str(bcAss.ZMoment)], 'Icon', 'bc02.png')
        end


        if ~isempty(bcAss.XDisplacement) 
            uitreenode(boundDispl,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - UX: ', num2str(bcAss.XDisplacement)], 'Icon', 'bc03.png')
        end
        if ~isempty(bcAss.YDisplacement) 
            uitreenode(boundDispl,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - UY: ', num2str(bcAss.YDisplacement)], 'Icon', 'bc03.png')
        end
        if ~isempty(bcAss.ZDisplacement) 
            uitreenode(boundDispl,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - UZ: ', num2str(bcAss.ZDisplacement)], 'Icon', 'bc03.png')
        end
        if ~isempty(bcAss.XRotation) 
            uitreenode(boundRotat,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - ROTX: ', num2str(bcAss.XRotation)], 'Icon', 'bc03.png')
        end
        if ~isempty(bcAss.YRotation) 
            uitreenode(boundRotat,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - ROTY: ', num2str(bcAss.YRotation)], 'Icon', 'bc03.png')
        end
        if ~isempty(bcAss.ZRotation) 
            uitreenode(boundRotat,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - ROTZ: ', num2str(bcAss.ZRotation)], 'Icon', 'bc03.png')
        end
        if ~isempty(bcAss.Pressure) 
            uitreenode(boundPress,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - Pressure: ', num2str(bcAss.Pressure)], 'Icon', 'bc03.png')
        end

    end
end

%% distributed loads node
if isprop(model,'DistributedLoads')
    if ~isempty(model.DistributedLoads)
        distLoads = findobj(app.Tree,'Tag','DistributedLoads');
        forces = uitreenode(distLoads,'Text','Forces Loads','Icon','unknownicon.gif');
        moms   = uitreenode(distLoads,'Text','Moments Loads','Icon','unknownicon.gif');

        for k=1:numel(model.DistributedLoads.DistributedLoadsAssignments)
            dLoads = model.DistributedLoads.DistributedLoadsAssignments(k);
            tRegion = dLoads.RegionType;
            nRegion = dLoads.RegionID;

            i = numel(forces.Children)+1;
            j = numel(moms.Children)+1;
            if ~isempty(dLoads.XForce)
                uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qx: ', num2str(dLoads.XForce)], 'Icon', 'distributed01.png');
                i=numel(forces.Children)+1;
            end
            if ~isempty(dLoads.YForce)
                uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qy: ', num2str(dLoads.YForce)], 'Icon', 'distributed01.png');
                i=numel(forces.Children)+1;
            end
            if ~isempty(dLoads.ZForce)
                uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qz: ', num2str(dLoads.ZForce)], 'Icon', 'distributed01.png');
                i=numel(forces.Children)+1;
            end
            if ~isempty(dLoads.XMoment)
                uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - mx: ', num2str(dLoads.XMoment)], 'Icon', 'distributed01.png');
                j=numel(moms.Children)+1;
            end
            if ~isempty(dLoads.YMoment)
                uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - my: ', num2str(dLoads.XMoment)], 'Icon', 'distributed01.png');
               j=numel(moms.Children)+1;
            end
            if ~isempty(dLoads.ZMoment)
                uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - mz: ', num2str(dLoads.XMoment)], 'Icon', 'distributed01.png');
                j=numel(moms.Children)+1;
            end

            if ~isempty(dLoads.Force)
                nForce = numel(dLoads.Force);
                if nForce == 1 && dLoads.Force(1) ~= 0
                    uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qx: ', num2str(dLoads.XForce)], 'Icon', 'distributed01.png');
                end
                if nForce == 2
                    if dLoads.Force(1) ~= 0
                    uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qx: ', num2str(dLoads.XForce)], 'Icon', 'distributed01.png');
                    end
                    if dLoads.Force(2) ~= 0
                    uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qy: ', num2str(dLoads.YForce)], 'Icon', 'distributed01.png');
                    end
                end
                if nForce == 3
                    if dLoads.Force(1) ~= 0
                    uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qx: ', num2str(dLoads.XForce)], 'Icon', 'distributed01.png');
                    end
                    if dLoads.Force(2) ~= 0
                    uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qy: ', num2str(dLoads.YForce)], 'Icon', 'distributed01.png');
                    end
                    if dLoads.Force(3) ~= 0
                    uitreenode(forces,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - qz: ', num2str(dLoads.ZForce)], 'Icon', 'distributed01.png');
                    end
                end
            end     
            if ~isempty(dLoads.Moment)
                nForce = numel(dLoads.Moment);
                if nForce == 1 && dLoads.Moment(1) ~= 0
                    uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - mx: ', num2str(dLoads.XMoment)], 'Icon', 'distributed01.png');
                end
                if nForce == 2
                    if dLoads.Moment(1) ~= 0
                    uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - mx: ', num2str(dLoads.XMoment)], 'Icon', 'distributed01.png');
                    end
                    if dLoads.Moment(2) ~= 0
                    uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - my: ', num2str(dLoads.YMoment)], 'Icon', 'distributed01.png');
                    end
                end
                if nForce == 3
                    if dLoads.Moment(1) ~= 0
                    uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - mx: ', num2str(dLoads.XMoment)], 'Icon', 'distributed01.png');
                    end
                    if dLoads.Moment(2) ~= 0
                    uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - my: ', num2str(dLoads.YMoment)], 'Icon', 'distributed01.png');
                    end
                    if dLoads.Moment(3) ~= 0
                    uitreenode(moms,'Text',[num2str(j), ': ' , char(tRegion), ' ', num2str(nRegion), ' - mz: ', num2str(dLoads.ZMoment)], 'Icon', 'distributed01.png');
                    end
                end
            end 
        end
        forces.Text = [forces.Text, ' (', num2str(numel(forces.Children)) ')'];
        moms.Text = [moms.Text, ' (', num2str(numel(moms.Children)) ')'];
        distLoads.Text = [distLoads.Text, ' (', num2str(numel(distLoads.Children)) ')'];
    end
end

if ~isempty(model.BodyLoads)
    bodyLoads = uitreenode(layer,'Text','Body Loads','Icon','unknownicon.gif');
    g = uitreenode(bodyLoads,'Text','Gravitational','Icon','unknownicon.gif');
    t   = uitreenode(bodyLoads,'Text','Temperature','Icon','unknownicon.gif');

    for i = 1:numel(model.BodyLoads.BodyLoadsAssignments)
        bLoads = model.BodyLoads.BodyLoadsAssignments(i);
        tRegion = bLoads.RegionType;
        nRegion = bLoads.RegionID;      
        if ~isempty(bLoads.GravitationalAcceleration)
            uitreenode(g,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - g: ', num2str(bLoads.GravitationalAcceleration)], 'Icon', 'bc03.png');
        end    
        if ~isempty(bLoads.Temperature)
            uitreenode(t,'Text',[num2str(i), ': ' , char(tRegion), ' ', num2str(nRegion), ' - T: ', num2str(bLoads.Temperature)], 'Icon', 'thermal01.png');
        end  
    end
end

if ~isempty(model.Mesh)
    mesh = uitreenode(layer,'Text','Mesh','Icon','unknownicon.gif');
    uitreenode(mesh,'Text',['Nodes: ' num2str(size(model.Mesh.Nodes,2))],'Icon','unknownicon.gif');
    uitreenode(mesh,'Text',['Elements: ' num2str(size(model.Mesh.Elements,2))],'Icon','unknownicon.gif');
end
warning on;
 expand(app.Tree,'all');
end