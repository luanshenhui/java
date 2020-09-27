package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 * 
 */
@Setter
@Getter
public class StageMallOrdersQueryByAPPVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4179361762244623415L;
	@NotNull
	private String origin;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	@NotNull
	private String rowsPage;
	@NotNull
	private String currentPage;
	private String orderType;
	@XMLNodeName(value = "cur_status_ids")
	private String curStatusIds;
	@XMLNodeName("pay_on")
	private String payOn;
}
