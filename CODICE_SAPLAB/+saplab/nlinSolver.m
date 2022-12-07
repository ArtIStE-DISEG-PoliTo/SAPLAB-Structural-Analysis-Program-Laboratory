function R = nlinSolver(m)
%NLINSOLVER Solve non linear models
step = 3;
tol = 1e-3;
try
    checkModel(m);
    checkCoupledModels(m);
    R = MNOsolve(m,'Step',step,'Tolerance',tol);
    m.SolverType = 'Nonlinear';
catch ME
    throw(ME);
end
end

function checkModel(m)
   if isempty(m), error('Empty model.'); end
   if ~isa(m,'sap.FEModel'), error('Invalid structural model object.'); end
   if isempty(m.Geometry), error('Model does not have geometry.'); end
end


function checkCoupledModels(m)
     if ~contains(m.AnalysisType,'coupled')
         error('saplab.nlinSolver can only be used for "coupled-static-planestress" analysis.')
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
