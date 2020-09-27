package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.AuditLoggingModel;
import com.spirit.common.model.Response;

/**
 * Created by 陈乐 on 2016/5/6.
 */
public interface AuditLoggingService {

	/**
	 * 增加一条审核记录
	 * 
	 * @param auditLoggingModel
	 * @return
	 */
	public Response<Integer> create(AuditLoggingModel auditLoggingModel);
}
