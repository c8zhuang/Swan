classdef DS_Optimizer_SLERP < Default_Settings
    
    properties  (GetAccess = public, SetAccess = private)       
        nconstr=1
        target_parameters
        constraint_case='EQUALITY'
        line_search='DIMENSIONALLY_CONSISTENT'
        optimizer='SLERP'
        filename='plese specify a filename'
        case_file='plese specify a benchmark case'
        maxiter=5000
        printing=false
        printMode='DesignAndShapes'
        plotting= true
        epsilon = 0.03
        mon_settings=[]
    end
end