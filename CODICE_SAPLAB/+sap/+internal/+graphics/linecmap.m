function hh=linecmap(ax,x,y,z,cdata,varargin)

hh = surface(...
  'XData',[x(:) x(:)],...
  'YData',[y(:) y(:)],...
  'ZData',[z(:) z(:)],...
  'CData',[cdata(:) cdata(:)],...
  'FaceColor','none',...
  'EdgeColor','flat',...
  'Marker','none','Parent',ax);
  
if nargin == 6
    switch varargin{1}
        case {'+' 'o' '*' '.' 'x' 'square' 'diamond' 'v' '^' '>' '<' 'pentagram' 'p' 'hexagram' 'h'}
            set(hh,'LineStyle','none','Marker',varargin{1})
        otherwise
            error(['Invalid marker: ' varargin{1}])
    end

elseif nargin > 6
    set(hh,varargin{:})
end

end

