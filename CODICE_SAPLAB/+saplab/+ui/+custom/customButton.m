function customButton(cn)

buttn3 = cn; %get the component name

[but, widID] = mlapptools.getWebElements(buttn3);       
[childbut] = mlapptools.getChildNodeIDs(but, widID);
mlapptools.setStyle(but,'border-radius','0px',childbut);

end

