package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.manager.AuditLoggingManager;
import cn.com.cgbchina.item.model.AuditLoggingModel;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by 陈乐 on 2016/5/6.
 */
@Service
@Slf4j
public class AuditLoggingServiceImpl implements AuditLoggingService {
	@Resource
	private AuditLoggingManager auditLoggingManager;

	@Override
	public Response<Integer> create(AuditLoggingModel auditLoggingModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(auditLoggingModel, "auditLoggingModel is null");
			Integer count = auditLoggingManager.create(auditLoggingModel);
			if (count > 0) {
				response.setResult(count);
				return response;
			} else {
				response.setError("create.log.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			response.setError("create.log.error");
			return response;
		}
	}
}
