package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

public class PayReturnOrderVo  implements Serializable {
	private static final long serialVersionUID = 1085534149753443959L;
	private String vendor_id;

	private String order_id;

	private String money;
	
	private String point;
	
	private String host_id;//积分流水号
	
	private String result_code;//异常码
	
	private String excep_dec;//异常描述信息

	private String returnCode;

	public String getHost_id() {
		return host_id;
	}

	public void setHost_id(String host_id) {
		this.host_id = host_id;
	}

	public String getResult_code() {
		return result_code;
	}

	public void setResult_code(String excep_code) {
		this.result_code = excep_code;
	}

	public String getExcep_dec() {
		return excep_dec;
	}

	public void setExcep_dec(String excep_dec) {
		this.excep_dec = excep_dec;
	}
	public void setPoint(String point) {
		this.point = point;
	}
	
	public String getPoint() {
		return point;
	}
	
	public String getMoney() {
		return money;
	}

	public void setMoney(String money) {
		this.money = money;
	}

	public String getOrder_id() {
		return order_id;
	}

	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}

	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public String getVendor_id() {
		return vendor_id;
	}

	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}

}
