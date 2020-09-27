package com.dhc.base.audit.service.impl;

import com.dhc.base.audit.dao.IAuditDAO;
import com.dhc.base.audit.service.AuditService;
import com.dhc.base.audit.vo.AuditVO;
import com.dhc.base.exception.BaseDataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.log.LogLevel;
import com.dhc.base.log.SysLog;

public class AuditServiceImpl implements AuditService {
	private IAuditDAO auditDAO;

	public void insertAudit(AuditVO auditVO) throws ServiceException {
		try {
			auditDAO.insertAudit(auditVO);
		} catch (BaseDataAccessException e) {
			SysLog.writeLogs("AuditServiceImpl--insertAudit: ", LogLevel.INFO, e.getMessage());
			throw new ServiceException(e.getMessage());
		} catch (Exception e) {
			SysLog.writeLogs("AuditServiceImpl--insertAudit: ", LogLevel.INFO, e.getMessage());
			throw new ServiceException("记录日志异常");
		}
	}

	public void setAuditDAO(IAuditDAO auditDAO) {
		this.auditDAO = auditDAO;
	}

	public IAuditDAO getAuditDAO() {
		return this.auditDAO;
	}
}
