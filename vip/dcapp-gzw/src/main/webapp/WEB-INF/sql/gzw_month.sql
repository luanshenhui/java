SELECT "12"||','||"11"||','||"10"||','||"9"||','||"8"||','||"7"||','||"6"||','||"5"||','||"4"||','||"3"||','||"2"||','||"1"||'' AS "MON" FROM(select 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -11),'MM'))||'月' AS "12", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -10),'MM'))||'月' AS "11", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -9),'MM'))||'月' AS "10", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -8),'MM'))||'月' AS "9", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -7),'MM'))||'月' AS "8", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -6),'MM'))||'月' AS "7", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -5),'MM'))||'月' AS "6", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -4),'MM'))||'月' AS "5", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -3),'MM'))||'月' AS "4", 
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -2),'MM'))||'月' AS "3",
 TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1),'MM'))||'月' AS "2",
 TO_NUMBER(TO_CHAR(sysdate,'MM'))||'月' AS "1"
 from dual)