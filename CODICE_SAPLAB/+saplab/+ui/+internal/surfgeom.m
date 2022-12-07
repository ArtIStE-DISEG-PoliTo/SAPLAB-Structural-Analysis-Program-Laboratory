function [x,y] = surfgeom(dl, bs, s)
    
narginchk(1,3);
nargoutchk(1,2);

if (ischar(dl))
    dl = str2func(dl);
end
if (isa(dl,"function_handle"))
    if (nargin == 1)
        x = dl();
    end
    if (nargin == 2)
        x = dl( bs );
    end
    if (nargin == 3)
        [x,y] = dl(bs, s);
    end
    return;
end

nbs = size(dl, 2);
if (nargin == 1)
    x = nbs;
    return;
end

d = [zeros(1, nbs); ones(1, nbs); dl(6:7,:)];
bs1 = bs(:)';
if find(bs1 < 1 | bs1 > nbs)
    error('Non-existent boundary segment number!')
end

if (nargin == 2)
    x = d(:, bs1);
    return;
end

%if (nargin == 3)
x=zeros(size(s));
y=zeros(size(s));
[m,n]=size(bs);
if m==1 && n==1
  bs=bs*ones(size(s));                  % expand bs
elseif m~=size(s,1) || n~=size(s,2)
  error('bs must be scalar or of same size as s');
end

if (~isempty(s))
    for k = 1 : nbs
        %check if the boundary segment exists
        ii = find(bs == k);
        if (~isempty(ii))
          x0=dl(2,k); x1=dl(3,k);
          y0=dl(4,k); y1=dl(5,k); 
          
          if (dl(1, k) == 1) %if the boundary segment is a circle
             xc=dl(8,k);
             yc=dl(9,k);
             r=dl(10,k);
             a0 = atan2(y0 - yc, x0 - xc);
             a1 = atan2(y1 - yc, x1 - xc);
             if (a0 > a1)
                a0 = a0 - 2*pi;
             end
             theta=(a1-a0)*(s(ii)-d(1, k))/(d(2, k)-d(1, k))+a0;
             x(ii)=r*cos(theta)+xc;
             y(ii)=r*sin(theta)+yc;  
          elseif (dl(1, k) == 2) %if the boundary segment is a line
             x(ii)=(x1-x0)*(s(ii)-d(1,k))/(d(2,k)-d(1,k))+x0;
             y(ii)=(y1-y0)*(s(ii)-d(1,k))/(d(2,k)-d(1,k))+y0;              
          elseif (dl(1, k) == 4) %if the boundary segment is a ellipse
             xc=dl(8,k);
             yc=dl(9,k);
             r1=dl(10,k);
             r2=dl(11,k);
             phi=dl(12,k);
             t=[r1*cos(phi) -r2*sin(phi); r1*sin(phi) r2*cos(phi)];
             rr0=t\[x0-xc;y0-yc];
             a0=atan2(rr0(2),rr0(1));
             rr1=t\[x1-xc;y1-yc];
             a1=atan2(rr1(2),rr1(1));
             if a0>a1
                a0=a0-2*pi;
             end
             nth=100; 
             th=linspace(a0,a1,nth);
             rr=t*[cos(th);sin(th)];
             theta=evalarcL(th,rr,s(ii),d(1,k),d(2,k));
             rr=t*[cos(theta);sin(theta)];
             x(ii)=rr(1,:)+xc;
             y(ii)=rr(2,:)+yc;              
          else
             error('Unknown segment type.');
          end
        end
    end
end

end

function theta=evalarcL(p,xy,s,s0,s1)

np=length(p);

dal=sqrt((xy(1,2:np)-xy(1,1:np-1)).^2+ ...
         (xy(2,2:np)-xy(2,1:np-1)).^2);
al=[0 cumsum(dal)];
tl=al(np);
s=s(:);
sal=tl*(s-s0)/(s1-s0);
theta=interp1(al,p,sal,'linear','extrap')';

end

