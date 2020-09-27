select 1111 num,DANGER_LEVEL from DCA_WARNING
where TYPE= :type and kind= :kind
group by DANGER_LEVEL
