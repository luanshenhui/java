prompt PL/SQL Developer import file
prompt Created on 2018”N10ŒŽ8“ú by css
set feedback off
set define off
prompt Disabling triggers for LSHTABLE...
alter table LSHTABLE disable all triggers;
prompt Disabling triggers for POST...
alter table POST disable all triggers;
prompt Disabling triggers for SALARY...
alter table SALARY disable all triggers;
prompt Deleting SALARY...
delete from SALARY;
commit;
prompt Deleting POST...
delete from POST;
commit;
prompt Deleting LSHTABLE...
delete from LSHTABLE;
commit;
prompt Loading LSHTABLE...
insert into LSHTABLE (sys_id, name)
values (1, 'zhang');
insert into LSHTABLE (sys_id, name)
values (2, 'kaite');
commit;
prompt 2 records loaded
prompt Loading POST...
insert into POST (post_id, forum_id, user_id, post_title, post_content, total_comment_count, post_time)
values (2, 2, 2, '2', '2', 2, to_timestamp('10-08-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into POST (post_id, forum_id, user_id, post_title, post_content, total_comment_count, post_time)
values (1, 1, 1, '1', '1', 1, to_timestamp('10-08-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
commit;
prompt 2 records loaded
prompt Loading SALARY...
insert into SALARY (employeeid, salaryvalue)
values (1, 1);
insert into SALARY (employeeid, salaryvalue)
values (2, 3);
insert into SALARY (employeeid, salaryvalue)
values (4, 4);
commit;
prompt 3 records loaded
prompt Enabling triggers for LSHTABLE...
alter table LSHTABLE enable all triggers;
prompt Enabling triggers for POST...
alter table POST enable all triggers;
prompt Enabling triggers for SALARY...
alter table SALARY enable all triggers;
set feedback on
set define on
prompt Done.
