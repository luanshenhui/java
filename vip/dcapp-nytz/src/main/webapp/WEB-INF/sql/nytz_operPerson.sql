SELECT id,name 
FROM SYS_USER 
WHERE (OFFICE_ID =:cPost OR OFFICE_ID IS NULL) and del_flag = '0'