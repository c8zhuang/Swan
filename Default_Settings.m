classdef Default_Settings < handle
    properties (Access = private)
        custom_settings
    end
    methods (Access = public)
        
        function settings = CompareAndAssignDefaults(obj,custom_settings) 
            obj.custom_settings=custom_settings;
            
            obj.VerifyIfDefaultExists()
            obj.AssignDefaults()

            settings=obj.custom_settings;
        end
        
    end
    
    methods (Access = private)
        
        function VerifyIfDefaultExists(obj)
            custom_names=fieldnames(obj.custom_settings);
            for i_custom = 1:length(custom_names)
                thisCustom = custom_names(i_custom);
                if obj.IsNotDefinedInDefault(properties(obj),thisCustom)
                    error('The variable %s is not present in the default settings.',thisCustom{:})
                end
            end
        end
        
        function AssignDefaults(obj)
            props = properties(obj);
            for iprop = 1:length(props)
                thisprop = props{iprop};
                if obj.CheckOverwriting(thisprop)
                    obj.custom_settings.(thisprop)=obj.(thisprop);
                end
            end 
        end
        
        function DoOverwrite=CheckOverwriting(obj,property)
            DoOverwrite = obj.IsNotDefinedInCustom(obj.custom_settings,property) && ~strcmp(property,'custom_settings');
        end
        
    end
    methods (Static)
        function IsNotDefined = IsNotDefinedInCustom(list,property)
            IsNotDefined=~isfield(list,property);
        end
        function IsNotDefined = IsNotDefinedInDefault(list,property)
            IsNotDefined=~any(strcmp(list,property));
        end
    end
end