procedure(replace_dev(myWorkLib source_lib source_dev target_lib target_dev)
let((cell list sch cv targetId w L)
cell_list=ddGetObj(myWorkLib)~>cells~>name
foreach(cell cell_list
sch_cv = dbOpenCellViewByType(myWorkLib cell "schematic" "schematic" "a")
if(sch cv then
foreach(inst sch_cv~>instances
if(inst~>cellName == source_dev && inst~>libName == source_lib then
targetId=dbOpenCellViewByType(target_lib target_dev "symbol" "")
if(targetId then
w=inst~>w
l=inst~>l
nf=inst~>fingers
inst~>master=targetId
inst~>segW=w
inst~>segL=1
inst~>nf=nf
cdfgData=cdfGetInstCDF(inst)
(foreach pName list("m" "l" "w" "fw" "wpf")
param=cdfFindParamByName(cdfgData pName)
(when param~>callback
evalstring(param~>callback)
)
dbClose(targetId)
);if
);if
);foreach
dbSave(sch_cv)
dbClose(sch_cv)
);if
);foreach
);let
);procedure
