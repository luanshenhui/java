package cn.com.cgbchina.rest.provider.model.order;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class StageMallOrdersDetailByAPPReturnList {
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
	private String operTime;
	private String orderComments;
	private String operateName;
}
