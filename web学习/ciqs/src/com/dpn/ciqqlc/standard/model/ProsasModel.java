package com.dpn.ciqqlc.standard.model;

import java.util.Date;
import java.util.List;

/**
 * 隔离、就地诊验或留验
 * @author erikwang
 *
 */

public class ProsasModel {
	
	/**
	 * ID
	 */
	private String id;
	/**
	 * 证件类型
	 */
	private String cardType;
	/**
	 * 证件号码
	 */
	private String cardNo;
	/**
	 * 姓名
	 */
	private String name;
	/**
	 * 性别
	 */
	private String sex;
	/**
	 * 出生年月日
	 */
	private Date birth;
	/**
	 * 国籍/地区
	 */
	private String nation;
	/**
	 * 现居住地
	 */
	private String livePlc;
	/**
	 * 国内联系方式
	 */
	private String telCn;
	/**
	 * 个人职业
	 */
	private String occupation;
	/**
	 * 直属局
	 */
	private String portOrg;
	/**
	 * 分支机构
	 */
	private String portOrgUnder;
	/**
	 * 出入境口岸
	 */
	private String enterExpPort;
	/**
	 * 出入境目的地
	 */
	private String entereExpPlc;
	/**
	 * 出入境
	 */
	private String enterExpType;
	/**
	 * 出入境时间
	 */
	private String enterExpDate;
	/**
	 * 出入境方式
	 */
	private String enterExpMod;
	/**
	 * 航班号
	 */
	private String flightNo;
	/**
	 * 出入境事由
	 */
	private String enterExpCous;
	/**
	 * 个案发现渠道
	 */
	private String discoverWay;
	/**
	 * 单位或联系地址
	 */
	private String compPlc;
	/**
	 * 初筛处置
	 */
	private String firDeal;
	/**
	 * 初步筛查状态
	 */
	private String firDelStu;
	/**
	 * 医学排查状态
	 */
	private String medDelStu;
	/**
	 * 后续监管状态
	 */
	private String finChkStu;
	/**
	 * 合法证件附件
	 */
	private String certAcce;
	/**
	 * 检测报警图片
	 */
	private String chkWanPic;
	/**
	 * 数据同步时间
	 */
	private Date createDate;
	
	private String cardTypeRmk;
	
	public String getId() {
		return id;
	}
	public String getCardType() {
		return cardType;
	}
	public void setCardType(String cardType) {
		this.cardType = cardType;
	}
	public String getCardNo() {
		return cardNo;
	}
	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public Date getBirth() {
		return birth;
	}
	public void setBirth(Date birth) {
		this.birth = birth;
	}
	public String getNation() {
		return nation;
	}
	public void setNation(String nation) {
		this.nation = nation;
	}
	public String getLivePlc() {
		return livePlc;
	}
	public void setLivePlc(String livePlc) {
		this.livePlc = livePlc;
	}
	public String getTelCn() {
		return telCn;
	}
	public void setTelCn(String telCn) {
		this.telCn = telCn;
	}
	public String getOccupation() {
		return occupation;
	}
	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}
	public String getPortOrg() {
		return portOrg;
	}
	public void setPortOrg(String portOrg) {
		this.portOrg = portOrg;
	}
	public String getPortOrgUnder() {
		return portOrgUnder;
	}
	public void setPortOrgUnder(String portOrgUnder) {
		this.portOrgUnder = portOrgUnder;
	}
	public String getEnterExpPort() {
		return enterExpPort;
	}
	public void setEnterExpPort(String enterExpPort) {
		this.enterExpPort = enterExpPort;
	}
	public String getEntereExpPlc() {
		return entereExpPlc;
	}
	public void setEntereExpPlc(String entereExpPlc) {
		this.entereExpPlc = entereExpPlc;
	}
	public String getEnterExpType() {
		return enterExpType;
	}
	public void setEnterExpType(String enterExpType) {
		this.enterExpType = enterExpType;
	}
	public String getEnterExpDate() {
		return enterExpDate;
	}
	public void setEnterExpDate(String enterExpDate) {
		this.enterExpDate = enterExpDate;
	}
	public String getEnterExpMod() {
		return enterExpMod;
	}
	public void setEnterExpMod(String enterExpMod) {
		this.enterExpMod = enterExpMod;
	}
	public String getFlightNo() {
		return flightNo;
	}
	public void setFlightNo(String flightNo) {
		this.flightNo = flightNo;
	}
	public String getEnterExpCous() {
		return enterExpCous;
	}
	public void setEnterExpCous(String enterExpCous) {
		this.enterExpCous = enterExpCous;
	}
	public String getDiscoverWay() {
		return discoverWay;
	}
	public void setDiscoverWay(String discoverWay) {
		this.discoverWay = discoverWay;
	}
	public String getCompPlc() {
		return compPlc;
	}
	public void setCompPlc(String compPlc) {
		this.compPlc = compPlc;
	}
	public String getFirDeal() {
		return firDeal;
	}
	public void setFirDeal(String firDeal) {
		this.firDeal = firDeal;
	}
	public String getFirDelStu() {
		return firDelStu;
	}
	public void setFirDelStu(String firDelStu) {
		this.firDelStu = firDelStu;
	}
	public String getMedDelStu() {
		return medDelStu;
	}
	public void setMedDelStu(String medDelStu) {
		this.medDelStu = medDelStu;
	}
	public String getFinChkStu() {
		return finChkStu;
	}
	public void setFinChkStu(String finChkStu) {
		this.finChkStu = finChkStu;
	}
	public String getCertAcce() {
		return certAcce;
	}
	public void setCertAcce(String certAcce) {
		this.certAcce = certAcce;
	}
	public String getChkWanPic() {
		return chkWanPic;
	}
	public void setChkWanPic(String chkWanPic) {
		this.chkWanPic = chkWanPic;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	List<VideoEventModel> list;
	
	public List<VideoEventModel> getList() {
		return list;
	}
	public void setList(List<VideoEventModel> list) {
		this.list = list;
	}

	private String birthDay;

	public String getBirthDay() {
		return birthDay;
	}
	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}
	public String getCardTypeRmk() {
		return cardTypeRmk;
	}
	public void setCardTypeRmk(String cardTypeRmk) {
		this.cardTypeRmk = cardTypeRmk;
	}

	
}
