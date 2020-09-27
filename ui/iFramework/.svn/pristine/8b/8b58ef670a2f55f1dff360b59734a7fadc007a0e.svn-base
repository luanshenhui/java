package com.dhc.base.audit.dao.ibatis;

import java.sql.SQLException;

import org.springframework.dao.DataAccessException;

import com.dhc.base.audit.dao.IAuditDAO;
import com.dhc.base.audit.vo.AuditVO;
import com.dhc.base.exception.BaseDataAccessException;
import com.dhc.base.log.LogLevel;
import com.dhc.base.log.SysLog;
import com.dhc.base.persistence.ibatis.BaseDAOImpl;

public class AuditDAOImpl extends BaseDAOImpl implements IAuditDAO {
	public void insertAudit(AuditVO auditVO) {
		try {
			this.getSqlMapClient().insert("AUDIT.insertAudit", auditVO);
		} catch (DataAccessException e) {
			SysLog.writeLogs("AuditDAOImpl--insertAudit: ", LogLevel.DEBUG, e.getMessage());
			throw new BaseDataAccessException(e);
		} catch (SQLException e) {
			SysLog.writeLogs("AuditDAOImpl--insertAudit: ", LogLevel.DEBUG, e.getMessage());
			throw new BaseDataAccessException(e);
		}
	}

}
