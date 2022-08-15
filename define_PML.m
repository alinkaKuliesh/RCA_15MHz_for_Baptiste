function pml_sz = define_PML(pml_range, grid_sz)

% create array of PML values to search
pml_size = pml_range(1) : 2 : pml_range(2);

% extract largest prime factor for each dimension for each pml size
facs = zeros(1, length(pml_size));

for index = 1:length(pml_size)
    facs(index) = max(factor(grid_sz + 2 * pml_size(index)));
end

% get best dimension size
[fac, ind_opt] = min(facs);

% assign output
pml_sz = pml_size(ind_opt);

authorized = 7;

if fac > authorized
    pml_sz = pml_size(end);
    num_gp = grid_sz + 2 * pml_sz;
    while max(factor(num_gp))>authorized 
        num_gp = num_gp + 2;
        pml_sz = pml_sz + 1;
    end
end

end

