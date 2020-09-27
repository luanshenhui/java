select * from 
(select 0 a,to_char(to_char(CJSJ,'yyyy"年"mm"月"dd"日" hh24"点"mi"分"')||' 车号'||CH||'入库净重为'||JZ||'的'||YLPM||',责任人为'||MZCZR) b,CJSJ c,0 d
from ST_RKCZSJ
where CJSJ>to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd')
UNION
select 0 a,to_char(to_char(YIELDDATETIME,'yyyy"年"mm"月"dd"日" hh24"点"mi"分"')||'生产了标号为'||STUFF_CAPTION||'的商砼方量'||STUFFNUM||',责任人为'||YIELDMAN)b,YIELDDATETIME c,0 d
FROM
(select max(YIELDDATETIME) YIELDDATETIME,max(STUFF_CAPTION) STUFF_CAPTION,max(STUFFNUM) STUFFNUM,max(YIELDMAN) YIELDMAN
from ST_STUFFAGITATIONYIELD
where YIELDDATETIME>to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd')
GROUP BY YIELDROLE_ID) a
UNION
select DANGER_LEVEL a,to_char(to_char(OPERATION_TIME,'yyyy"年"mm"月"dd"日" hh24"点"mi"分"')||' 产生'||decode(DANGER_LEVEL,3,'红色预警',2,'橙色预警',1,'黄色预警','预警')||',预警内容为'||WARNING_CONTENT)b,OPERATION_TIME c,DANGER_LEVEL d
from DCA_WARNING
where OPERATION_TIME>to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd')
and type<3
UNION
select DANGER_LEVEL a,to_char(to_char(OPERATION_TIME,'yyyy"年"mm"月"dd"日"')||' 产生'||decode(DANGER_LEVEL,3,'红色预警',2,'橙色预警',1,'黄色预警','预警')||',预警内容为'||WARNING_CONTENT)b,OPERATION_TIME c,DANGER_LEVEL d
from DCA_WARNING
where OPERATION_TIME>trunc(add_months(sysdate,-1),'mm')
and type=3 )
order by c desc
