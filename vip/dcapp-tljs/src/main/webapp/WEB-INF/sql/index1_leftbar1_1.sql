select count(*) as num from DCA_WARNING
where TYPE=1 and kind=1
and DANGER_LEVEL=3
UNION ALL
select count(*) from DCA_WARNING
where TYPE=1 and kind=1
and DANGER_LEVEL=2
UNION ALL
select count(*) from DCA_WARNING
where TYPE=1 and kind=1
and DANGER_LEVEL=1