function plot(sectionPropertiesToolBox, varargin)

if isempty(varargin)
   ax = gca; 
else
   ax = varargin{1}; 
end
v = sectionPropertiesToolBox.Data.V;
c = [sectionPropertiesToolBox.Data.Xg sectionPropertiesToolBox.Data.Yg];
t1 = sectionPropertiesToolBox.Data.Theta11*pi/180;
t2 = sectionPropertiesToolBox.Data.Theta22*pi/180;
bbox = max(abs(v)); bbox = max(bbox);
p = polyshape(v(:,1),v(:,2));
plot(ax,p,'FaceColor','r','LineWidth',1.2,'EdgeColor','r'); 

hold(ax,'on');

x1 = [ c(:,1)-bbox*cos(t1)  c(:,1)+bbox*cos(t1) ];
y1 = [ c(:,2)-bbox*sin(t1)  c(:,2)+bbox*sin(t1) ];
x2 = [ c(:,1)-bbox*cos(t2)  c(:,1)+bbox*cos(t2) ];
y2 = [ c(:,2)-bbox*sin(t2)  c(:,2)+bbox*sin(t2) ];        
hold(ax,'on')
plot(ax,x1,y1,':r',x2,y2,':g');

text(ax,x1(2),y1(2),'w','VerticalAlignment','bottom','FontSize',12,'FontWeight', 'bold');
text(ax,x2(2),y2(2),'v','HorizontalAlignment','left','FontSize',12,'FontWeight', 'bold');        
text(ax,x1(1),y1(1),'w','VerticalAlignment','top','FontSize',12,'FontWeight', 'bold');
text(ax,x2(1),y2(1),'v','HorizontalAlignment','right','FontSize',12,'FontWeight', 'bold');
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.XLabel.String = 'X';
ax.YLabel.String = 'Y';
axis(ax,'equal');
ax.Color = [.94 .94 .94];
end