select to_char(add_months(sysdate,-4),'yyyymm') as datemonth ,count(*) as num from (select a,to_char(rq,'yyyymm')rq_yyyymm from (select '公司账户转个人账户预警' a,SHUJRQ rq
from TL_XD_PYPOSPER
union
select '个人账户大额资金异动预警' a,JBSJ rq
from TSJB_ALL
union
select '个人对外投资监测' a, to_date(RIQI,'yyyymmdd') rq
from V_INDEX2_1
union
select '投诉举报' a,to_date(RIQI,'yyyymmdd') rq  from V_INDEX2_5))
where rq_yyyymm=to_char(add_months(sysdate,-4),'yyyymm')
union
select to_char(add_months(sysdate,-3),'yyyymm') ,count(*) from (select a,to_char(rq,'yyyymm')rq_yyyymm from (select '公司账户转个人账户预警' a,SHUJRQ rq
from TL_XD_PYPOSPER
union
select '个人账户大额资金异动预警' a,JBSJ rq
from TSJB_ALL
union
select '个人对外投资监测' a, to_date(RIQI,'yyyymmdd') rq
from V_INDEX2_1
union
select '投诉举报' a,to_date(RIQI,'yyyymmdd') rq  from V_INDEX2_5))
where rq_yyyymm=to_char(add_months(sysdate,-3),'yyyymm')
union
select to_char(add_months(sysdate,-2),'yyyymm') ,count(*) from (select a,to_char(rq,'yyyymm')rq_yyyymm from (select '公司账户转个人账户预警' a,SHUJRQ rq
from TL_XD_PYPOSPER
union
select '个人账户大额资金异动预警' a,JBSJ rq
from TSJB_ALL
union
select '个人对外投资监测' a, to_date(RIQI,'yyyymmdd') rq
from V_INDEX2_1
union
select '投诉举报' a,to_date(RIQI,'yyyymmdd') rq  from V_INDEX2_5))
where rq_yyyymm=to_char(add_months(sysdate,-2),'yyyymm')
union
select to_char(add_months(sysdate,-1),'yyyymm') ,count(*) from (select a,to_char(rq,'yyyymm')rq_yyyymm from (select '公司账户转个人账户预警' a,SHUJRQ rq
from TL_XD_PYPOSPER
union
select '个人账户大额资金异动预警' a,JBSJ rq
from TSJB_ALL
union
select '个人对外投资监测' a, to_date(RIQI,'yyyymmdd') rq
from V_INDEX2_1
union
select '投诉举报' a,to_date(RIQI,'yyyymmdd') rq  from V_INDEX2_5))
where rq_yyyymm=to_char(add_months(sysdate,-1),'yyyymm')
union
select to_char(sysdate,'yyyymm'),count(*) from (select a,to_char(rq,'yyyymm')rq_yyyymm from (select '公司账户转个人账户预警' a,SHUJRQ rq
from TL_XD_PYPOSPER
union
select '个人账户大额资金异动预警' a,JBSJ rq
from TSJB_ALL
union
select '个人对外投资监测' a, to_date(RIQI,'yyyymmdd') rq
from V_INDEX2_1
union
select '投诉举报' a,to_date(RIQI,'yyyymmdd') rq  from V_INDEX2_5))
where rq_yyyymm=to_char(sysdate,'yyyymm')