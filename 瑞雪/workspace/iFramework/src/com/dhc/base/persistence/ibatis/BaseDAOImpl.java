package com.dhc.base.persistence.ibatis;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.base.common.BaseParameters;
import com.dhc.base.exception.BaseDataAccessException;
import com.dhc.base.log.LogLevel;
import com.dhc.base.log.SysLog;

public class BaseDAOImpl extends SqlMapClientDaoSupport {

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述 : 获得序列
	 * </p>
	 * <p>
	 * 备注 :
	 * </p>
	 * 
	 * @param String
	 * @return String
	 * @throws BaseDataAccessException
	 */
	public String getSequence(String seqNameStr) throws BaseDataAccessException {
		String seqIdStr = null;

		// 设置获得序列储存过程参数
		Map paramsMap = new HashMap();
		paramsMap.put("seqId", ""); // 储存过程返回的序列
		paramsMap.put("seqName", seqNameStr); // 序列标识
		paramsMap.put("onCode", 0); // 储存过程异常标识
		paramsMap.put("osMsg", ""); // 储存过程异常信息

		// 使用的是SYBASE数据库
		if ("sybase".equals(BaseParameters.DATA_BASE)) {
			seqIdStr = getSybaseSequence(paramsMap);
		}
		// 使用的是ORACLE数据库
		else if ("oracle".equals(BaseParameters.DATA_BASE)) {
			seqIdStr = getOralceSequence(seqNameStr);
		}

		return seqIdStr;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述 : 获得sybase序列
	 * </p>
	 * <p>
	 * 备注 :
	 * </p>
	 * 
	 * @param paramsMap
	 * @return String
	 * @throws BaseDataAccessException
	 */
	public String getSybaseSequence(Map paramsMap) throws BaseDataAccessException {

		try {
			this.getSqlMapClient().queryForObject("Sequence.getSybaseSequence", paramsMap);
			int onCodeInt = ((Integer) paramsMap.get("onCode")).intValue();
			if (0 != onCodeInt) {
				throw new BaseDataAccessException((String) paramsMap.get("osMsg"));
			}
		} catch (DataAccessException e) {
			SysLog.writeExceptionLogs("BaseDao--getSybaseSequence: ", LogLevel.ERROR, e.getMessage(), e);
			throw new BaseDataAccessException(e);
		} catch (SQLException e) {
			SysLog.writeExceptionLogs("BaseDao--getSybaseSequence: ", LogLevel.ERROR, e.getMessage(), e);
			throw new BaseDataAccessException(e);
		}
		return (String) paramsMap.get("seqId");
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述 : 获得oracle序列
	 * </p>
	 * <p>
	 * 备注 :
	 * </p>
	 * 
	 * @param paramsMap
	 * @return String
	 * @throws BaseDataAccessException
	 */
	public String getOralceSequence(String seqNameStr) throws BaseDataAccessException {
		String theNextId;
		try {
			theNextId = (String) this.getSqlMapClient().queryForObject("Sequence.getOracleSequence", seqNameStr);
		} catch (DataAccessException e) {
			SysLog.writeExceptionLogs("BaseDao--getOralceSequence: ", LogLevel.ERROR, e.getMessage(), e);
			throw new BaseDataAccessException(e);
		} catch (SQLException e) {
			SysLog.writeExceptionLogs("BaseDao--getOralceSequence: ", LogLevel.ERROR, e.getMessage(), e);
			throw new BaseDataAccessException(e);
		}
		return theNextId;
	}
}
