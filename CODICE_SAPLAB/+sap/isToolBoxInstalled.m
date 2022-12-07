function  result = isToolBoxInstalled(toolbox)

narginchk(1,1);

matlab_Ver = ver;
[toolboxes{1:length(matlab_Ver)}] = deal(matlab_Ver.Name);
result = all(ismember(toolbox, toolboxes));


end