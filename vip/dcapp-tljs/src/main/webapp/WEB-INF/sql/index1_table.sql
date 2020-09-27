select (select type_name  from ST_WARNING_TYPE where type_id=type)type_name,
(select kind_name  from ST_WARNING_KIND where type_id=type and kind_id=kind)kind_name,
WARNING_CONTENT,decode(DANGER_LEVEL,1,'黄色告警',2,'橙色告警',3,'红色告警') as dlevel,
to_char(OPERATION_TIME,'yyyy-mm-dd hh:mi')OPERATION_TIME
from DCA_WARNING
where type= :type
and kind= :kind
order by OPERATION_TIME desc