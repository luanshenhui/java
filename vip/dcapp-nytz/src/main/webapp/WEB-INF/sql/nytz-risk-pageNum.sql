SELECT COUNT(1) AS "totalCount"
FROM DCA_RISK_MANAGE a
WHERE a.DEL_FLAG = '0'
	<#if cPost??>
	AND a.BIZ_OPER_POST =:cPost
	</#if>

	<#if cPerson??>
	AND a.BIZ_OPER_PERSON =:cPerson
	</#if>

	<#if cStatus??>
	AND a.DEFINE_STATUS =:cStatus
	</#if>
