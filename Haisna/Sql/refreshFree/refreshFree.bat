rem �ėp�e�[�u���S�Ƃ������o�b�`�t�@�C��
set userid=WEBHAINSLUKES2
set password=HAINS21ORAADMIN2
set conn=hainsdb

sqlplus %userid%/%password%@%conn% @disableConstraint.sql
SQLLDR USERID=%userid%/%password%@%conn%, CONTROL=insertfree.CTL direct=true
sqlplus %userid%/%password%@%conn% @enableConstraint.sql

