function [E, nu, md, ceoffTerm] = evaldefclsProperties(~, fcc)
    E = 22000*(.1*(fcc+8))^.3;
    nu = .2;
    md = 25;
    ceoffTerm = 1.2E-5;
end