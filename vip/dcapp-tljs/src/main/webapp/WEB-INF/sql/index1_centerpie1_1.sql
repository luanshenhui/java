select YLPM,SUM(JZ) as sumjz,decode(YLPM,'��ʯ','��','��ʯ','����ɰ','��') as dw
from ST_RKCZSJ
where CJSJ>to_date(to_char(sysdate-2,'yyyymmdd'),'yyyymmdd')
group by YLPM