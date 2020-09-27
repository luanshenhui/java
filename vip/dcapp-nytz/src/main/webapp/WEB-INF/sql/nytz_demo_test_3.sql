SELECT
    b.NAME AS "bizOperPostName",
    b.PARENT_IDS AS parentIds,
    c.NAME AS "bizOperPersonName",
    a.RISK_MANAGE_ID AS "riskManageId",
    a.BIZ_ROLE_ID AS "bizRoleId",
    a.POWER_ID AS "powerId",
    a.RISK_ID AS "riskId",
    a.BIZ_FLOW_ID AS "bizFlowId",
    a.BIZ_FLOW_NAME AS "bizFlowName",
    a.BIZ_OPER_PERSON AS "bizOperPerson",
    a.BIZ_DATA_NAME AS "bizDataName",
    a.ALARM_LEVEL AS "alarmLevel",
    a.RISK_MSG AS "riskMsg",
    a.RISK_LEVEL AS "riskLevel",
    a.DEFINE_PERSON AS "definePerson",
    a.DEFINE_STATUS AS "defineStatus",
    d.label AS "defineStatusText",
    e.label AS "alarmColor"
FROM DCA_RISK_MANAGE a
LEFT JOIN SYS_OFFICE b ON a.BIZ_OPER_POST = b.ID
LEFT JOIN SYS_USER c ON a.BIZ_OPER_PERSON = c.ID
LEFT JOIN SYS_DICT d ON d.value = a.DEFINE_STATUS and d.TYPE ='define_status'
LEFT JOIN SYS_DICT e on e.value = a.ALARM_LEVEL and e.type ='alarm_level'
WHERE
  a.DEL_FLAG = '0'
<#if cPost??>
AND a.BIZ_OPER_POST =:cPost
</#if>

<#if cPerson??>
AND a.BIZ_OPER_PERSON =:cPerson
</#if>

<#if cStatus??>
AND a.DEFINE_STATUS =:cStatus
</#if>

ORDER BY a.UPDATE_DATE DESC