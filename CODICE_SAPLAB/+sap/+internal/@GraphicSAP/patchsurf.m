function h = patchsurf(~, dl,msb,tag)

CIRC=1;
POLY=2;
ELLI=4;

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
  h(j)=patch(x,y,color,'Parent',ax,'Tag',tag,'EdgeColor','none','UserData',j); %#ok

  j=j+1;
end
end