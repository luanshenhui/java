package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dao.MessageSettingDao;
import cn.com.cgbchina.related.dto.MessageSettingDto;
import cn.com.cgbchina.related.manager.MessageSettingManager;
import cn.com.cgbchina.related.model.MessageSettingModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by yuxinxin on 16-4-24.
 */
@Service
@Slf4j
public class MessageSettingServiceImpl implements MessageSettingService {
	@Resource
	private MessageSettingDao messageSettingDao;
	@Resource
	private MessageSettingManager messageSettingManager;

	/**
	 * 开关设置
	 *
	 * @param messageSettingDto
	 * @return
	 */
	@Override
	public Response<Boolean> updateMessage(MessageSettingDto messageSettingDto,User user) {
		Response<Boolean> response = new Response<Boolean>();
		// 把Dto中的值set到model中
		List<MessageSettingModel> messList = new ArrayList<MessageSettingModel>();
		// 商城公告
		MessageSettingModel message = new MessageSettingModel();
		message.setId(messageSettingDto.getMallId());// 商城公告ID
		// 开关类型 0：商城公告显示开关  1：短信发送开关  2：支付开关',
		message.setSwichType("0");
		message.setIsOpen(messageSettingDto.getMallOpen());// 商城公告状态
		message.setCreateOper(user.getId());
		message.setModifyOper(user.getId());
		messList.add(message);
		// 短信发送
		message = new MessageSettingModel();
		message.setId(messageSettingDto.getMessageId());// 短信发送ID
		// 开关类型 0：商城公告显示开关  1：短信发送开关  2：支付开关',
		message.setSwichType("1");
		message.setIsOpen(messageSettingDto.getMessageOpen());// 短信开关状态
		message.setCreateOper(user.getId());
		message.setModifyOper(user.getId());
		messList.add(message);
		try {
			// 转换为list进行循环更新
			for (MessageSettingModel mess : messList) {
				// 更新
				Boolean result = messageSettingManager.update(mess);
				if (!result) {
					response.setError("update.message.error");
					return response;
				}
				response.setResult(result);
			}
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("updateMessage.error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.message.error");
			return response;
		}

	}

	/**
	 * 查询所有开关状态
	 *
	 * @return
	 */
	@Override
	public Response<MessageSettingDto> findAll() {
		Response<MessageSettingDto> response = new Response<MessageSettingDto>();
		// 查询所有开关状态
		try {
			List<MessageSettingModel> messageSettingList = messageSettingDao.findAll();
			MessageSettingDto messageSettingDto = new MessageSettingDto();
			// 循环model 将查询出的数据set到Dto中
			for (MessageSettingModel messageInfo : messageSettingList) {
				// 当Swich为0时 是商城公告显示开关
				if ("0".equals(messageInfo.getSwichType())) {
					messageSettingDto.setMallId(messageInfo.getId());
					messageSettingDto.setMallOpen(messageInfo.getIsOpen());
				}
				// 当Swich为1时 是短信发送开关
				if ("1".equals(messageInfo.getSwichType())) {
					messageSettingDto.setMessageId(messageInfo.getId());
					messageSettingDto.setMessageOpen(messageInfo.getIsOpen());
				}
				// 当Swich为2时 是支付开关
				if ("2".equals(messageInfo.getSwichType())) {
					messageSettingDto.setTradeId(messageInfo.getId());
					messageSettingDto.setTradeOpen(messageInfo.getIsOpen());
				}
			}
			response.setResult(messageSettingDto);
			return response;
		} catch (Exception e) {
			log.error("trade time query error", Throwables.getStackTraceAsString(e));
			response.setError("trade.time.query.error");
			return response;
		}
	}
}
