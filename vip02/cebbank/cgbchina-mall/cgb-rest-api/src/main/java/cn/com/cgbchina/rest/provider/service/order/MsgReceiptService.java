package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.MsgQuery;
import cn.com.cgbchina.rest.provider.model.order.MsgReceipReturn;

/**
 * 短彩信回执接口
 * 
 * @author Lizy
 *
 */
public interface MsgReceiptService {
	MsgReceipReturn getMsgReceipt(MsgQuery msgQuery);
}
