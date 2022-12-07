function model = open(FileName)

narginchk(1,1);
nargoutchk(1,1);

[tf,file] = saplab.filechk(FileName);
if ~tf
    error('File does not contain a saplab model.');
end

model = file.FileData.SaplabModel;

end