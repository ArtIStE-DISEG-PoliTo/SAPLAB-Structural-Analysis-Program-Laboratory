function attr = importAnalysisAttributes(analysisTypeAttributes)

if (startsWith('static-planeframe', analysisTypeAttributes, 'IgnoreCase', true))
    attr= {'MaterialProperties';'SectionProperties'; ...
            'DistributedLoads';'BodyLoads';'BoundaryConditions';'ReleaseConditions';'Results'};  
elseif (startsWith('static-spaceframe', analysisTypeAttributes, 'IgnoreCase', true))
    attr= {'MaterialProperties';'SectionProperties'; ...
            'DistributedLoads';'BodyLoads';'BoundaryConditions';'ReleaseConditions';'Results'};  
elseif (startsWith('static-planestress', analysisTypeAttributes, 'IgnoreCase', true))
    attr= {'MaterialProperties';...
            'BodyLoads';'BoundaryConditions';'Results'};   
elseif (startsWith('static-planestrain', analysisTypeAttributes, 'IgnoreCase', true))
    attr= {'MaterialProperties';...
            'BodyLoads';'BoundaryConditions';'Results'};  
elseif (startsWith('coupled-static-planestress', analysisTypeAttributes, 'IgnoreCase', true))
    attr= {'MaterialProperties';'StructuralReinforcement'; 'StructuralFEInterface';...
            'BodyLoads';'BoundaryConditions';'Results'};   
else
    attr= {'MaterialProperties';'SectionProperties'; ...
            'DistributedLoads';'BodyLoads';'BoundaryConditions';'ReleaseConditions','Results'};                    
end
end