ooasp_class("v1","Root").
ooasp_class("v1","Frame").
ooasp_class("v1","Module").
ooasp_class("v1","Element").
ooasp_class("v1","ElementA1"). 
ooasp_class("v1","ElementA2").

ooasp_subclass("v1","Frame","Root").
ooasp_subclass("v1","Module","Root").
ooasp_subclass("v1","Element","Root").
ooasp_subclass("v1","ElementA1","Element").
ooasp_subclass("v1","ElementA2","ElementA1").

ooasp_assoc("v1","Frame_modules","Frame",1,1,"Module",1,1).

ooasp_attribute("v1","Module","name","string").
ooasp_attribute_enum("v1","Module","name","test1").
ooasp_attribute_enum("v1","Module","name","test2").

ooasp_assoc("v1","Element_module","Element",1,1,"Module",1,1).
