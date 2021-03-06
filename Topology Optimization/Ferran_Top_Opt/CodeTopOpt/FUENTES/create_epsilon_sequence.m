function  epsilon_iter = create_epsilon_sequence(coordinates,element)

% Non-regular meshes
% coordinates = single(coordinates); % convert to single precision in order not to run out of RAM
% IP = (coordinates')' * coordinates';
% d = sqrt(bsxfun(@plus, diag(IP), diag(IP)') - 2 * IP);                                                                                                             
% epsilon0 = max(d(:));

% Regular mesh
xmin = min(coordinates);
xmax = max(coordinates);
epsilon0 = norm(xmax-xmin)/2;

epsilon_end =  estimate_mesh_size(element,coordinates)/1;
frac = 2;
kmax = ceil(log10(epsilon0/epsilon_end)/log10(frac));
epsilon_iter = epsilon0./frac.^(1:kmax);
%epsilon_iter = [sort(epsilon_end*2.^[-5:5],'descend') 0 ];

end