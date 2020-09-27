package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL422 微信易信验证码查询 验证码和订单信息
 * 
 * @author lizy 2016/4/28.
 */
public class WXYXVerificationCodeInfoVO extends BaseEntityVO implements
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 901813048332620248L;
	private String orderId;
	private String curStatusId;
	@XMLNodeName(value = "vendor_fnm")
	private String vendorFnm;
	@XMLNodeName(value = "verify_code")
	private String verifyCode;
	@XMLNodeName(value = "validate_status")
	private String validateStatus;
	@XMLNodeName(value = "create_date")
	private String createDate;
	@XMLNodeName(value = "create_time")
	private String createTime;
	@XMLNodeName(value = "goods_nm")
	private String goodsNm;

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getVerifyCode() {
		return verifyCode;
	}

	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}

	public String getValidateStatus() {
		return validateStatus;
	}

	public void setValidateStatus(String validateStatus) {
		this.validateStatus = validateStatus;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

}
