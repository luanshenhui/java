SELECT CASE TO_CHAR(SUBSTR(POWER_ID,3,1)) WHEN 'A' THEN '投资运营' 
                                 WHEN 'B' THEN '业绩考核'
                                 WHEN 'C' THEN '经营性资产监管'
                                 WHEN 'D' THEN '产权管理'
                                 WHEN 'E' THEN '财务监督'
                                 WHEN 'F' THEN '改革重组' END AS "DATA_TITLE", COUNT(1) AS "DATA_COUNT"
FROM DCA_RISK_MANAGE
WHERE SUBSTR(POWER_ID,1,2) = :arr1
        AND (DEFINE_STATUS = '1' OR DEFINE_STATUS = '3')
		AND UPDATE_DATE BETWEEN ADD_MONTHS(SYSDATE, :arr2) AND SYSDATE
GROUP BY SUBSTR(POWER_ID,3,1)
ORDER BY LENGTH(DATA_TITLE) ASC
