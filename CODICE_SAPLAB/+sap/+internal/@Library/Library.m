classdef (Sealed) Library < handle & dynamicprops

    methods 
        function self = Library(sfeam)
            arguments
                sfeam (1,1) sap.FEModel;
            end
            
            if (~isempty(sfeam.Library) )
                error('Model has already a library');
            end
            
            prop1 = addprop(self, 'Section'     );
            prop2 = addprop(self, 'Material'    );
            prop3 = addprop(self, 'SectionList' );
            prop4 = addprop(self, 'MaterialList');
            prop1.Hidden = true;
            prop2.Hidden = true;
            prop3.Hidden = true;
            prop4.Hidden = true;
            self.Section = struct;
            self.Material = struct;
            sfeam.Library = self;
        end
    end
    % public methods
    methods (Access = public, Hidden)
        function L= getList(self, listType)
              narginchk(2,2);
              nargoutchk(0,1);
              try
              switch (listType)
                  case {"Materials","materials"}
                      if (isempty(self.MaterialList))
                          error('No material object found in library.');
                      end
                    list = cell2table(self.MaterialList,'VariableNames',{'Object Name' 'Type' 'Class'});
                  case {"Sections", "sections"}
                      if (isempty(self.SectionList))
                          error('No section object found in library.');
                      end                      
                    list = cell2table(self.SectionList,'VariableNames',{'Object Name' 'Type' 'Class'});  
                  case {"All", "all"}
                    if (isempty(self.SectionList) && isempty(self.MaterialList))
                        error('No object found in library.');
                    end                         
                    allList = [self.MaterialList; self.SectionList];
                    list = cell2table(allList,'VariableNames',{'Object Name' 'Type' 'Class'});  
                  otherwise
                      error('Invalid library object');
              end
              catch ME
                  throwAsCaller(ME);
              end
              
              list = convertvars(list, {'Object Name' 'Type' 'Class'}, 'categorical');
              
              if (nargout == 0)
                 disp(list);
              elseif (nargout == 1)
                  L = list;
              end
        end
        function scp = structuralSection(self, sec, sectype, name, varargin)
        
            narginchk(3,10); %narginchk
            nargoutchk(0,1); % nargoutchk
            
            validSections = ["HEA", "HEB", "HEM", "IPE", "IPN", "UPN", "T", "RECTANGULAR", "CIRCULAR", "HOLLOW RECTANGULAR", "HOLLOW CIRCULAR"];
            validatestring(sec, validSections);
            
            [name] = convertStringsToChars(name);
            
            parser = inputParser;
            switch (sec)
                case {"HEA", "HEB", "HEM", "IPE", "IPN", "UPN", "T"}
                    addParameter(parser , 'Orientation', [], @isnumeric);
                    parse(parser, varargin{:});
            
                    if (startsWith(sec, 'HEA', 'IgnoreCase', true))
                        scp = sap.internal.section.HEA(sectype, 'Orientation', parser.Results.Orientation);
                        scp.NameID = name;
                    end
                    if (startsWith(sec, 'HEB', 'IgnoreCase', true))
                        scp = sap.internal.section.HEB(sectype, 'Orientation', parser.Results.Orientation);
                        scp.NameID = name;
                    end
                    if (startsWith(sec, 'HEM', 'IgnoreCase', true))
                        scp = sap.internal.section.HEM(sectype, 'Orientation', parser.Results.Orientation);
                        scp.NameID = name;
                    end      
                    if (startsWith(sec, 'IPE', 'IgnoreCase', true))
                        scp = sap.internal.section.IPE(sectype, 'Orientation', parser.Results.Orientation);
                        scp.NameID = name;
                    end    
                otherwise
                    return;
            end
            self.addobject(scp);
        end        
        function mt = structuralMaterial(self, class, name, varargin)
        
            narginchk(3,10); %narginchk
            nargoutchk(0,1); % nargoutchk
            
            [name] = convertStringsToChars(name);
            
            %initialize input parser
            parser = inputParser;
            switch (class)
                case {"concrete","Concrete"}
                    addParameter(parser, 'CompressiveStrenght', [], @isnumeric);
                    addParameter(parser, 'TensileStrenght', [], @isnumeric);
                    parse(parser, varargin{:});
            
                    fc = parser.Results.CompressiveStrenght;
                    ft = parser.Results.TensileStrenght;
                    try
                        if (isempty( ft ))
                            mt = sap.internal.material.Concrete(fc);
                            mt.NameID = name;
                            self.addobject(mt); % import to library  
                            return;
                        end
                        mt = sap.internal.material.Concrete(fc, ft);
                        mt.NameID = name;
                        self.addobject(mt); % import to library  
                        return;
                    catch ME
                        throwAsCaller(ME);
                    end
                case {"steel", "Steel"}
                    addParameter(parser, 'YieldStress', [], @isnumeric);
                    addParameter(parser, 'UltimateStress', [], @isnumeric);    
                    parse(parser, varargin{:});
            
                    fy = parser.Results.YieldStress;
                    fu = parser.Results.UltimateStress;
                    try
                        if (isempty( fu ))
                            mt = sap.internal.material.Steel(fy);
                            mt.NameID = name;
                            self.addobject(mt); % import to library  
                            return;
                        end
                        mt = sap.internal.material.Steel(fy, fu);
                        mt.NameID = name;
                        self.addobject(mt); % import to library  ;
                        return;
                    catch ME
                        throwAsCaller(ME);
                    end
                case {"User Material", "user material", "User material"}
                    addParameter(parser, 'YoungsModulus', [], @isnumeric);
                    addParameter(parser, 'PoissonsRatio', [], @isnumeric);  
                    addParameter(parser, 'MassDensity', [], @isnumeric); 
                    addParameter(parser, 'CTE', [], @isnumeric); 
                    parse(parser, varargin{:});
            
                    E = parser.Results.YoungsModulus;
                    nu = parser.Results.PoissonsRatio;
                    md = parser.Results.MassDensity;
                    coeffTerm = parser.Results.CTE;
            
                    mustBeNonempty(E);
                    if (isempty(nu))
                        nu = 0;
                    end
                    if (isempty(md))
                        md = 0;
                    end
                    if (isempty(coeffTerm))
                        coeffTerm = 0;
                    end
                    try
                        mt = sap.internal.material.UserMaterial(E, nu, md, coeffTerm);
                        mt.NameID = name;
                        self.addobject(mt); % import to library  ;
                        return;
                    catch ME
                        throwAsCaller(ME);
                    end
            end
                 
        end    
        function mat = get(self, objectName)
            arguments
                self (1,1) sap.internal.Library;
                objectName;
            end
            narginchk(2,2);
            nargoutchk(1,1);
            %connects the private function with the public function
            try
               mat = self.getObject(objectName);
            catch ME
                throwAsCaller(ME);
            end
        end
    end
    % non static methods - with access private
    methods ( Static = false, Access = ?sap.internal.Library)
        function addobject(self, obj)
            arguments
                self (1,1) sap.internal.Library;
                obj {mustBeA(obj,["sap.internal.StructuralMaterial","sap.internal.StructuralSection"])};
            end
            nm = obj.NameID;
            nm = self.structName(nm);
            try
                if (isa(obj, 'sap.internal.StructuralMaterial'))
                    fieldNames = fieldnames(self.Material);
                    flag = find(strcmp(fieldNames, nm)); %#ok
                    if (~ isempty( flag ) )
                        error(['Already existing material object with name (' char(obj.NameID) '). Change name or delete the existing object!'])
                    end
                    self.Material.(nm) = obj;
                    self.MaterialList{end+1,1} = obj.NameID;
                    self.MaterialList{end , 2} = 'Material';
                    self.MaterialList{end,  3} = obj.Class;
                end
                if (isa(obj, 'sap.internal.StructuralSection'))
                    fieldNames = fieldnames(self.Section);
                    flag = find(strcmp(fieldNames, nm)); %#ok
                    if (~ isempty( flag ) )
                        error(['Already existing section object with name (' char(obj.NameID) '). Change name or delete the existing object!'])
                    end                
                    self.Section.(nm) = obj;
                    self.SectionList{end+1,1} = obj.NameID;
                    self.SectionList{end  ,2} = 'Section';
                    self.SectionList{end,  3} = obj.Class;     
                end      
            catch ME
                throwAsCaller(ME);
            end
        end   
    end
    
    % non static methods - with access public to sap.StructuralAnalysisProgram
    methods ( Static = false , Access = {?sap.StructuralAnalysisProgram, ?sap.internal.Library})
        function obj = getObject(self, objectName)
            arguments
                self (1,1) sap.internal.Library;
                objectName {mustBeA(objectName, ["char", "string"])}
            end
            
            narginchk(2,2);
            nargoutchk(0,1);

            [objectName] = convertStringsToChars(objectName);
            getListTAB = self.getList('all');
            %get the flag in the get list tab
            flag = find(strcmp(string(getListTAB{:,'Object Name'}), objectName)); 
            if ( isempty(flag) )
                error(['Object with name (' objectName ') not found in library']);
            end
            %get the type
            type = (string(getListTAB{flag,'Type'}));
            if (strcmpi(type, 'Material'))
                field = self.structName(objectName);
                obj = getfield(self.Material, field);
            end
            if (strcmpi(type, 'Section'))
                field = self.structName(objectName);
                obj = getfield(self.Section, field);
            end            
        end
    end

    % static methods - with access private
    methods ( Access = ?sap.internal.Library, Static = true)
        function n = structName(nm)
            n = nm(~isspace(nm));
            n = erase(n, '-');
            n = erase(n, '=');
            n = erase(n, '*');
            n = erase(n, '+');
            n = erase(n, '°');       
            n = erase(n, '.'); 
            n = erase(n, ')'); 
            n = erase(n, '('); 
            n = erase(n, '/'); 
            n = erase(n, ','); 
            n = erase(n, ';');        
            n = erase(n, '.');
            n = erase(n, '&');
            n = erase(n, '"');
            n = erase(n, "'");
            n = erase(n, "!");
            n = erase(n, "|");
            n = erase(n, "@");
        end
        function ok = isValidOptionOnOff(opt)
            try
               validatestring(opt,{'on', 'off'}) ;
            catch
               error("Acceptable values are 'on' and 'off'");   
            end
            ok = true;
        end
    end
end

