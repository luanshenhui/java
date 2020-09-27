package cn.com.cgbchina.rest.visit.model.sms;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class BatchSendSMSNotifyInfo implements Serializable {

	private static final long serialVersionUID = -5883302595417349564L;

	@NotNull
	private String smsId;
	@NotNull
	private String templateId;
	private String fixTemplateId;
	@NotNull
	private String channelCode;
	@NotNull
	private String sendBranch;
	@NotNull
	private String mobile;

	private String idType;// 证件类型*
	private String idCode;// 证件号*
	private String signupacct;// 短信签约账号*

	private String custName;// 客户名
	private String cardNbr; // 卡号
	private String itemName;// 单品名称
	private java.math.BigDecimal perStage;// 单期金额
	private Integer stagesCode;// 分期
	private java.math.BigDecimal goodsPrice;// 单品价格
	private String couponNm;// 项目名称
	private String otherMess;// 手工参数
	private String smspMess = ""; // 模板内容

	public String getSmsId() {
		return smsId;
	}

	public void setSmsId(String smsId) {
		this.smsId = smsId;
	}

	public String getTemplateId() {
		return templateId;
	}

	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

	public String getFixTemplateId() {
		return fixTemplateId;
	}

	public void setFixTemplateId(String fixTemplateId) {
		this.fixTemplateId = fixTemplateId;
	}

	public String getChannelCode() {
		return channelCode;
	}

	public void setChannelCode(String channelCode) {
		this.channelCode = channelCode;
	}

	public String getSendBranch() {
		return sendBranch;
	}

	public void setSendBranch(String sendBranch) {
		this.sendBranch = sendBranch;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getIdType() {
		return idType;
	}

	public void setIdType(String idType) {
		this.idType = idType;
	}

	public String getIdCode() {
		return idCode;
	}

	public void setIdCode(String idCode) {
		this.idCode = idCode;
	}

	public String getSignupacct() {
		return signupacct;
	}

	public void setSignupacct(String signupacct) {
		this.signupacct = signupacct;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getCardNbr() {
		return cardNbr;
	}

	public void setCardNbr(String cardNbr) {
		this.cardNbr = cardNbr;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public BigDecimal getPerStage() {
		return perStage;
	}

	public void setPerStage(BigDecimal perStage) {
		this.perStage = perStage;
	}

	public Integer getStagesCode() {
		return stagesCode;
	}

	public void setStagesCode(Integer stagesCode) {
		this.stagesCode = stagesCode;
	}

	public BigDecimal getGoodsPrice() {
		return goodsPrice;
	}

	public void setGoodsPrice(BigDecimal goodsPrice) {
		this.goodsPrice = goodsPrice;
	}

	public String getCouponNm() {
		return couponNm;
	}

	public void setCouponNm(String couponNm) {
		this.couponNm = couponNm;
	}

	public String getOtherMess() {
		return otherMess;
	}

	public void setOtherMess(String otherMess) {
		this.otherMess = otherMess;
	}

	public String getSmspMess() {
		return smspMess;
	}

	public void setSmspMess(String smspMess) {
		this.smspMess = smspMess;
	}

	/**
	 * 生成内容
	 * 
	 * @return
	 */
	private StringBuilder toStringBuilder() {

		StringBuilder sb = new StringBuilder();

		sb.append("SMSID=").append(smsId);
		sb.append("|TEMPLATEID=").append(templateId);
		sb.append("|CHANNELCODE=").append(channelCode);
		sb.append("|FIXTEMPLATEID=").append(Strings.isNullOrEmpty(fixTemplateId) ? "" : fixTemplateId);
		sb.append("|SENDBRANCH=").append(sendBranch);
		sb.append("|MOBILE=").append(mobile);

		sb.append("|IDTYPE=").append(Strings.isNullOrEmpty(idType) ? "" : idType);
		sb.append("|IDCODE=").append(Strings.isNullOrEmpty(idCode) ? "" : idCode);
		sb.append("|SIGNUPACCT=").append(Strings.isNullOrEmpty(signupacct) ? "" : signupacct);

		String mess1 = "";
		String mess2 = "";
		if (!Strings.isNullOrEmpty(otherMess)) {
			String[] mess = otherMess.split("\\|");
			mess1 = mess[0];
			if(mess.length > 1) {
				mess2 = mess[1];
			}
		}

		if(null != smspMess && !smspMess.contains("[MESS1]")){
			sb.append("|MESS2=").append(Strings.isNullOrEmpty(mess2) ? "" : mess2);
		}else{
			sb.append("|MESS1=").append(Strings.isNullOrEmpty(mess1) ? "" : mess1);
			sb.append("|MESS2=").append(Strings.isNullOrEmpty(mess2) ? "" : mess2);
		}

		sb.append("|UNIT_PRICE=").append(null == perStage ? "" : perStage.toString());
		sb.append("|STAGE=").append(null == stagesCode ? "" : stagesCode.toString());
		sb.append("|GOODS_NM=").append(Strings.isNullOrEmpty(itemName) ? "" : itemName);

		String cardFour = "";
		if (!Strings.isNullOrEmpty(cardNbr)) {
			int index = cardNbr.length() - 4;
			cardFour = "***" + cardNbr.substring(index);
		}
		sb.append("|CARD_FOUR=").append(Strings.isNullOrEmpty(cardFour) ? "" : cardFour);
		sb.append("|CUST_NM=").append(Strings.isNullOrEmpty(custName) ? "" : custName);
		sb.append("|VOUCHER_NM=").append(Strings.isNullOrEmpty(couponNm) ? "" : couponNm);

		sb.append("\n");
		return sb;
	}

	// 生成String串
	public static String listToString(List<BatchSendSMSNotifyInfo> infos) {
		StringBuilder sb = new StringBuilder();
		for (BatchSendSMSNotifyInfo info : infos) {
			sb.append(info.toStringBuilder());
		}
		return sb.toString();
	}

	public static void main(String[] a) {
		BatchSendSMSNotifyInfo info1 = new BatchSendSMSNotifyInfo();
		info1.setSmsId("FH");
		info1.setTemplateId("FHS2341F");
		info1.setChannelCode("SHOP");
		info1.setSendBranch("999999");
		info1.setMobile("13050005000");
		info1.setCardNbr("2asd1a3s2d16a54dqw12");
		info1.setItemName("水杯 /蓝");
		info1.setGoodsPrice(new BigDecimal("100"));
		info1.setCustName("张三");
		info1.setOtherMess("info1|info1.1");
		info1.setPerStage(new BigDecimal("0.111"));
		info1.setStagesCode(12);
		info1.setCouponNm("优惠券");
		info1.setSmspMess("尊敬的[CUST_NM]， 向您推荐[GOODS_NM]，回复“SYG”[MESS2] 【广发银行】");
		BatchSendSMSNotifyInfo info2 = new BatchSendSMSNotifyInfo();
		info2.setSmsId("FH");
		info2.setTemplateId("FHS2341F");
		info2.setChannelCode("SHOP");
		info2.setSendBranch("999999");
		info2.setMobile("13050005000");
		info2.setOtherMess("info2");
		info2.setSmspMess("[MESS1] [GOODS_NM] 免息分期[UNIT_PRICE]元*[STAGE]期，回复 “SYG” 使用您名下卡末四位[CARD_FOUR]订购！【广发银行】");
		BatchSendSMSNotifyInfo info3 = new BatchSendSMSNotifyInfo();
		info3.setSmsId("FH");
		info3.setTemplateId("FHS2341F");
		info3.setChannelCode("SHOP");
		info3.setSendBranch("999999");
		info3.setMobile("13050005000");
		BatchSendSMSNotifyInfo info4 = new BatchSendSMSNotifyInfo();
		info4.setSmsId("FH");
		info4.setTemplateId("FHS2341F");
		info4.setChannelCode("SHOP");
		info4.setSendBranch("999999");
		info4.setMobile("13050005000");
		info4.setOtherMess("info4");
		info4.setSmspMess("[MESS1]月供[UNIT_PRICE]元*[STAGE]期即可获得[GOODS_NM]，更有免费赠[MESS2]， 回复“SYG” 使用您名下卡末四位[CARD_FOUR]订购！【广发银行】");
		BatchSendSMSNotifyInfo info5 = new BatchSendSMSNotifyInfo();
		info5.setSmsId("FH");
		info5.setTemplateId("FHS2341F");
		info5.setChannelCode("SHOP");
		info5.setSendBranch("999999");
		info5.setMobile("13050005000");

		List<BatchSendSMSNotifyInfo> list = Lists.newArrayListWithCapacity(5);
		list.add(info1);
		list.add(info2);
		list.add(info3);
		list.add(info4);
		list.add(info5);

		System.out.print(BatchSendSMSNotifyInfo.listToString(list));
	}
}
