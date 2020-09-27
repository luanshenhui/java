package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL108 CC积分商城订单详细信息返回对象
 * 
 * @author lizy
 */
public class CCIntergralOrderDetailReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = -8638921063436510003L;
	@NotNull
	private String channelSN;
	@NotNull
	private String successCode;
	@NotNull
	private String orderMainId;
	private String orderDate;
	@NotNull
	private String postCode;
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@NotNull
	private String deliveryAddr;
	@NotNull
	private String deliveryName;
	@NotNull
	private String deliveryMobile;
	@NotNull
	private String deliveryPhone;
	@XMLNodeName(value = "do_date")
	private String doDate;
	@XMLNodeName(value = "transcorp_nm")
	private String transcorpNm;
	@XMLNodeName(value = "mailing_mun")
	private String mailingMun;
	@XMLNodeName(value = "service_phone")
	private String servicePhone;
	@NotNull
	private String loopTag;
	@NotNull
	private String loopCount;
	private List<CCIntergralOrderDetailChildrenVO> childOrders = new ArrayList<CCIntergralOrderDetailChildrenVO>();

	public List<CCIntergralOrderDetailChildrenVO> getChildOrders() {
		return childOrders;
	}

	public void setChildOrders(List<CCIntergralOrderDetailChildrenVO> childOrders) {
		this.childOrders = childOrders;
	}

	public String getChannelSN() {
		return channelSN;
	}

	public void setChannelSN(String channelSN) {
		this.channelSN = channelSN;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public String getCsgProvince() {
		return csgProvince;
	}

	public void setCsgProvince(String csgProvince) {
		this.csgProvince = csgProvince;
	}

	public String getCsgCity() {
		return csgCity;
	}

	public void setCsgCity(String csgCity) {
		this.csgCity = csgCity;
	}

	public String getDeliveryAddr() {
		return deliveryAddr;
	}

	public void setDeliveryAddr(String deliveryAddr) {
		this.deliveryAddr = deliveryAddr;
	}

	public String getDeliveryName() {
		return deliveryName;
	}

	public void setDeliveryName(String deliveryName) {
		this.deliveryName = deliveryName;
	}

	public String getDeliveryMobile() {
		return deliveryMobile;
	}

	public void setDeliveryMobile(String deliveryMobile) {
		this.deliveryMobile = deliveryMobile;
	}

	public String getDeliveryPhone() {
		return deliveryPhone;
	}

	public void setDeliveryPhone(String deliveryPhone) {
		this.deliveryPhone = deliveryPhone;
	}

	public String getDoDate() {
		return doDate;
	}

	public void setDoDate(String doDate) {
		this.doDate = doDate;
	}

	public String getTranscorpNm() {
		return transcorpNm;
	}

	public void setTranscorpNm(String transcorpNm) {
		this.transcorpNm = transcorpNm;
	}

	public String getMailingMun() {
		return mailingMun;
	}

	public void setMailingMun(String mailingMun) {
		this.mailingMun = mailingMun;
	}

	public String getServicePhone() {
		return servicePhone;
	}

	public void setServicePhone(String servicePhone) {
		this.servicePhone = servicePhone;
	}

	public String getLoopTag() {
		return loopTag;
	}

	public void setLoopTag(String loopTag) {
		this.loopTag = loopTag;
	}

	public String getLoopCount() {
		return loopCount;
	}

	public void setLoopCount(String loopCount) {
		this.loopCount = loopCount;
	}
}
