package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import lombok.Getter;

import lombok.Setter;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
@Setter
@Getter
public class StageMallOrdersQueryByAPP extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4179361762244623415L;
	private String origin;
	private String custId;
	private String curStatusId;
	private String rowsPage;
	private String currentPage;
	private String orderType;
	private String curStatusIds;
	private String payOn;

}
