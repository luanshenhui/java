select '公司账户转个人账户预警' as name,sum(CASE WHEN SHUJRQ>trunc(add_months(sysdate,-5),'mm') and SHUJRQ<trunc(add_months(sysdate,-4),'mm')  THEN 1 ELSE 0 END)||','||
sum(CASE WHEN SHUJRQ>=trunc(add_months(sysdate,-4),'mm') and SHUJRQ<trunc(add_months(sysdate,-3),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN SHUJRQ>=trunc(add_months(sysdate,-3),'mm') and SHUJRQ<trunc(add_months(sysdate,-2),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN SHUJRQ>=trunc(add_months(sysdate,-2),'mm') and SHUJRQ<trunc(add_months(sysdate,-1),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN SHUJRQ>=trunc(add_months(sysdate,-1),'mm')   THEN 1 ELSE 0 END) num
from TL_XD_PYPOSPER
union
select '个人账户大额资金异动预警',sum(CASE WHEN JBSJ>trunc(add_months(sysdate,-5),'mm') and JBSJ<trunc(add_months(sysdate,-4),'mm')  THEN 1 ELSE 0 END)||','||
sum(CASE WHEN JBSJ>=trunc(add_months(sysdate,-4),'mm') and JBSJ<trunc(add_months(sysdate,-3),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN JBSJ>=trunc(add_months(sysdate,-3),'mm') and JBSJ<trunc(add_months(sysdate,-2),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN JBSJ>=trunc(add_months(sysdate,-2),'mm') and JBSJ<trunc(add_months(sysdate,-1),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN JBSJ>=trunc(add_months(sysdate,-1),'mm')   THEN 1 ELSE 0 END) num
 from TSJB_ALL
union
select '个人对外投资监测',sum(CASE WHEN to_date(RIQI,'yyyymmdd')>trunc(add_months(sysdate,-5),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-4),'mm')  THEN 1 ELSE 0 END)||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-4),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-3),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-3),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-2),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-2),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-1),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-1),'mm')   THEN 1 ELSE 0 END) num
from V_INDEX2_1
union
select '个人账户境外大额消费预警','0,0,0,0,0' from V_INDEX2_3
union select '投诉举报',sum(CASE WHEN to_date(RIQI,'yyyymmdd')>trunc(add_months(sysdate,-5),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-4),'mm')  THEN 1 ELSE 0 END)||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-4),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-3),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-3),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-2),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-2),'mm') and to_date(RIQI,'yyyymmdd')<trunc(add_months(sysdate,-1),'mm') THEN 1 ELSE 0 END) ||','||
sum(CASE WHEN to_date(RIQI,'yyyymmdd')>=trunc(add_months(sysdate,-1),'mm')   THEN 1 ELSE 0 END) num  from V_INDEX2_5
