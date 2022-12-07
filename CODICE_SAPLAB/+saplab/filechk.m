function [tf,file] = filechk(file)

tf = false;

file = load(file);
if isstruct(file)
    if isfield(file,'FileData')
        if isfield(file.FileData,'SaplabModel')
           model =file.FileData.SaplabModel;
           if isa(model,'sap.FEModel')
                tf = true;
           end
        end
    end
end


end