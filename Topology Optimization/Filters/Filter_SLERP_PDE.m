classdef Filter_SLERP_PDE < Filter_PDE
    properties
    end

    methods
        function obj = Filter_SLERP_PDE(problemID,scale)
            obj@Filter_PDE(problemID,scale);
        end
        
        function rhs = integrate_L2_function_with_shape_function(obj,x)
            rhs = obj.faireF2(obj.coordinates',obj.connectivities',x);
        end
    end
end