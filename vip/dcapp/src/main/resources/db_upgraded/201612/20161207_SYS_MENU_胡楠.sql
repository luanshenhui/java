/**系统菜单四个表格权限更新**/

/** START **/
UPDATE SYS_MENU SET SYS_MENU.HREF = '/dca/dcaReportAlarmMsg', SYS_MENU.PERMISSION = 'dca:dcaReportAlarmMsg:view' WHERE SYS_MENU.ID = '97551869a914477794d90f0aad72e135';

UPDATE SYS_MENU SET SYS_MENU.HREF = '/dca/dcaReportAlarmCount', SYS_MENU.PERMISSION = 'dca:dcaReportAlarmCount:view' WHERE SYS_MENU.ID = '83729dbf78d143f1af0ffc3fbb8d8e4e';

UPDATE SYS_MENU SET SYS_MENU.HREF = '/dca/dcaReportRiskMes', SYS_MENU.PERMISSION = 'dca:dcaReportRiskMes:view' WHERE SYS_MENU.ID = '9273990982ce48b79d1edcb9d7871e4f';

UPDATE SYS_MENU SET SYS_MENU.HREF = '/dca/dcaReportRiskCount', SYS_MENU.PERMISSION = 'dca:dcaReportRiskCount:view' WHERE SYS_MENU.ID = '488c1149cdb346f19413430c37a01622';

/** END **/