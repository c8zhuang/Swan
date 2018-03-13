classdef Element_Elastic_2D<Element_Elastic
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function variables = computeVars(obj,uL)
            variables = obj.computeDispStressStrain(uL);
            variables.strain = obj.computeEz(variables.strain,obj.nstre,obj.nelem,obj.material);
            variables = obj.permuteStressStrain(variables);
        end
        
        
        function [B] = computeB(obj,igaus)
            B = zeros(3,obj.nnode*obj.dof.nunkn,obj.nelem);
            for i = 1:obj.nnode
                j = obj.dof.nunkn*(i-1)+1;
                B(1,j,:)  = obj.geometry.cartd(1,i,:,igaus);
                B(2,j+1,:)= obj.geometry.cartd(2,i,:,igaus);
                B(3,j,:)  = obj.geometry.cartd(2,i,:,igaus);
                B(3,j+1,:)= obj.geometry.cartd(1,i,:,igaus);
            end
        end
    end
    
end

