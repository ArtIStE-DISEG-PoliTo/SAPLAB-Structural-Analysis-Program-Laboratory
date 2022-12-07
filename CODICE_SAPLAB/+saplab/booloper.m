function tag = booloper(self,sf,varargin)

narginchk(2,4);
nargoutchk(0,2);

if isempty(self.Geometry)
    error('Model does not have geometry.')
end

gdata = self.Geometry.csgdb;
evalsfg = getsf(sf); %get the tag in the sf
coflag_ = zeros(size(evalsfg,1),1); %flag to search the co in sf.

for ii = 1:size(evalsfg,1)
    coflag_(ii,:) = contains(evalsfg(ii,:), 'CO');
end
coflag = find(coflag_ == 1 , 1); %check if flag contains CO

if ~isempty( coflag )
    for ii = 1:numel( coflag )
        cotag = evalsfg(coflag(ii), :);
        strco = erase(cotag, 'CO');
        numco = str2double(strco);
        if isempty(gdata.sf)
            warning(['Composite Object' cotag 'does not exist!.'])
        else
            cosf = gdata.sf{numco};
            %replace in the input arguments sf the CO with the Formula.
            %example: 'CO1+R3' -> 'R1+R2+R3'
            sf = replace(sf , cotag, cosf); 
        end
        evalsfg = getsf(sf); %get the tag in the sf
    end
end

nfacet = size(gdata.gd,1);
nfacetsf = zeros(size(evalsfg, 1), 1); 

for ii = 1:size(evalsfg, 1)
    nfacetsf(ii) = findfacet(gdata , nfacet, strtrim(evalsfg(ii,:)));
end

gd = cell(length(nfacetsf)); %preallocate the gd cell
for ii = 1:length(nfacetsf)
    gd{ii} = gdata.gd{nfacetsf(ii),1};
end
cellsz  = cellfun(@size,gd,'uni',0);
cellszs = max((cell2mat(cellsz))); 
maxcellsz = max(cellszs); %maximum of the cellsz.
gdm = zeros(maxcellsz, size(evalsfg, 1));

for ii = 1:length(nfacetsf)
    prim = gdata.gd{nfacetsf(ii)}; %get the primitive
    zeros2add = maxcellsz - size(prim,1);
    if zeros2add > 0
        gdm(:,ii) = [prim; zeros(zeros2add,1)];
    else
        gdm(:,ii) = gd{ii};
    end
end
gd = gdm;
ns = char(evalsfg);
ns = ns';

%compose geometry
[dl,bt,dl1,bt1,msb] = decsg(gd,sf,ns); 

%consider varargin input arguments
if ~isempty( varargin )
    parser = inputParser;
    parser.addParameter('KeepInternalEdges', [], @isValidOptionOnOff);
    parser.parse( varargin{:} );
    
    kie = parser.Results.KeepInternalEdges;
    if ~isempty(kie) && strcmpi(kie, 'off')
        [dl, ~] = csgdel(dl, bt);
    end
end

%add composed geometry
class = 'Composite Object';
csg = cobjtodb(self.Geometry,dl,sf,bt,dl1,bt1,msb,class);

tag = csg.tag;
end

function id=findfacet(gdata, numFac, tag)
    id = 0;
    for ii = 1:numFac
        if strcmpi(gdata.gd{ii,2}, tag)
          id=ii;
        end
    end 
    if id == 0
       error(['Face with label (' tag ') not found!']);        
    end
end
function sf = getsf(sf)

sf = convertStringsToChars(sf);

sf = findsum(sf);
sf = findsub(sf);
sf = findint(sf);
sf = findpsx(sf);
sf = findpdx(sf);

sf = strsplit(sf); %split string
em = cellfun(@isempty,sf); sf(em) = [];

sf = string(sf); sf = sf'; sf = char(sf);

end
function sf = findsum(sf)
    sum = strfind(sf,"+");
    for i = 1:size(sum,2)
        if ~isempty(sum)
                sf(sum(i)) = " ";
        end
    end
end
function sf = findsub(sf)
    sub = strfind(sf,"-");
    if ~isempty(sub)
        for i = 1:size(sub,2)
            sf(sub(i)) = " ";
        end
    end
end
function sf = findint(sf)
    int = strfind(sf,"*");
    if ~isempty(int)
        for i = 1:size(int,2)
            sf(int(i)) = " ";
        end
    end
end
function sf = findpsx(sf)
    psx = strfind(sf,"(");
    if ~isempty(psx)
        for i = 1:size(psx,2)
            sf(psx(i)) = " ";
        end
    end
end
function sf = findpdx(sf)
    pdx = strfind(sf,")");
    if ~isempty(pdx)
        for i = 1:size(pdx,2)
            sf(pdx(i)) = " ";
        end
    end
end
function ok = isValidOptionOnOff(opt)
    try
       validatestring(opt,{'on', 'off'}) ;
    catch
       error(message('pde:pdegplot:GenericMustBeOffOn'));   
    end
    ok = true;
end