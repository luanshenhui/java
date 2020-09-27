		SELECT
			k2.KPI_ID kpiId,
			k2.IDX_TYPE idxType,
			c2.LABEL idxTypeName,
			k2.IDX_ID idxId,
			k2.IDX_NAME idxName,
			k2.KPI_RESULT kpiResult,
			k1.RESULT checkResultCode,
			c.LABEL checkResultText
		FROM
			(SELECT k.KPI_ID,
				max(i.IDX_RESULT) as result
			 FROM DCA_KPI k
			 LEFT JOIN DCA_KPI_IDX i
			 	ON (k.IDX_ID=i.IDX_ID AND k.KPI_RESULT >= i.CRITICALITY_VALUE AND i.DEL_FLAG = '0')
			 WHERE k.DEL_FLAG = '0'
			 GROUP BY k.KPI_ID) k1
		LEFT JOIN DCA_KPI k2 on k1.KPI_ID = k2.KPI_ID AND k2.DEL_FLAG = '0'
		LEFT JOIN SYS_DICT_CUSTOM c on (result = c.VALUE and c.TYPE='idx_result')
		LEFT JOIN SYS_DICT_CUSTOM c2 on (k2.IDX_TYPE = c2.VALUE and c2.TYPE='kpi_idx_type')
		ORDER BY k1.KPI_ID