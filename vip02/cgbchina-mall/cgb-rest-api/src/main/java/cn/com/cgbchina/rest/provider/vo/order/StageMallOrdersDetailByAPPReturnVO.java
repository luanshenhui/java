package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
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
public class StageMallOrdersDetailByAPPReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1098704262936836563L;
	@XMLNodeName(value = "order_id")
	private String orderId;
	@XMLNodeName(value = "cur_status_id")
	private String curStatusId;
	@XMLNodeName(value = "ordertype_id ")
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
	@XMLNodeName(value = "goods_price")
	private String goodsPrice;
	@XMLNodeName(value = "goods_size")
	private String goodsSize;
	@XMLNodeName(value = "goods_color")
	private String goodsColor;
	@XMLNodeName(value = "vendor_role")
	private String vendorRole;
	@XMLNodeName(value = "mailing_num")
	private String mailingNum;
	@XMLNodeName(value = "service_url")
	private String serviceUrl;
	private List<StageMallOrdersDoByAPPVO> stageMallOrdersDos;
	@XMLNodeName(value = "picture_url")
	private String pictureUrl;
	@XMLNodeName(value = "VENDOR_FNM")
	private String vendorFnm;
	private String cardNo;
	private String orderMainId;
	@XMLNodeName(value = "vendor_phone")
	private String vendorPhone;
	@XMLNodeName(value = "mainmer_id")
	private String mainmerId;
	private String tradeSeqNo;
	@XMLNodeName(value = "mer_id")
	private String merId;
	private String cardtype;
	@XMLNodeName(value = "RECEIVED_TIME")
	private String receivedTime;
	@XMLNodeName(value = "GOODS_MODEL")
	private String goodsModel;
	@XMLNodeName(value = "goods_attr1")
	private String goodsAttr1;
	@XMLNodeName(value = "goods_attr2")
	private String goodsAttr2;
	
}
