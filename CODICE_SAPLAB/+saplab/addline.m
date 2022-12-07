function lineID = addline(m,opt,varargin)
%ADDLINE Aggiungi segmento lineare alla geometria del modello
%   Detailed explanation goes here

narginchk(3,4);

if ~isa(m,'sap.FEModel')
    error('Invalid structural model object.');
end

%init the geometry
m.initGeometry();

%validate opt string
validatestring(opt,["Coordinates","Connect"]);

if strcmpi(opt,'Coordinates')

    p1 = varargin{1};
    p2 = varargin{2};

    nl1 = size(p1,1);
    nl2 = size(p2,1);
    nsz1 = size(p1,2);
    nsz2 = size(p2,2);

    if nl1 ~= nl2
        error('Coordinates size does not match.');
    end

    nl = nl1;

    p1 = [p1,zeros(nl,3-nsz1)];
    p2 = [p2,zeros(nl,3-nsz2)];

    lineID = zeros(nl,1);
    for i=1:nl
        [~,lineID(i)] = generateLine(m.Geometry,p1(i,:),p2(i,:));
    end

else
    conn = varargin{1};

    if size(conn,2)~=2
        error('Invalid connectivity list format');
    end

    nc = size(conn,1);
    lineID = zeros(nc,1);
    for i=1:nc
        pi1=conn(i,1);
        pi2=conn(i,2);

        gbounds = m.Geometry.('GeometricBoundaries');
        xyz1 = gbounds(pi1,1:3);
        xyz2 = gbounds(pi2,1:3);

        [~,lineID(i)] = generateLine(m.Geometry,xyz1,xyz2);
    end
end

end


