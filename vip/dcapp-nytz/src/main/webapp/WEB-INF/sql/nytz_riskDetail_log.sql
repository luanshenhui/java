SELECT
			u.NAME AS "definePerson",
			l.ACTION AS "action",
			to_char(l.CREATE_DATE,'yyyy-MM-dd HH24:mm:ss') AS "createDate"
FROM DCA_RISK_MANAGE_LOG l
LEFT JOIN SYS_USER u
	ON l.CREATE_PERSON = u.ID
WHERE l.DEL_FLAG='0'
AND l.RISK_MANAGE_ID=:riskManageId
