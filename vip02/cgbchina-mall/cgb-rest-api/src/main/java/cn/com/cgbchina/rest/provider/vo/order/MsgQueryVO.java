package cn.com.cgbchina.rest.provider.vo.order;

import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * 短彩信回执接口 对应xml报文生成的对象
 * 
 * @author Lizy
 *
 */
@Setter
@Getter
public class MsgQueryVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4696411964327587132L;
	@NotNull
	@XMLNodeName(value = "orderno")
	private String orderNo;

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	@NotNull
	@XMLNodeName(value = "suborderno")
	private String suborderNo;

	@NotNull
	@XMLNodeName(value = "msgtype")
	private String msgType;

	@XMLNodeName(value = "mobile")
	private String mobile;

	@XMLNodeName(value = "status")
	private String status;

	@XMLNodeName(value = "statusmsg")
	private String statusMsg;
}
