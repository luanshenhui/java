package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.VendorMessageDao;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

import static com.google.common.base.Objects.equal;

/**
 * Created by 张成 on 16-4-25.
 */
@Service
@Slf4j
public class NewMessageServiceImpl implements NewMessageService {

	@Resource
	VendorMessageDao vendorMessageDao;

	@Override
	public Response<Long> find(User user) {
		// 实例化返回response
		Response<Long> response = new Response<Long>();
		// 实例化查询参数
		Map<String, Object> paramMap = Maps.newHashMap();
		String vendorId = user.getVendorId();
		if (StringUtils.isNotEmpty(vendorId) && !equal(vendorId, "0")) {
			paramMap.put("vendorId", vendorId);
			// 只查找未读的
			paramMap.put("isRead", Contants.VENDOR_MESSAGE_READ_0);
		}
		try {
			// 查找数据库中未读的消息树
			Long count = vendorMessageDao.findNewCount(paramMap);
			// 返回
			response.setResult(count);
		} catch (Exception e) {
			log.error("get.new.message.error", Throwables.getStackTraceAsString(e));
			response.setError("get.new.message.error");
			return response;
		}
		return response;
	}
}
