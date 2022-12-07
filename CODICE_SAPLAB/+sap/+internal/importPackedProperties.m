function self = importPackedProperties(self,prop2add)

for ii = 1:numel(prop2add)
   addprop(self,prop2add{ii}); 
end

end