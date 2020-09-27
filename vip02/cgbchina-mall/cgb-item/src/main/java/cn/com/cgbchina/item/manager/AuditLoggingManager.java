package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.AuditLoggingDao;
import cn.com.cgbchina.item.model.AuditLoggingModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 陈乐 on 2016/5/6.
 */

@Component
@Transactional
public class AuditLoggingManager {
	@Resource
	private AuditLoggingDao auditLoggingDao;

	public Integer create(AuditLoggingModel auditLoggingModel) {
		return auditLoggingDao.insert(auditLoggingModel);
	}
}
