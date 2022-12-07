function coeff=validateCoeffcs(~, coeff)
    %validate compressive strenght value
    if ~isnumeric(coeff) && ~isscalar(coeff)
        error('Compressive strenght must be a positive numeric scalar!');
    else
        mustBeNonempty(coeff);
        mustBePositive(coeff);                
    end
end