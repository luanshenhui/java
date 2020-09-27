select sum(a) as suma,b,
(select sum(REALNUM) from ST_YIELDTRANSIT where SETTIME>to_date(trunc(sysdate,'mm'))) c
from (
select REALNUM a,to_char(SETTIME,'mm-dd') b
from ST_YIELDTRANSIT
where SETTIME>to_date(to_char(sysdate-6,'yyyymmdd'),'yyyymmdd')
)
group by b
order by b