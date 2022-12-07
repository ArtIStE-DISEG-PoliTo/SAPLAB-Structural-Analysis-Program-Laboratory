function R = elinSolver(m)
%ELINSOLVER Solve elastic linear models

try
checkModel(m);
checkFrameModels(m);
checkPlaneModels(m);
checkCoupledModels(m);

R = m.solve();
catch ME
    throw(ME);  
end
end
function checkModel(m)
   if isempty(m), error('Empty model.'); end
   if ~isa(m,'sap.FEModel'), error('Invalid structural model object.'); end
   if isempty(m.Geometry), error('Model does not have geometry.'); end
end

function checkFrameModels(m)
     if ~contains(m.AnalysisType,'frame')
         return;
     end
     nRegion = m.Geometry.NumLines;
     %check Materials
     if (numel(m.MaterialProperties.MaterialPropertiesAssignments) < nRegion)
         error('Some line regions with no material properties');
     end
     if (numel(m.SectionProperties.SectionPropertiesAssignments) < nRegion)
         error('Some line regions with no section properties');
     end
     if isempty(m.BoundaryConditions)
        error('Rigid body motions not fully restrained.Specify appropriate boundary conditions to restrain all rigid body motions of the model.')
     end
end

function checkPlaneModels(m)
     if contains(m.AnalysisType,'frame')
         return;
     end
     nRegion = m.Geometry.NumFaces;
     if isempty(m.MaterialProperties)
        error('StructuralModel does not have material properties.')
     end
     %check Materials
     if (numel(m.MaterialProperties.MaterialPropertiesAssignments) < nRegion)
         error('Some face regions with no material properties');
     end
     if isempty(m.BoundaryConditions)
        error('Rigid body motions not fully restrained. Specify appropriate boundary conditions to restrain all rigid body motions of the model.')
     end
end

function checkCoupledModels(m)
     if ~contains(m.AnalysisType,'coupled')
         return;
     end
     nRegion = m.Geometry.NumFaces;
     %check Materials
     if (numel(m.MaterialProperties.MaterialPropertiesAssignments) < nRegion)
         error('Some line regions with no material properties');
     end
     if isempty(m.BoundaryConditions)
        error('Rigid body motions not fully restrained. Specify appropriate boundary conditions to restrain all rigid body motions of the model.')
     end
     if isempty(m.StructuralReinforcement) && ~isempty(m.StructuralFEInterface)
        error('No structural reinforcement found.')
     end

end
