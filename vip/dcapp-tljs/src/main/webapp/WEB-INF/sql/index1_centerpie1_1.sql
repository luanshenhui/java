select YLPM,SUM(JZ) as sumjz,decode(YLPM,'碎石','方','碎石','机制砂','吨') as dw
from ST_RKCZSJ
where CJSJ>to_date(to_char(sysdate-2,'yyyymmdd'),'yyyymmdd')
group by YLPM