classdef SubcellsMesher_Boundary_2D < SubcellsMesher_Boundary
    methods (Access = public) %(Access = ?Mesh_Unfitted)
        function facets_connec = computeFacetsConnectivities(obj,facets_coord_iso,interior_subcell_coord_iso,cell_x_value,~)
            nnode =  size(facets_coord_iso,1);
            if nnode == 2
                facets_connec = [1 2];
            elseif nnode == 4
                delaunay_connec = obj.computeDelaunay(interior_subcell_coord_iso);
                
                node_positive_iso = find(cell_x_value>0);
                % !! CHECK IF NEXT LINE WORKS !!
                % facets_connec = zeros(length(node_positive_iso),size(delaunay_connec,2));
                for idel = 1:length(node_positive_iso)
                    [connec_positive_nodes, ~] = find(delaunay_connec==node_positive_iso(idel));
                    facets_connec(idel,:) = delaunay_connec(connec_positive_nodes(end),delaunay_connec(connec_positive_nodes(end),:)~=node_positive_iso(idel)) - nnode;
                end
            else
                error('Case not considered.')
            end
        end
    end
end
