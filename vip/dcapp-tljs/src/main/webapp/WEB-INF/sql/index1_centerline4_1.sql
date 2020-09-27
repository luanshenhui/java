select YLMC_JC,
SUM(CASE WHEN YYYYMMDD=to_char(sysdate-4,'yyyymmdd') THEN BRJC ELSE 0 END)
||','||
SUM(CASE WHEN YYYYMMDD=to_char(sysdate-3,'yyyymmdd') THEN BRJC ELSE 0 END)
||','||
SUM(CASE WHEN YYYYMMDD=to_char(sysdate-2,'yyyymmdd') THEN BRJC ELSE 0 END)
||','||
SUM(CASE WHEN YYYYMMDD=to_char(sysdate-1,'yyyymmdd') THEN BRJC ELSE 0 END)
||','||
SUM(CASE WHEN YYYYMMDD=to_char(sysdate,'yyyymmdd') THEN BRJC ELSE 0 END) A
from ST_YCLRXHJCTJB_DAY
where YYYYMMDD>to_char(sysdate-4)
group by YLMC_JC 