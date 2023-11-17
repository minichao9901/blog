procedure(replace_dev(myworkLib source_lib source_dev target_lib target_dev)
let((cell list sch cv targetId w l)
cell_list=ddGetobj(myWorkLib)~>cells~>name
foreach(cell cell_list
sch_cv = dbopencellViewByType(myWorkLib cell "schematic" "schematic" "a")
if(sch cv then
foreach(inst sch cv~>instances
if(inst~>cellName == source dev && inst~>libName == source_lib then
targetId=dbOpencellViewByType(target_lib target_dev "symbol" "")
if(targetId then
w=inst~>w
l=inst~>l
nf=inst~>fingers
inst~>master=targetId
inst~>fw=w
inst~>l=l
inst~>nf=nf
cdfgData=cdfGetInstCDF(inst)
(foreach pName list("m" "1" "w" "fw" "wpf")
param=cdfFindParamByName(cdfgData pName)
(when param~>callback
evalstring(param~>callback)
)
dbClose(targetId)
);if
);if
);foreach
dbSave(sch cv)
dbClose(sch_cv)
);if
);foreach
);let
);procedure
