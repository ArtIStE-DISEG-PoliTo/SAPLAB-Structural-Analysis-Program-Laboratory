function c = FollowerFrameColor(t,axis)
switch t
    case {'black','b'}
        switch axis
            case 'x'
            c = [0.8 0 0];
            case 'y'
            c = [.9 .9 .9];    
            case 'z'
            c = [0 .75 .75];   
        end
    case {'white','w'}
        switch axis
            case 'x'
            c = [0.8 0 0];
            case 'y'
            c = [.0 .8 .0];    
            case 'z'
            c = [0 0 .8]; 
        end
end

