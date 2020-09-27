package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.MsgQuery;
import cn.com.cgbchina.rest.provider.model.order.MsgReceipReturn;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.service.order.MsgReceiptService;
import cn.com.cgbchina.rest.provider.vo.order.MsgQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.MsgReceipReturnVO;

/**
 * 短彩信回执接 从xml对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 * @param <Req>
 * @param <Resp>
 */
@TradeCode(value = "23")
@Service
@Slf4j
public class MsgReceiptProviderServiceImpl implements
		XMLProvideService<MsgQueryVO, MsgReceipReturnVO> {
	@Resource
	MsgReceiptService MsgReceiptService;

	@Override
	public MsgReceipReturnVO process(MsgQueryVO model) {

		MsgQuery msgQuery = BeanUtils.copy(model, MsgQuery.class);
		MsgReceipReturn msgReceipReturn = MsgReceiptService
				.getMsgReceipt(msgQuery);
		return BeanUtils.copy(msgReceipReturn, MsgReceipReturnVO.class);

	}

}
