classdef DesignVariableCreator < handle
    
    properties (Access = private)
        designVariable
        levelSet
    end
    
    methods (Access = public)
        
        function obj = DesignVariableCreator(settings,mesh,epsilon)
            obj.createLevelSet(settings,mesh,epsilon)
            obj.computeDesignVariable(settings.optimizer)
        end
        
        function x = getValue(obj)
            x = obj.designVariable;
        end
        
    end
    
    methods (Access = private)
       
        function obj = createLevelSet(obj,settings,mesh,epsilon)
            lsCreator = LevelSetCreator.create(settings,mesh,epsilon);
            obj.levelSet = lsCreator.getValue();
        end
        
        function computeDesignVariable(obj,optimizer)
            switch optimizer
                case {'SLERP','HAMILTON-JACOBI', 'PROJECTED SLERP'}
                    obj.designVariable = obj.levelSet;
                otherwise
                    phi = obj.levelSet;
                    obj.designVariable = heaviside(phi);
            end
            
        end
        
    end
    
end

