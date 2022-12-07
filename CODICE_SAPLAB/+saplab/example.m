function example(E)
%Example open a saplab example

import saplab.internal.examples.*

try
    open(E)
catch ME
    if ~isempty(ME.message)
        error('Example not found.')
    end
end

