SELECT
		a.ALARM_DETAIL_ID AS "alarmDetailId",
		a.BIZ_ROLE_ID AS"bizRoleId",
		a.POWER_ID AS "powerId",
		a.RISK_ID AS "riskId",
		a.BIZ_FLOW_ID AS "bizFlowId",
		a.BIZ_FLOW_NAME AS "bizFlowName",
		a.BIZ_OPER_PERSON AS "bizOperPerson",
		a.BIZ_OPER_POST AS "bizOperPost",
		b.NAME AS "bizOperPostName",
		a.BIZ_DATA_ID AS "bizDataId",
		a.BIZ_DATA_NAME AS "bizDataName",
		a.WF_ID AS "wfId",
		a.TASK_ID AS"taskId",
		a.TASK_NAME AS "taskName",
		a.ALARM_LEVEL AS "alarmLevel",
		a.ALARM_TYPE AS "alarmType",
		a.CPU_RESULT AS "cpuResult",
		a.ALARM_MSG AS"alarmMsg",
		a.ALARM_TIME_1ST AS "alarmTime1st",
		a.ALARM_STATUS AS"alarmStatus",
		a.VISUAL_SCOPE AS "visualScope",
		a.DEL_FLAG AS "delFlag",
		a.CREATE_PERSON AS "createPerson",
		a.CREATE_DATE AS "createDate",
		a.UPDATE_PERSON AS "updatePerson",
		a.UPDATE_DATE AS "updateDate",
		a.REMARKS AS "remarks",
		s.label AS "status",
		c.NAME AS "bizOperPersonName"
FROM DCA_ALARM_DETAIL a
LEFT JOIN SYS_OFFICE b ON a.BIZ_OPER_POST = b.ID
LEFT JOIN SYS_USER c ON a.BIZ_OPER_PERSON = c.ID
LEFT JOIN SYS_DICT s ON a.ALARM_LEVEL = s.value AND s.type = 'alarm_status'
WHERE
		a.DEL_FLAG = '0'
		
		<#if cPost??>
		AND a.BIZ_OPER_POST =:cPost
		</#if>
		
		<#if cPerson??>
		AND a.BIZ_OPER_PERSON LIKE '%'||:cPerson||'%' 
		</#if>
		
		<#if cStatus??>
		AND a.ALARM_STATUS = :cStatus 
		</#if>
		
		<#if cLevel??>
		AND a.ALARM_LEVEL = :cLevel
		</#if>
ORDER BY a.UPDATE_DATE DESC
		