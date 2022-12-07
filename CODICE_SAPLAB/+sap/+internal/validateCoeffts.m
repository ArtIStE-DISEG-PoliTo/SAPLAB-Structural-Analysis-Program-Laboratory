function coeff=validateCoeffts(~, coeff, cs)
    %validate tensile strenght value
    narginchk(2,3);
    if isempty(coeff)
        coeff=0;
    end
    if ~isnumeric(coeff) && ~isscalar(coeff)
        error('Tensile strenght must be a positive numeric scalar!');
    else
        mustBeInRange(coeff,0,cs/10);
    end            
end