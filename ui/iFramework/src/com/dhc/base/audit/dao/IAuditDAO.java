package com.dhc.base.audit.dao;

import com.dhc.base.audit.vo.AuditVO;

/**
 * brief description
 * <p>
 * Date : 2012-07-12
 * </p>
 * <p>
 * Module : 日志记录接口
 * </p>
 * <p>
 * Description: 提供记录日志接口定义
 * </p>
 * <p>
 * Remark : 为系统提供了公共日志记录方法
 * </p>
 * <p>
 * --------------------------------------------------------------
 * </p>
 * <p>
 * 修改历史
 * </p>
 * <p>
 * 序号 日期 修改人 修改原因
 * </p>
 * <p>
 * 1
 * </p>
 */
public interface IAuditDAO {
	public void insertAudit(AuditVO auditVO);

}
