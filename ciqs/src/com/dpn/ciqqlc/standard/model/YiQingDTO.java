package com.dpn.ciqqlc.standard.model;

import java.util.Date;

import javax.persistence.Id;

/**
 * 动植物检验检疫资源服务平台(疫情上报系统)
 * table QLC_YIQING
 * @author liuchao
 *
 */
public class YiQingDTO {
	/**
	 * 主键 UUID
	 */
	@Id
	private String ID;
	/**
	 * 业务单号
	 */
	private String DECL_NO;
	/**
	 * 分类
	 */
	private String TYPE_KIND;
	/**
	 * 状态
	 */
	private String STATUS;
	/**
	 * 填报机构
	 */
	private String DEC_ORG;
	/**
	 * CIQ代码
	 */
	private String CIQ_CODE;
	/**
	 * 货物名称
	 */
	private String CAG_NAME;
	/**
	 * 原产地
	 */
	private String ORI_PLC;
	/**
	 * 输出地
	 */
	private String EXP_PLC;
	/**
	 * 入境口岸
	 */
	private String ENTER_PORT;
	/**
	 * 入境日期
	 */
	private String ENTER_DATE;
	/**
	 * 填写日期
	 */
	private Date DEC_DATE;
	/**
	 * 上报日期
	 */
	private Date SMT_DATE;
	/**
	 * 违规情况
	 */
	private String BRK_LAW_CAS;
	/**
	 * 处理措施
	 */
	private String DEAL_METH;
	/**
	 * 备注
	 */
	private String RMK;
	/**
	 * 数据同步时间
	 */
	private Date CREATE_DATE;
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getDECL_NO() {
		return DECL_NO;
	}
	public void setDECL_NO(String dECL_NO) {
		DECL_NO = dECL_NO;
	}
	public String getTYPE_KIND() {
		return TYPE_KIND;
	}
	public void setTYPE_KIND(String tYPE_KIND) {
		TYPE_KIND = tYPE_KIND;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}
	public String getDEC_ORG() {
		return DEC_ORG;
	}
	public void setDEC_ORG(String dEC_ORG) {
		DEC_ORG = dEC_ORG;
	}
	public String getCIQ_CODE() {
		return CIQ_CODE;
	}
	public void setCIQ_CODE(String cIQ_CODE) {
		CIQ_CODE = cIQ_CODE;
	}
	public String getCAG_NAME() {
		return CAG_NAME;
	}
	public void setCAG_NAME(String cAG_NAME) {
		CAG_NAME = cAG_NAME;
	}
	public String getORI_PLC() {
		return ORI_PLC;
	}
	public void setORI_PLC(String oRI_PLC) {
		ORI_PLC = oRI_PLC;
	}
	public String getEXP_PLC() {
		return EXP_PLC;
	}
	public void setEXP_PLC(String eXP_PLC) {
		EXP_PLC = eXP_PLC;
	}
	public String getENTER_PORT() {
		return ENTER_PORT;
	}
	public void setENTER_PORT(String eNTER_PORT) {
		ENTER_PORT = eNTER_PORT;
	}
	public String getENTER_DATE() {
		return ENTER_DATE;
	}
	public void setENTER_DATE(String eNTER_DATE) {
		ENTER_DATE = eNTER_DATE;
	}
	public Date getDEC_DATE() {
		return DEC_DATE;
	}
	public void setDEC_DATE(Date dEC_DATE) {
		DEC_DATE = dEC_DATE;
	}
	public Date getSMT_DATE() {
		return SMT_DATE;
	}
	public void setSMT_DATE(Date sMT_DATE) {
		SMT_DATE = sMT_DATE;
	}
	public String getBRK_LAW_CAS() {
		return BRK_LAW_CAS;
	}
	public void setBRK_LAW_CAS(String bRK_LAW_CAS) {
		BRK_LAW_CAS = bRK_LAW_CAS;
	}
	public String getDEAL_METH() {
		return DEAL_METH;
	}
	public void setDEAL_METH(String dEAL_METH) {
		DEAL_METH = dEAL_METH;
	}
	public String getRMK() {
		return RMK;
	}
	public void setRMK(String rMK) {
		RMK = rMK;
	}
	public Date getCREATE_DATE() {
		return CREATE_DATE;
	}
	public void setCREATE_DATE(Date cREATE_DATE) {
		CREATE_DATE = cREATE_DATE;
	}
	
	
	
	
	
}
