select YLPM,sum(CASE WHEN CJSJ>=to_date(to_char(sysdate-5,'yyyymmdd'),'yyyymmdd')
and CJSJ<to_date(to_char(sysdate-4,'yyyymmdd'),'yyyymmdd') THEN jz ELSE 0 END)
||','||
sum(CASE WHEN CJSJ>=to_date(to_char(sysdate-4,'yyyymmdd'),'yyyymmdd')
and CJSJ<to_date(to_char(sysdate-3,'yyyymmdd'),'yyyymmdd') THEN jz ELSE 0 END)
||','||
sum(CASE WHEN CJSJ>=to_date(to_char(sysdate-3,'yyyymmdd'),'yyyymmdd')
and CJSJ<to_date(to_char(sysdate-2,'yyyymmdd'),'yyyymmdd') THEN jz ELSE 0 END)
||','||
sum(CASE WHEN CJSJ>=to_date(to_char(sysdate-2,'yyyymmdd'),'yyyymmdd')
and CJSJ<to_date(to_char(sysdate-1,'yyyymmdd'),'yyyymmdd') THEN jz ELSE 0 END)
||','||
sum(CASE WHEN CJSJ>=to_date(to_char(sysdate-1,'yyyymmdd'),'yyyymmdd') THEN jz ELSE 0 END) a
from ST_RKCZSJ
where CJSJ>=to_date(to_char(sysdate-5,'yyyymmdd'),'yyyymmdd')
group by YLPM