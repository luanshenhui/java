package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.common.contants.Contants;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 张成 on 16-6-1.
 */
public class OrderCommitSubmit314Dto extends OrderCommitSubmitDto  implements Serializable {

	private static final long serialVersionUID = 5292077045219936873L;


	@Getter
	@Setter
	private List<OrderCommitInfo314Dto> orderCommitInfo314List;// 商品list
	@Getter
	@Setter
	private String origin;
	@Getter
	@Setter
	private String originNm;
	@Getter
	@Setter
	private String mallType;
	@Getter
	@Setter
	private String ordertypeId;
	@Getter
	@Setter
	private String totvalueYG;
	@Getter
	@Setter
	private String totvalueFQ;
	@Getter
	@Setter
	private String totalNum;
	@Getter
	@Setter
	private String createOper;
	@Getter
	@Setter
	private String contIdType;
	@Getter
	@Setter
	private String contIdcard;
	@Getter
	@Setter
	private String contNm;
	@Getter
	@Setter
	private String contNmPy;
	@Getter
	@Setter
	private String contPostcode;
	@Getter
	@Setter
	private String contAddress;
	@Getter
	@Setter
	private String contMobPhone;
	@Getter
	@Setter
	private String contHphone;
	@Getter
	@Setter
	private String csgName;
	@Getter
	@Setter
	private String csgPostcode;
	@Getter
	@Setter
	private String csgAddress;
	@Getter
	@Setter
	private String csgPhone1;
	@Getter
	@Setter
	private String csgPhone2;
	@Getter
	@Setter
	private String sendTime;
	@Getter
	@Setter
	private String isInvoice;
	@Getter
	@Setter
	private String invoice;
	@Getter
	@Setter
	private String invoiceType;
	@Getter
	@Setter
	private String invoiceContent;
	@Getter
	@Setter
	private String ordermainDesc;
	@Getter
	@Setter
	private String acctAddFlag;
	@Getter
	@Setter
	private String custSex;
	@Getter
	@Setter
	private String custEmail;
	@Getter
	@Setter
	private String csgProvince;
	@Getter
	@Setter
	private String csgCity;
	@Getter
	@Setter
	private String csgBorough;
	@Getter
	@Setter
	private String cardNo;


}
