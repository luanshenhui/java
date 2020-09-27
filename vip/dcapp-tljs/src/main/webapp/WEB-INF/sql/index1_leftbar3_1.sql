select count(*) as num from DCA_WARNING
where TYPE=2 and kind=2
and DANGER_LEVEL=3
UNION ALL
select count(*) from DCA_WARNING
where TYPE=2 and kind=2
and DANGER_LEVEL=2
UNION ALL
select count(*) from DCA_WARNING
where TYPE=2 and kind=2
and DANGER_LEVEL=1