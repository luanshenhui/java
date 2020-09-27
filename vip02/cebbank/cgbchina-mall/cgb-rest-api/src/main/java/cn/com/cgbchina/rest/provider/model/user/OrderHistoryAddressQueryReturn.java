package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL114 订单历史地址信息查询返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class OrderHistoryAddressQueryReturn extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 6405993242731286785L;
	private List<OrderHistoryAddressQueryDetailReturn> addresses = new ArrayList<OrderHistoryAddressQueryDetailReturn>();

	public List<OrderHistoryAddressQueryDetailReturn> getAddresses() {
		return addresses;
	}

	public void setAddresses(List<OrderHistoryAddressQueryDetailReturn> addresses) {
		this.addresses = addresses;
	}

}
