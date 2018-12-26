classdef Postprocess_TopOpt_levelSet < Postprocess_TopOpt
    properties
        levelSet_name = 'LevelSet';
        levelSet_name_component = 'LS';
    end
    
    methods (Access = protected)
        
        function printResults(obj)
            iD = obj.fid_res;
            fN = obj.file_name;
            nS = obj.nsteps;
            gD = obj.gauss_points_name;
            eT = obj.etype;
            pT = obj.ptype;
            nG = obj.ngaus;
            nD = obj.ndim;
            pG = obj.posgp;
            rS = obj.Field;
            iT = obj.Iter;
            LevelSetResultsPrinter(iD,fN,nS,gD,eT,pT,nG,nD,pG,rS,iT);
        end
    end
    
end