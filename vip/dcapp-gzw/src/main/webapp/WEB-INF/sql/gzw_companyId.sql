select t1.VALUE as co_id,t1.LABEL as co_name
FROM SYS_DICT t1
WHERE  t1.TYPE='company_name' AND t1.VALUE=:coid