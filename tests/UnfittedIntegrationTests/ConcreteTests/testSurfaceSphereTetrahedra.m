classdef testSurfaceSphereTetrahedra < testUnfittedIntegration_ExternalIntegrator...
                                  & testUnfittedSurfaceIntegration
    
   properties (Access = protected)
        testName = 'test_sphere_tetrahedra';  
        analiticalArea = 4*pi;
        meshType = 'BOUNDARY';
   end
   
end
