function save(self, varargin)

   parser = inputParser();
   parser.addParameter('FileName', [], @(x) ischar(x) || isstring(x) || ~isempty(x));
   parser.parse(varargin{:});
   
   narginchk(1,4);
   nargoutchk(0,0);
   
   t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
   FileData=struct('FileData',[],'FileName',[],'DateTime',[]);
   
   try
       if ~isa(self,'sap.FEModel')
            error(['saptool_save function does not support (' class(self) ') objects/variables.']);
       end
   catch ME
       throwAsCaller(ME);
   end

   if isempty(parser.Results.FileName)
       getFileName = 'untitled';
        if strcmp(getFileName, 'untitled')
            Files = dir(fullfile(pwd, '*.mat'));
            if isempty(Files)
                FileData.SaplabModel = self;
                FileData.FileName = getFileName;
                FileData.DateTime = t;
                save('untitled', "FileData");
            else
                concatFileName = strcat(getFileName, '.mat');
                if contains([Files.name],concatFileName) 
                    
                    answer =  questdlg(['A file named ' concatFileName ...
                            ' already exists! Do you want to replace it?'], ...
	                        'File already exists!', ...
	                        'Yes','No','Yes'); 
    
                    switch answer 
                        case 'No'
                            return;
                        case 'Yes'
                            getFile = load(concatFileName);
                            getFile.self = self;
                        otherwise
                            return;
                    end
                end
            end
        end
        FileData.SaplabModel = self;
        FileData.FileName = getFileName;
        FileData.DateTime = t;        
        save(getFileName, "FileData");
   else

        getFileName = parser.Results.FileName;
        if isempty(varargin)
            getFileName = 'untitled';
        end
        Files = dir(fullfile(pwd, '*.mat'));
        if isempty(Files)
            FileData.SaplabModel = self;
            FileData.FileName = getFileName;
            FileData.DateTime = t;             
            save(getFileName, "FileData");
        else
            concatFileName = strcat(getFileName, '.mat');
            if contains([Files.name],concatFileName) 
                
                answer =  questdlg(['A file named ' concatFileName ...
                        ' already exists! Do you want to replace it?'], ...
                        'File already exists!', ...
                        'Yes','No','Yes'); 

                switch answer 
                    case 'No'
                        return;
                    case 'Yes'
                        getFile = load(concatFileName);
                        getFile.self = self;
                    otherwise
                        return;
                end
            else
                FileData.SaplabModel = self;
                FileData.FileName = getFileName;
                FileData.DateTime = t;                   
                save(getFileName, "FileData");
            end
        end
   end
end