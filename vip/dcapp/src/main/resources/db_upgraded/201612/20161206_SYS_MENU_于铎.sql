/** 告警查询菜单链接更新 **/
/** START **/

UPDATE SYS_MENU SET SYS_MENU.HREF = '/dca/dcaAddcustomchart/addName', SYS_MENU.PERMISSION = 'addcustomchart:dcaAddcustomchart:view' WHERE SYS_MENU.ID = '35082e2859134a3397059a4dcca21961';
INSERT INTO SYS_MENU ("ID", "PARENT_ID", "PARENT_IDS", "NAME", "SORT", "HREF",  "IS_SHOW", "CREATE_BY", "CREATE_DATE", "UPDATE_BY", "UPDATE_DATE", "DEL_FLAG") VALUES ('9fda4db92c5a4ddfa6d188d722fc345c', '9580a29fc04c4816bd27d03cc4dadfc2', '0,1,4285bf22fd1542d9b5a7fdd9dac58ea8,9580a29fc04c4816bd27d03cc4dadfc2,', '我创建的', '5030', 'http://localhost:37799/WebReport/ReportServer?op=fr_bi&cmd=bi_init_created_by_me','1','1', TO_TIMESTAMP(' 2016-12-05 12:00:46:702000', 'SYYYY-MM-DD HH24:MI:SS:FF6'), '1', TO_TIMESTAMP(' 2016-12-06 10:13:11:927000', 'SYYYY-MM-DD HH24:MI:SS:FF6'),'0');
UPDATE SYS_MENU SET SYS_MENU.HREF = 'http://localhost:37799/WebReport/ReportServer?op=fr_bi_configure&cmd=init_configure_pane' WHERE SYS_MENU.ID = '809ff3d08f694024877d76850a8b4b8f';

/** END **/

