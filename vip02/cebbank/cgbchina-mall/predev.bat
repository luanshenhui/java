@echo -------------------------------------------
@echo copy files for windows
@echo -------------------------------------------
copy cgb-admin\src\main\filter\dev-example.properties cgb-admin\src\main\filter\dev.properties
copy cgb-mall-web\src\main\filter\dev-example.properties cgb-mall-web\src\main\filter\dev.properties
copy cgb-vendor-web\src\main\filter\dev-example.properties  cgb-vendor-web\src\main\filter\dev.properties
copy cgb-user\src\main\filter\dev-example.properties cgb-user\src\main\filter\dev.properties
copy cgb-item\src\main\filter\dev-example.properties cgb-item\src\main\filter\dev.properties
copy cgb-trade\src\main\filter\dev-example.properties cgb-trade\src\main\filter\dev.properties
copy cgb-related\src\main\filter\dev-example.properties cgb-related\src\main\filter\dev.properties
@pause