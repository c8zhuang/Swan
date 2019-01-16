classdef OptimizerPrinter < handle
    
    properties (Access = private)
        postproc
        printMode
        mesh
    end
    
    properties (Access = protected)
        cost
        constraint
        dataBase
        dT
        dI
        hasGaussData
        fields
    end
    
    methods (Access = public, Static)
        
        function p = create(mesh,optimizer,fileName,printMode,cost,constraint)
            f = OptimizationPrinterFactory();
            p = f.create(printMode);
            p.init(mesh,optimizer,fileName,printMode,cost,constraint)
        end
    end
    
    methods (Access = public)
        
        function init(obj,mesh,optimizer,fileName,printMode,cost,constraint)
            obj.cost = cost;
            obj.constraint = constraint;
            obj.obtainHasGaussDataAndQuad();
            obj.createDataInputForCreateDataBase(mesh,fileName);
            obj.createDataBase();
            obj.createDtDataBase(optimizer,printMode);
            obj.postproc = Postprocess('TopOptProblem',obj.dataBase,obj.dT);
            obj.mesh = mesh;
            obj.printMode = printMode;
        end
        
        function print(obj,x,iter,cost,constraint)
            obj.createTopOptFields(x,cost,constraint);
            obj.postproc.print(iter,obj.fields);
        end
        
    end
    
    methods (Access = protected)
        
        function createDtDataBase(obj,optimizer,printMode)
            obj.dT.optimizer = optimizer;
            obj.dT.printMode = printMode;
        end
        
        function  createTopOptFields(obj,x,cost,constraint)
            obj.fields.designVariable = x;
        end
        
        function createDataInputForCreateDataBase(obj,mesh,fileName)
            obj.dI.iter    = 0;
            obj.dI.mesh    = mesh;
            obj.dI.outName = fileName;
        end       
        
    end
    
    methods (Access = private)
        
        function createDataBase(obj)
            ps = PostProcessDataBaseCreator.create(obj.hasGaussData,obj.dI);
            obj.dataBase = ps.getValue();
            obj.dataBase.hasGaussData = obj.hasGaussData;
        end       
        
    end
    
    methods (Access = protected, Abstract)
        obtainHasGaussDataAndQuad(obj)
    end
end