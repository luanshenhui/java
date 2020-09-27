package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;
import lombok.Getter;
import lombok.Setter;

/**
 * MAL309 订单详细信息查询(分期商城)App
 * 
 * @author Lizy
 *
 */
@Setter
@Getter
public class StageMallOrdersDetailByAPPReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1098704262936836563L;

	private String orderId;
	private String curStatusId;
	private String ordertypeId;
	private String goodssendFlag;
	private String createDate;
	private String createTime;
	private String goodsSendDate;
	private String goodsSendTime;
	private String sendTime;
	private String isInvoice;
	private String invoiceType;
	private String invoice;
	private String invoiceContent;
	private String ordermainDesc;
	private String csgAddress;
	private String csgProvince;
	private String csgCity;
	private String csgBorough;
	private String csgName;
	private String csgPostcode;
	private String csgPhone1;
	private String csgPhone2;
	private String goodsOid;
	private String goodsMid;
	private String goodsNm;
	private String goodsNum;
	private String singlePrice;
	private String stagesNum;
	private String perStage;
	private String privilegeId;
	private String privilegeName;
	private Double privilegeMoney;
	private String discountPrivilege;
	private String discountPrivMon;
	private String singleBonus;
	private String goodsXid;
	private String jfType;

	private String totalPoint;
	private String goodsPrice;
	private String goodsSize;
	private String goodsColor;
	private String vendorRole;
	private String mailingNum;
	private String serviceUrl;
	private String pictureUrl;
	private String vendorFnm;
	private String cardNo;
	private String orderMainId;
	private String vendorPhone;
	private String mainmerId;
	private String tradeSeqNo;
	private String merId;
	private String cardtype;
	private String receivedTime;
	private String goodsModel;
	private String goodsAttr1;
	private String goodsAttr2;
	private List<StageMallOrdersDoByAPPReturn> stageMallOrdersDos;

	public List<StageMallOrdersDoByAPPReturn> getStageMallOrdersDos() {
		return stageMallOrdersDos;
	}

	public void setStageMallOrdersDos(List<StageMallOrdersDoByAPPReturn> stageMallOrdersDos) {
		this.stageMallOrdersDos = stageMallOrdersDos;
	}
}
