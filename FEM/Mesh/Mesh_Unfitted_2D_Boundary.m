classdef Mesh_Unfitted_2D_Boundary < Mesh_Unfitted_2D & Mesh_Unfitted_Boundary
    methods
        function obj = Mesh_Unfitted_2D_Boundary(background_mesh,background_geom_interpolation)
            obj.storeBackgroundMesh(background_mesh,background_geom_interpolation);
            obj.max_subcells = 2;
            obj.nnodes_subcell = 2;
        end
        
        function plot(obj)
            figure, hold on
            for icell = 1:size(obj.connec,1)
                plot(obj.coord(obj.connec(icell,:),1),obj.coord(obj.connec(icell,:),2),'k-');
            end
            axis equal off
            hold off
        end
        
        function S = computeSurface(obj)
            integrator = Integrator;
            M2 = integrator.integrateUnfittedMesh(obj,obj.background_mesh,ones(size(obj.x_background)));
            S = sum(M2);
        end
    end
    
    methods (Access = ?Mesh_Unfitted_Boundary)
        function facets_connec = computeFacetsConnectivities(obj,facets_coord_iso,interior_subcell_coord_iso,cell_x_value)
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