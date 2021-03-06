function [phin1] = transfer_info(dirichlet_data,coord,coordn1,phi)
% The obj is to transfer the phi function, defined on Omega_n, to the new mesh Omega_n1
% Omega_n is defined by {dirichlet_data,coord}
% Omega_n1 is defined by {dirichlet_datan1,coordn1} but we only need coordn1
% phi is the function defined on Omega_n
% phin1 is the new function defined on Omega_n1
%keyboard
nodesn1 = [1:1:size(coordn1,1)];
[etarget] = find_point_element(dirichlet_data,coord,coordn1);
[shape] = shape_func_triang(dirichlet_data,coord,etarget,coordn1(:,1),coordn1(:,2));
phin1 = zeros(size(coordn1,1),1);
for inode=1:size(dirichlet_data,1);
   phin1 = phin1 + shape(inode,:)'.*phi(dirichlet_data(inode,etarget));
end

end

