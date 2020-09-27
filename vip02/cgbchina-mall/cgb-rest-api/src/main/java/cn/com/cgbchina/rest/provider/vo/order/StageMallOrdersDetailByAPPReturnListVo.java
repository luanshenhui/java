package cn.com.cgbchina.rest.provider.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class StageMallOrdersDetailByAPPReturnListVo {
	@XMLNodeName(value = "order_id")
	private String orderId;
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	private String ordertypeId;
	@XMLNodeName(value = "goodssend_flag")
	private String goodssendFlag;
	@XMLNodeName(value = "create_date")
	private String createDate;
	@XMLNodeName(value = "create_time")
	private String createTime;
	@XMLNodeName(value = "goodssend_date")
	private String goodsSendDate;
	@XMLNodeName(value = "goodssend_time")
	private String goodsSendTime;
	@XMLNodeName(value = "send_time")
	private String sendTime;
	@XMLNodeName(value = "is_invoice")
	private String isInvoice;
	@XMLNodeName(value = "invoice_type")
	private String invoiceType;
	private String invoice;
	@XMLNodeName(value = "invoice_content")
	private String invoiceContent;
	@XMLNodeName(value = "ordermain_desc")
	private String ordermainDesc;
	@XMLNodeName(value = "csg_address")
	private String csgAddress;
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
	@XMLNodeName(value = "csg_name")
	private String csgName;
	@XMLNodeName(value = "csg_postcode")
	private String csgPostcode;
	@XMLNodeName(value = "csg_phone1")
	private String csgPhone1;
	@XMLNodeName(value = "csg_phone2")
	private String csgPhone2;
	@XMLNodeName(value = "goods_oid")
	private String goodsOid;
	@XMLNodeName(value = "goods_mid")
	private String goodsMid;
	@XMLNodeName(value = "goods_nm")
	private String goodsNm;
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	@XMLNodeName(value = "single_price")
	private String singlePrice;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "per_stage")
	private String perStage;
	private String privilegeId;
	private String privilegeName;
	private Double privilegeMoney;
	private String discountPrivilege;
	private String discountPrivMon;
	@XMLNodeName(value = "single_bonus")
	private String singleBonus;
	@XMLNodeName(value = "goods_xid")
	private String goodsXid;
	@XMLNodeName(value = "jf_type")
	private String jfType;
	@XMLNodeName(value = "total_point")
	private String totalPoint;
	private String operTime;
	private String orderComments;
	private String operateName;

	public static void main(String[] args) {
		System.out.println(StageMallOrdersDetailByAPPReturnListVo.class.getDeclaredFields().length);
	}
}
