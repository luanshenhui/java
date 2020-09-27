select 1 a,to_char(RIQI||NAME||'产生了公司账户转个人账户预警') b,RIQI c,0 d from V_INDEX2_1
union
select 2 a,to_char(NAME||'产生了个人账户大额资金异动预警')b,'' c,0 d from V_INDEX2_3
union
select 3 a,to_char(to_char(SHUJRQ,'yyyymmdd')||NAME||'产生了个人对外投资监测') b,to_char(SHUJRQ,'yyyymmdd') c,0 d from TL_XD_PYPOSPER
union
select 4 a,to_char(RIQI||NAME||'产生了个人账户境外大额消费预警') b,RIQI c,0 d  from V_INDEX2_5
union
select 5 a,to_char(to_char(JBSJ,'yyyymmdd')||'产生了投诉举报') b,to_char(JBSJ,'yyyymmdd') c,0 d  from TSJB_ALL
order by  c desc