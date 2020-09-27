select '公司账户转个人账户预警',count(*) as num from  TL_XD_PYPOSPER
where SHUJRQ>trunc(add_months(sysdate,-1),'mm')
union 
select '个人账户大额资金异动预警',count(*) from TSJB_ALL
where JBSJ>trunc(add_months(sysdate,-1),'mm')
union 
select '个人对外投资监测',count(*) from V_INDEX2_1
where to_date(RIQI,'yyyymmdd')>trunc(add_months(sysdate,-1),'mm')
union 
select '个人账户境外大额消费预警',count(*) from V_INDEX2_3
union 
select '投诉举报',count(*) from v_index2_5
where to_date(RIQI,'yyyymmdd')>trunc(add_months(sysdate,-1),'mm')
