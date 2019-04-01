classdef TargetParamsManager < handle
    
    properties (GetAccess = public, SetAccess = private)
        targetParams
    end
    
    properties (Access = private)
        nSteps
        scale
        
        volumeFrac
        constraintTol
        optimalityTol
        epsilon
        epsilonVel
        epsilonPer
        epsilonIsotropy
    end
    
    methods (Access = public)
        
        function obj = TargetParamsManager(cParams)
            obj.init(cParams);
            obj.generateSequences(cParams);
            obj.update(1);
        end
        
        function update(obj,iStep)
            obj.computeValues(iStep);
            obj.assignValues();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.nSteps = cParams.nSteps;
            obj.scale = cParams.scale;
            obj.targetParams = TargetParameters();
        end
        
        function generateSequences(obj,cParams)
            obj.volumeFrac = LinearSequence(1/obj.nSteps,1,obj.nSteps,cParams.Vfrac_initial,cParams.Vfrac_final);
            obj.constraintTol = LinearSequence(0,1,obj.nSteps,cParams.constr_initial,cParams.constr_final);
            obj.optimalityTol = LinearSequence(0,1,obj.nSteps,cParams.optimality_initial,cParams.optimality_final);
            obj.epsilon = LinearSequence(0,1,obj.nSteps,cParams.epsilonInitial,cParams.epsilonFinal);
            obj.epsilonVel = LinearSequence(0,1,obj.nSteps,cParams.epsilonVelInitial,cParams.epsilonVelFinal);
            obj.epsilonPer = LogarithmicSequence(-1,0,obj.nSteps,cParams.epsilonPerInitial,cParams.epsilonPerFinal);
            if strcmp(obj.scale,'MICRO')
                obj.epsilonIsotropy = LinearSequence(0,1,obj.nSteps,cParams.epsilonIsotropyInitial,cParams.epsilonIsotropyFinal);
            end
        end
        
        function computeValues(obj,iStep)
            obj.volumeFrac.update(iStep);
            obj.constraintTol.update(iStep);
            obj.optimalityTol.update(iStep);
            obj.epsilon.update(iStep);
            obj.epsilonVel.update(iStep);
            obj.epsilonPer.update(iStep);
        end
        
        function assignValues(obj)
            obj.targetParams.Vfrac = obj.volumeFrac.value;
            obj.targetParams.epsilon = obj.epsilon.value;
            obj.targetParams.epsilon_velocity = obj.epsilonVel.value;
            obj.targetParams.epsilon_perimeter = obj.epsilonPer.value;
            obj.targetParams.constr_tol = obj.constraintTol.value;
            obj.targetParams.optimality_tol = obj.optimalityTol.value;
            if strcmp(obj.scale,'MICRO')
                obj.targetParams.epsilon_isotropy = obj.epsilonIsotropy.value;
            end
        end
        
    end
    
end