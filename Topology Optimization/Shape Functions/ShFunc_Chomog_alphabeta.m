classdef ShFunc_Chomog_alphabeta < ShFunc_Chomog
    properties (Access = private)
        alpha
        beta
    end
    methods
        function obj=ShFunc_Chomog_alphabeta(settings)
            obj@ShFunc_Chomog(settings);
            obj.alpha=settings.micro.alpha/norm(settings.micro.alpha);
            obj.beta=settings.micro.beta/norm(settings.micro.beta);
        end
        function computeCostAndGradient(obj,x)
            obj.computePhysicalData(x); 
            
            %Cost
            inv_matCh = inv(obj.Chomog);
            costfunc = obj.projection_Chomog(inv_matCh,obj.alpha,obj.beta);
            obj.compute_Chomog_Derivatives(x);
            gradient = obj.derivative_projection_Chomog(inv_matCh,obj.alpha,obj.beta);
            
            mass=obj.Msmooth;
            gradient=obj.filter.getP1fromP0(gradient');
            gradient = mass*gradient;
            if isempty(obj.h_C_0)
                obj.h_C_0 = costfunc;
            end            
            costfunc = costfunc/abs(obj.h_C_0);
            gradient=gradient/abs(obj.h_C_0);
%             obj.h_C_0 = costfunc;
            
            obj.value = costfunc;
            obj.gradient = gradient;      
        end
    end
end