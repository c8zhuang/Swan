classdef Postprocess_TopOpt < Postprocess
    
    properties (SetObservable,AbortSet)
        res_file
    end
    
    properties (Access = protected)
        Field
        Iter
    end
    
    methods (Access = public)        

        
        function  print(obj,mesh,field,iter,outName)
            path = pwd;
            obj.Iter = iter;
            obj.Field = field;
            obj.file_name = outName;
            dir = fullfile(path,'Output',obj.file_name);

            if 7~=exist(dir,'dir')
                mkdir(dir)
            end
            obj.setBasicParams(mesh)
            obj.PrintMeshFile(iter)
            obj.PrintResFile(iter)
        end
        function mesh=setNewMesh(obj,mesh,results)
           % null_nodes=find(results.design_variable<0.2);  
            null_nodes=find(results.design_variable>0);  
            null_elements=any(ismember(mesh.connec,null_nodes)');
            mesh.connec(null_elements,:)=[];
        end
        
        function r = getResFile(obj)
            r = obj.res_file;
        end
    end
    
    methods (Access = protected)
        function setBasicParams(obj,mesh)
            obj.nfields = 1;
            for ifield = 1:obj.nfields
                obj.coordinates{ifield} = mesh.coord;
                obj.connectivities{ifield} = mesh.connec;
                obj.nnode(ifield) = size(mesh.connec,2);
                obj.npnod(ifield) = size(mesh.coord,1);  % Number of nodes
            end
            obj.gtype = mesh.geometryType;
            obj.pdim = mesh.pdim;
            switch obj.pdim
                case '2D'
                    obj.ndim=2;
                case '3D'
                    obj.ndim=3;
            end
            obj.ptype = mesh.ptype;
            
            switch  obj.gtype %gid type
                case 'TRIANGLE'
                    obj.etype = 'Triangle';
                case 'QUAD'
                    obj.etype = 'Quadrilateral';
                case 'TETRAHEDRA'
                    obj.etype = 'Tetrahedra';
                case 'HEXAHEDRA'
                    obj.etype = 'Hexahedra';
            end
            obj.nelem = size(mesh.connec,1); % Number of elements
            obj.gauss_points_name = 'Guass up?';
            
            obj.nsteps = 1;
        end
        
        function PrintResFile(obj,iter)
            obj.printResults()
            FileName = fullfile('Output',obj.file_name,strcat(obj.file_name,'_',num2str(iter),'.flavia.res'));
            obj.res_file = FileName;
        end
    end
    
    
    methods (Access = private)        
        function obtainIter(obj,results)
            obj.Iter = results.iter;
        end        
    end
    
    methods (Static)
        function obj = Create(optimizer)
            switch optimizer
                case {'SLERP','PROJECTED SLERP', 'HAMILTON-JACOBI'}
                    obj = Postprocess_TopOpt_levelSet;
                case {'PROJECTED GRADIENT', 'MMA', 'IPOPT'}
                    obj = Postprocess_TopOpt_density;
            end
        end
        
        
    end
    
    methods (Access = protected, Abstract)
      printResults(obj) 
    end
end
