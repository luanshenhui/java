package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dao.MessageSettingDao;
import cn.com.cgbchina.related.dto.MessageSettingDto;
import cn.com.cgbchina.related.manager.MessageSettingManager;
import cn.com.cgbchina.related.model.MessageSettingModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by 11150721040343 on 16-4-26.
 */
@Service
@Slf4j
public class TradeSettingServiceImpl implements TradeSettingService {
	@Resource
	private MessageSettingDao messageSettingDao;
	@Resource
	private MessageSettingManager messageSettingManager;

	/**
	 * 更新开关设置
	 *
	 * @param messageSettingDto
	 * @return
	 */
	@Override
	public Response<Boolean> update(MessageSettingDto messageSettingDto) {
		Response<Boolean> result = new Response<Boolean>();
		// 把Dto中的值set到model中
		List<MessageSettingModel> messList = new ArrayList<MessageSettingModel>();
		// 支付
		MessageSettingModel message = new MessageSettingModel();
		message.setId(messageSettingDto.getTradeId());
		// 开关类型 0：商城公告显示开关  1：短信发送开关  2：支付开关',
		message.setSwichType("2");
		message.setIsOpen(messageSettingDto.getTradeOpen());
		messList.add(message);
		try {
			// 校验信息是否为空
			if (messList == null) {
				result.setError("update.message.error");
				result.setSuccess(false);
				return result;
			}
			// 更新支付开关
			Boolean response = messageSettingManager.update(messList.get(0));
			if (!response) {
				result.setError("update.message.error");
				result.setSuccess(false);
				return result;
			}
			result.setSuccess(true);
			result.setResult(response);
			return result;
		} catch (Exception e) {
			log.error("update.message.error", Throwables.getStackTraceAsString(e));
			result.setError("update.message.error");
			result.setSuccess(false);
			return result;
		}
	}
}
