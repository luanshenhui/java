package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL114 订单历史地址信息查询返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class OrderHistoryAddressQueryReturnVO extends BaseEntityVO implements Serializable {

	private static final long serialVersionUID = 6405993242731286785L;
	private List<OrderHistoryAddressQueryDetailReturnVO> addresses = new ArrayList<OrderHistoryAddressQueryDetailReturnVO>();

	public List<OrderHistoryAddressQueryDetailReturnVO> getAddresses() {
		return addresses;
	}

	public void setAddresses(List<OrderHistoryAddressQueryDetailReturnVO> addresses) {
		this.addresses = addresses;
	}

}
