--------------------------------------------
-- Export file for user CCQ@LSH_ORACLE    --
-- Created by css on 2018/10/08, 11:19:08 --
--------------------------------------------

set define off
spool oracle.log

prompt
prompt Creating table LSHTABLE
prompt =======================
prompt
create table CCQ.LSHTABLE
(
  sys_id NUMBER,
  name   VARCHAR2(20)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table POST
prompt ===================
prompt
create table CCQ.POST
(
  post_id             NUMBER,
  forum_id            NUMBER,
  user_id             NUMBER,
  post_title          VARCHAR2(20),
  post_content        VARCHAR2(20),
  total_comment_count NUMBER,
  post_time           TIMESTAMP(6) not null
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table SALARY
prompt =====================
prompt
create table CCQ.SALARY
(
  employeeid  NUMBER,
  salaryvalue NUMBER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating procedure EMP_DEMO5
prompt ============================
prompt
create or replace procedure ccq.emp_demo5(empsalary out sys_refcursor) AS ---?â èWoracl?
begin
  OPEN empsalary FOR
  SELECT s.employeeid,s.salaryvalue from salary s;
end emp_demo5;
/

prompt
prompt Creating procedure P_TEST
prompt =========================
prompt
create or replace procedure ccq.P_TEST(userId in number,v_cursor OUT sys_refcursor)
as
str_sql varchar2(400);
begin
     str_sql :='select POST_ID, FORUM_ID, USER_ID, POST_TITLE, POST_CONTENT, POST_TIME, TOTAL_COMMENT_COUNT from POST where 1=1';
     if userId is not null then
       str_sql := str_sql || ' and USER_ID like '||chr(39)||'%'||userId||'%'||chr(39);
     end if;
     -- dbms_output.put_line(str_sql);
    -- EXECUTE sp_executesql str_sql
     OPEN v_cursor FOR str_sql;
end;
/


spool off
