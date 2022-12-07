function pointID = addpoint(m, coordinates)
%ADDPOINT Aggiungi un punto alla geometria del modello strutturale

if ~isa(m,'sap.FEModel')
    error('Invalid structural model object.');
end

%init the geometry
m.initGeometry();

cd = size(coordinates,2);
np = size(coordinates,1);
if cd > 3 || ~isnumeric(coordinates)
    error('Invalid coordinates format.');
end

coordinates = [coordinates, zeros(np,3-cd)];

pointID = zeros(np,1);
try
    for i=1:np
        pointID(i) = m.Geometry.generatePoint(coordinates(i,:),'boundary');
    end
catch ME
    throw(ME);
end

end