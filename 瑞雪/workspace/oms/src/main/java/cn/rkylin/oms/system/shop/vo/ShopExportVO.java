package cn.rkylin.oms.system.shop.vo;

/**
 * 店铺值对象，用于满足导出
 * 
 * @author jinshen
 * @version 1.0
 * @created 13-2月-2017 09:11:15
 */
public class ShopExportVO extends ShopVO {

	/**
	 * 启用状态
	 */
	private String status;
	
	/**
	 * 有效状态
	 */
	private String validateStatus;
	
	public String getStatus() {
		return this.status;
	}
	
	/**
	 * 设置列表上的状态列label
	 * @param status
	 */
	public void setStatus(String status) {
		if (this.getEnable().equalsIgnoreCase("y")) {
			this.status = "是";
		} else {
			this.status = "否";
		}
	}

	public String getValidateStatus() {
		return validateStatus;
	}

	public void setValidateStatus(String validateStatus) {
		if (this.getValidate().equalsIgnoreCase("y")) {
			this.validateStatus = "是";
		} else {
			this.validateStatus = "否";
		}
	}
}
