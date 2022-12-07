function plotPlaneSurfaceGeometry(g, ax, tag, appearance, Reinforcement)

if isa(g,'sap.Geometry')
    dl = g.geom;
end
if isnumeric(g)
    dl = g;
end

nbs=r2dgeom(dl);
bpt=r2dgeom(dl,1:nbs);
npts= 40;
FillPoints = cell(1,nbs);
for i=1:nbs
    s = linspace(bpt(1,i),bpt(2,i),npts);
    [x,y]=r2dgeom(dl,i,s);
    FillPoints{i} = [x;y];
    X=[x NaN];
    Y=[y NaN];
    plot(ax,X,Y,'LineWidth',appearance.LineWidth,'Tag', [tag, ' - Edge ' num2str(i)],'Color', appearance.EdgeColor,'LineStyle',appearance.LineStyle);
    hold(ax,'on');
end

v = csgVertices(dl);
for i = 1:size(v,1)
    X = v(i,1);
    Y = v(i,2);
    plot(ax,X,Y,'LineWidth',appearance.LineWidth,'Marker', 's','MarkerFaceColor',appearance.VertexColor, 'Color', appearance.VertexColor, 'Tag', [tag, ' - Vertex ' num2str(i)], 'MarkerSize', appearance.MarkerSize);
end

if isempty(Reinforcement)
    return
else
    nr = numel(Reinforcement.StructuralReinforcementAssignments);
    if isempty(Reinforcement.StructuralReinforcementAssignments)
        return
    end
    for i=1:nr
        nri=Reinforcement.StructuralReinforcementAssignments(i);
        nrie = nri.RegionID;
        obj  = findobj(ax,'Tag',[tag, ' - Edge ' num2str(nrie)]);
        xData = obj.XData;
        yData = obj.YData;
        plot(ax,xData,yData,'Color',appearance.ReinforcementColor,'Tag', ['Reinforcement ' num2str(i)],'LineWidth',3,'LineJoin','chamfer','LineStyle','-');
    end
end

end

function v = csgVertices(gdm)
    %csgVertices(...) - Questa funzione calcola le coordinate dei
    %   vertici che compongono l'elemento geometrico di tipo
    %   superficie piana
    sx = gdm(2,:)';
    ex = gdm(3,:)';
    sy = gdm(4,:)';
    ey = gdm(5,:)';
    vxc = [sx sy; ex ey];
    comptol = max(max(abs(vxc(:))));
    comptol = max(comptol,1)*eps*1000;
    [~, I, ~] = uniquetol(vxc, comptol, 'ByRows',true);
    v = vxc(sort(I),:);
end   

function patchsurf(ax,dl,msb,tag) %#ok

CIRC=1;
POLY=2; %#ok
ELLI=4;

sn=size(dl,2);
color = [.75 .95 .95];

j=1;
for i=msb
  n=i(1);
  l=i(2:n+1);
  l2=zeros(size(l));
  x=zeros(1,n);
  y=zeros(1,n);
  t=zeros(1,n);
  k1=find(l<=sn);
  x(k1)=dl(2,l(k1));
  y(k1)=dl(4,l(k1));
  t(k1)=dl(1,l(k1));
  l2(k1)=l(k1);
  k2=find(l>sn);
  l2(k2)=l(k2)-sn;
  x(k2)=dl(3,l(k2)-sn);
  y(k2)=dl(5,l(k2)-sn);
  t(k2)=dl(1,l(k2)-sn);

  rn=ones(1,n);                         % general mechanism for
  rx=sparse([],[],[],1,n);              % adding points to patch
  ry=sparse([],[],[],1,n);

  c1=find(t==CIRC);                     % add circles
  if ~isempty(c1)
    delta=2*pi/100;
    th1=atan2(y(c1)-dl(9,l2(c1)),x(c1)-dl(8,l2(c1)));
    c2=rem(c1,n)+1;
    th2=atan2(y(c2)-dl(9,l2(c1)),x(c2)-dl(8,l2(c1)));
    i1=0; %#ok
    i3=1;
    for i2=c1
      if l(i2)>sn && th1(i3)<th2(i3)
        th2(i3)=th2(i3)-2*pi;
      elseif l(i2)<=sn && th1(i3)>th2(i3)
        th2(i3)=th2(i3)+2*pi;
      end
      dth=abs(th2(i3)-th1(i3));
      ns=max(2,ceil(dth/delta));
      th=linspace(th1(i3),th2(i3),ns);
      rn(i2)=ns-1;
      rx(1:ns,i2)=(dl(8,l2(i2))+dl(10,l2(i2))*cos(th))'; %#ok
      ry(1:ns,i2)=(dl(9,l2(i2))+dl(10,l2(i2))*sin(th))'; %#ok
      i3=i3+1;
    end
  end

  c1=find(t==ELLI);                     % add ellipses
  if ~isempty(c1)
    delta=2*pi/100;
    k=l2(c1);
    ca=cos(dl(12,k)); sa=sin(dl(12,k));
    xd=x(c1)-dl(8,k); yd=y(c1)-dl(9,k);
    x1=ca.*xd+sa.*yd;
    y1=-sa.*xd+ca.*yd;
    th1=atan2(y1./dl(11,k),x1./dl(10,k));
    c2=rem(c1,n)+1;
    xd=x(c2)-dl(8,k); yd=y(c2)-dl(9,k);
    x1=ca.*xd+sa.*yd;
    y1=-sa.*xd+ca.*yd;
    th2=atan2(y1./dl(11,k),x1./dl(10,k));
    i3=1;
    for i2=c1
      k=l2(i2);
      if l(i2)>sn && th1(i3)<th2(i3)
        th2(i3)=th2(i3)-2*pi;
      elseif l(i2)<=sn && th1(i3)>th2(i3)
        th2(i3)=th2(i3)+2*pi;
      end
      dth=abs(th2(i3)-th1(i3));
      ns=max(2,ceil(dth/delta));
      th=linspace(th1(i3),th2(i3),ns);
      rn(i2)=ns-1;
      x1=dl(10,k).*cos(th)'; y1=dl(11,k).*sin(th)';
      rx(1:ns,i2)=dl(8,k)+ca(i3).*x1-sa(i3).*y1; %#ok
      ry(1:ns,i2)=dl(9,k)+sa(i3).*x1+ca(i3).*y1; %#ok
      i3=i3+1;
    end
  end

  i4=find(t~=CIRC&t~=ELLI);
  if ~isempty(i4)
    rx(1,i4)=x(i4); %#ok
    ry(1,i4)=y(i4); %#ok
  end

  x=[]; y=[];
  for i2=1:n
    x=[x,full(rx(1:rn(i2),i2))']; %#ok
    y=[y,full(ry(1:rn(i2),i2))']; %#ok
  end

  % plot the subdomain:
  h(j)=patch(x,y,color,'Parent',ax,'Tag',tag,'EdgeColor','none','UserData',j,'FaceAlpha',0.4); %#ok

  j=j+1;
end
end
