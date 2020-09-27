package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 隔离、就地诊验或留验
 * @author erikwang
 *
 */

public class QuartnModel extends PageDto{
	
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
	 * 发现方式
	 */
	private String discoverWay;
	/**
	 * 当前监管科室代码
	 */
	private String portDeptCode;
	/**
	 * 监管口岸局代码
	 */
	private String portOrgCode;
	/**
	 * 创建人
	 */
	private String createUser;
	/**
	 * 创建时间
	 */
	private Date createDate;
	private String p_id;
	private String 	card_type_rmk;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public String getDiscoverWay() {
		return discoverWay;
	}
	public void setDiscoverWay(String discoverWay) {
		this.discoverWay = discoverWay;
	}
	public String getPortDeptCode() {
		return portDeptCode;
	}
	public void setPortDeptCode(String portDeptCode) {
		this.portDeptCode = portDeptCode;
	}
	public String getPortOrgCode() {
		return portOrgCode;
	}
	public void setPortOrgCode(String portOrgCode) {
		this.portOrgCode = portOrgCode;
	}
	public String getCreateUser() {
		return createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	
	/**
	 * 姓名
	 */
	private String name;
	/**
	 * 总局
	 */
	private String directyUnderOrg;
	
	/**
	 * 分支机构
	 */
	private String portOrgUnder;
	
	/**
	 * 直属局
	 */
	private String portOrg;
	
	/**
	 * 出入境口岸
	 */
	private String enterExpPort;
	
	/**
	 * 出入境目的地
	 */
	private String enterExpPlc;
	
	/**
	 * 出入境时间
	 */
	private String enterExpDate;
	
	/**
	 * 出行方式
	 * @return
	 */
	
	private String enterExpMod;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPortOrgUnder() {
		return portOrgUnder;
	}
	public void setPortOrgUnder(String portOrgUnder) {
		this.portOrgUnder = portOrgUnder;
	}
	public String getPortOrg() {
		return portOrg;
	}
	public void setPortOrg(String portOrg) {
		this.portOrg = portOrg;
	}
	public String getEnterExpPort() {
		return enterExpPort;
	}
	public void setEnterExpPort(String enterExpPort) {
		this.enterExpPort = enterExpPort;
	}
	public String getEnterExpPlc() {
		return enterExpPlc;
	}
	public void setEnterExpPlc(String enterExpPlc) {
		this.enterExpPlc = enterExpPlc;
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


	public String getDirectyUnderOrg() {
		return directyUnderOrg;
	}
	public void setDirectyUnderOrg(String directyUnderOrg) {
		this.directyUnderOrg = directyUnderOrg;
	}


	private String enterExpDate_begin;
	private String enterExpDate_over;

	public String getEnterExpDate_begin() {
		return enterExpDate_begin;
	}
	public void setEnterExpDate_begin(String enterExpDate_begin) {
		this.enterExpDate_begin = enterExpDate_begin;
	}
	public String getEnterExpDate_over() {
		return enterExpDate_over;
	}
	public void setEnterExpDate_over(String enterExpDate_over) {
		this.enterExpDate_over = enterExpDate_over;
	}
	public String getP_id() {
		return p_id;
	}
	public void setP_id(String p_id) {
		this.p_id = p_id;
	}
	public String getCard_type_rmk() {
		return card_type_rmk;
	}
	public void setCard_type_rmk(String card_type_rmk) {
		this.card_type_rmk = card_type_rmk;
	}
	
	
	
}
