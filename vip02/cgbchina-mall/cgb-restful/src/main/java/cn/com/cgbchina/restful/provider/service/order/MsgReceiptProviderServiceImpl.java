package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.related.model.InfoOutSystemModel;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.MsgQuery;
import cn.com.cgbchina.rest.provider.model.order.MsgReceipReturn;
import cn.com.cgbchina.rest.provider.model.order.MsgReceiptOrderInfo;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.vo.order.MsgQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.MsgReceipReturnVO;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 短彩信回执接 从xml对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 *
 */
@TradeCode(value = "23")
@Service
@Slf4j
public class MsgReceiptProviderServiceImpl implements XMLProvideService<MsgQueryVO, MsgReceipReturnVO> {

	@Resource
	private MessageSources messageSources;

	@Resource
	private OrderService orderService;

	@Resource
	InfoOutSystemService infoOutSystemService;

	@Override
	public MsgReceipReturnVO process(MsgQueryVO model) {
		MsgReceipReturn msgReceipReturn = new MsgReceipReturn();
		try {
			MsgQuery msgQuery = BeanUtils.copy(model, MsgQuery.class);
			log.info("MsgReceiptProviderService.getMsgReceipt Start");
			log.info("短彩信回执接口报文：" + msgQuery);

			// 请求报文为null
			checkArgument(msgQuery != null, "order.msgReceipt.null");
			// 订单ID为null
			checkArgument(!Strings.isNullOrEmpty(msgQuery.getOrderNo()), "order.msgReceipt.orderno.null");

			boolean bHaveSendCode = true;
				String subOrderNo = msgQuery.getSuborderNo();
				String msgType = msgQuery.getMsgType();
				String status = msgQuery.getStatus();

				// 小订单ID为null
				checkArgument(!Strings.isNullOrEmpty(subOrderNo), "order.msgReceipt.suborderno.null");
				// 小订单信息类型为null
				checkArgument(!Strings.isNullOrEmpty(msgType), "order.msgReceipt.msgtype.null");
				// 小订单发送状态为null
				checkArgument(!Strings.isNullOrEmpty(status), "order.msgReceipt.status.null");

				// 查找 小订单 对应的 订单
				Response<OrderSubModel> responseOrderSubModel = orderService.validateBackMsg(subOrderNo);

				// 小订单在系统中不存在
				checkArgument(responseOrderSubModel.isSuccess() && responseOrderSubModel.getResult() != null,
						"order.msgReceipt.suborderno.notExists");

				// 判断是否已经存在
				Response<List<InfoOutSystemModel>> responseInfoOutSystemModel = infoOutSystemService
						.findByOrderId(subOrderNo);
				// 如果存在，则更改回执状态
				if (responseInfoOutSystemModel.isSuccess() && responseInfoOutSystemModel.getResult().size() > 0) {
					InfoOutSystemModel infoOutSystemModel = responseInfoOutSystemModel.getResult().get(0);
					InfoOutSystemModel infoOutModel = new InfoOutSystemModel();
					infoOutModel.setOrderId(infoOutSystemModel.getOrderId());
					infoOutModel.setMsgtype(infoOutSystemModel.getMsgtype());
					infoOutModel.setMobile(infoOutSystemModel.getMobile());
					infoOutModel.setStatus(infoOutSystemModel.getStatus());
					infoOutSystemService.insertMsgStatus(infoOutModel);
				} else {
					bHaveSendCode = false;
				}
			if (bHaveSendCode) {
				msgReceipReturn.setReturnCode("true");
				msgReceipReturn.setReturnDes("商城处理成功");
			} else {
				log.error("failed to getMsgReceipt, cause:{}, MsgQueryVO:{}",
						messageSources.get("order.msgReceipt.backToSendCode"),
						model);
				msgReceipReturn.setReturnCode("false");
				msgReceipReturn.setReturnDes("请先返回发码通知");
			}
		} catch (IllegalArgumentException e) {
			log.error("failed to getMsgReceipt, cause:{}, MsgQueryVO:{}",
					messageSources.get(Throwables.getStackTraceAsString(e)),
					model);
			msgReceipReturn.setReturnCode("false");

		} catch (Exception e) {
			log.error("failed to getMsgReceipt, cause:{}, MsgQueryVO:{}",
					e.getMessage(),
					model);
			msgReceipReturn.setReturnCode("false");
		} finally {
			log.info("MsgReceiptProviderService.getMsgReceipt End");
			return BeanUtils.copy(msgReceipReturn, MsgReceipReturnVO.class);
		}
	}
}
