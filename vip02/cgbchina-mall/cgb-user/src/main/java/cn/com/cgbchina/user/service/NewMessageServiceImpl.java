package cn.com.cgbchina.user.service;

import static com.google.common.base.Objects.equal;

import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Strings;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.PersonalMessageDao;
import cn.com.cgbchina.user.dao.VendorMessageDao;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.manager.MessageManager;
import cn.com.cgbchina.user.model.PersonalMessageModel;
import cn.com.cgbchina.user.model.VendorMessageModel;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 张成 on 16-4-25.
 */
@Service
@Slf4j
public class NewMessageServiceImpl implements NewMessageService {

	@Resource
	VendorMessageDao vendorMessageDao;
	@Resource
	MessageManager messageManager;

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

	/**
	 * 站内消息插入
	 * 
	 * @param messageDto 输入参数
	 * @return 是否成功 失败原因
	 * message.is.empty:参数有空值， insert.vendor.message.error：插入供应商消息失败
	 * insert.personal.message.error：插入个人消息失败   insert.message.error： 插入失败
	 */
	@Override
	public Response insertUserMessage(MessageDto messageDto) {
		String curTime = DateHelper.getCurrentTime();
		Response response = Response.newResponse();
		// 校验参数
		if (Strings.isNullOrEmpty(messageDto.getOrderId()) || Strings.isNullOrEmpty(messageDto.getOrderStatus())
				|| Strings.isNullOrEmpty(messageDto.getGoodName())
				|| Strings.isNullOrEmpty(messageDto.getCreateOper())) {
			log.error("message.is.empty");
			response.setError("message.is.empty");
			return response;
		}
		try {

			VendorMessageModel vendorMessageModel = new VendorMessageModel();
			vendorMessageModel.setVendorId(messageDto.getVendorId());
			vendorMessageModel.setIsRead("0");// 未读
			vendorMessageModel.setCreateOper(messageDto.getCreateOper());
			vendorMessageModel.setModifyOper(messageDto.getCreateOper());
			vendorMessageModel.setOrderId(messageDto.getOrderId());

			PersonalMessageModel personalMessageModel = new PersonalMessageModel();
			personalMessageModel.setCustId(messageDto.getCustId());
			personalMessageModel.setIsRead("0");// 未读
			personalMessageModel.setCreateOper(messageDto.getCreateOper());
			personalMessageModel.setModifyOper(messageDto.getCreateOper());
			personalMessageModel.setUserType(messageDto.getUserType());
			personalMessageModel.setOrderId(messageDto.getOrderId());

			// 判断订单状态
			// 已废单
			if (Contants.SUB_ORDER_STATUS_0304.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0304.replace("$1", messageDto.getOrderId());
				personalMessageModel.setType("0");// 交易动态
				personalMessageModel.setContent(text);

				vendorMessageModel.setType("0");// 交易动态
				vendorMessageModel.setContent(text);
				messageManager.create(vendorMessageModel, personalMessageModel);
			}
			// 已取消
			if (Contants.SUB_ORDER_STATUS_7777.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0360.replace("$1", curTime);
				text = text.replace("$2", messageDto.getOrderId());
				vendorMessageModel.setType("0");// 交易动态
				vendorMessageModel.setContent(text);
				Integer i = messageManager.insert(vendorMessageModel);
				if (i != 1) {
					log.error("insert vendor message error");
					response.setError("insert.vendor.message.error");
					return response;
				}
			}
			// 支付失败
			if (Contants.SUB_ORDER_STATUS_0307.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0307.replace("$1", messageDto.getOrderId());
				personalMessageModel.setType("0");// 交易动态
				personalMessageModel.setContent(text);

				vendorMessageModel.setType("0");// 交易动态
				vendorMessageModel.setContent(text);
				messageManager.create(vendorMessageModel, personalMessageModel);
			}
			// 支付成功
			if (Contants.SUB_ORDER_STATUS_0308.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0308.replace("$1", curTime);
				text = text.replace("$2", messageDto.getOrderId());
				personalMessageModel.setType("0");// 交易动态
				personalMessageModel.setContent(text);

				vendorMessageModel.setType("0");// 交易动态
				vendorMessageModel.setContent(text);
				messageManager.create(vendorMessageModel, personalMessageModel);
			}
			// 已撤单
			if (Contants.SUB_ORDER_STATUS_0312.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0312.replace("$1", curTime);
				text = text.replace("$2", messageDto.getOrderId());
				personalMessageModel.setType("0");// 交易动态
				personalMessageModel.setContent(text);

				vendorMessageModel.setType("0");// 交易动态
				vendorMessageModel.setContent(text);
				messageManager.create(vendorMessageModel, personalMessageModel);
			}
			// 已发货
			if (Contants.SUB_ORDER_STATUS_0309.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0309.replace("$1", curTime);
				text = text.replace("$2", messageDto.getGoodName());
				personalMessageModel.setType("0");// 交易动态
				personalMessageModel.setContent(text);

				Integer i = messageManager.insert(personalMessageModel);
				if (i != 1) {
					log.error("insert personal message error");
					response.setError("insert.personal.message.error");
					return response;
				}
			}
			// 无人签收
			if (Contants.SUB_ORDER_STATUS_0381.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0381.replace("$1", messageDto.getOrderId());
				vendorMessageModel.setType("0");// 交易动态
				vendorMessageModel.setContent(text);

				Integer i = messageManager.insert(vendorMessageModel);
				if (i != 1) {
					log.error("insert vendor message error");
					response.setError("insert.vendor.message.error");
					return response;
				}
			}
			// 退货申请
			if (Contants.SUB_ORDER_STATUS_0334.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0334.replace("$1", curTime);
				text = text.replace("$2", messageDto.getGoodName());
				text = text.replace("$3", messageDto.getOrderId());
				vendorMessageModel.setType("2");// 逆向交易
				vendorMessageModel.setContent(text);

				Integer i = messageManager.insert(vendorMessageModel);
				if (i != 1) {
					log.error("insert vendor message error");
					response.setError("insert.vendor.message.error");
					return response;
				}
			}
			// 退货成功
			if (Contants.SUB_ORDER_STATUS_0327.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0327.replace("$1", curTime);
				text = text.replace("$2", messageDto.getGoodName());
				personalMessageModel.setType("1");// 售后信息
				personalMessageModel.setContent(text);

				Integer i = messageManager.insert(personalMessageModel);
				if (i != 1) {
					log.error("insert personal message error");
					response.setError("insert.personal.message.error");
					return response;
				}
			}
			// 拒绝退货申请
			if (Contants.SUB_ORDER_STATUS_0335.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0335.replace("$1", curTime);
				text = text.replace("$2", messageDto.getGoodName());
				personalMessageModel.setType("1");// 售后信息
				personalMessageModel.setContent(text);

				Integer i = messageManager.insert(personalMessageModel);
				if (i != 1) {
					log.error("insert personal message error");
					response.setError("insert.personal.message.error");
					return response;
				}
			}
			// 系统拒绝该订单
			if (Contants.SUB_ORDER_STATUS_0382.equals(messageDto.getOrderStatus())) {
				String text = Contants.M0382.replace("$1", messageDto.getOrderId());
				personalMessageModel.setType("1");// 售后信息
				personalMessageModel.setContent(text);

				vendorMessageModel.setType("2");// 逆向交易
				vendorMessageModel.setContent(text);
				messageManager.create(vendorMessageModel, personalMessageModel);
			}
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("insert message error");
			response.setError("insert.message.error");
			return response;
		}
	}
}
