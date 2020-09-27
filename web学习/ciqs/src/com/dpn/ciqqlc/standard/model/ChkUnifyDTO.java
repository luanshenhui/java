package com.dpn.ciqqlc.standard.model;

import java.util.Date;

import javax.persistence.Id;

/**
 * 查验一体机
 * table QLC_CHK_UNIFY
 * @author liuchao
 *
 */
public class ChkUnifyDTO {
	@Id
	/**
	 * 主键 UUID
	 */
	private String ID;
	/**
	 * 护照号码
	 */
	private String CARD_NO;
	/**
	 * 姓名
	 */
	private String NAME;
	/**
	 * 性别
	 */
	private String SEX;
	/**
	 * 出生日期
	 */
	private Date BIRTH;
	/**
	 * 国家、地区
	 */
	private String NATION;
	/**
	 * 地址
	 */
	private String LIVE_PLC;
	/**
	 * 证件照片
	 */
	private String CARD_PIC;
	/**
	 * 检疫记录编号
	 */
	private String CHK_RCD_NO;
	/**
	 * 检疫官
	 */
	private String INSP_OPR;
	/**
	 * 交通工具号
	 */
	private String TRA_TOOL_NO;
	/**
	 * 登记日期
	 */
	private Date REG_DATE;
	/**
	 * 物品种类
	 */
	private String CAG_TYPE;
	/**
	 * 禁止进境物
	 */
	private String PRHB_ENTER;
	/**
	 * 品名
	 */
	private String CAG_NAME;
	/**
	 * 不合格原因
	 */
	private String UNQF_RSN;
	/**
	 * 数量及单位
	 */
	private String NUM_UNIT;
	/**
	 * 重量及单位
	 */
	private String WEIGHT_UNIT;
	/**
	 * 是否送样
	 */
	private String IS_SAMP;
	/**
	 * 收样部门
	 */
	private String RSV_SAMP_DPT;
	/**
	 * 检疫项目
	 */
	private String CHECK_ITEM;
	/**
	 * 来自地
	 */
	private String FROM_PLC;
	/**
	 * 截获方式
	 */
	private String ITS_TYPE;
	/**
	 * 物品照片
	 */
	private String CAG_PIC;
	/**
	 * 凭证编号
	 */
	private String VOC_NO;
	/**
	 * 处理说明
	 */
	private String DEAL_DISC;
	/**
	 * 在华联系地址
	 */
	private String PLC_CN;
	/**
	 * 处置日期
	 */
	private String DEAL_DATE;
	/**
	 * 用途
	 */
	private String USE_TO;
	/**
	 * 截获流水号
	 */
	private String ITS_NO;
	/**
	 * 处理方式
	 */
	private String DEAL_TYPE;
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
	public String getCARD_NO() {
		return CARD_NO;
	}
	public void setCARD_NO(String cARD_NO) {
		CARD_NO = cARD_NO;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public String getSEX() {
		return SEX;
	}
	public void setSEX(String sEX) {
		SEX = sEX;
	}
	public Date getBIRTH() {
		return BIRTH;
	}
	public void setBIRTH(Date bIRTH) {
		BIRTH = bIRTH;
	}
	public String getNATION() {
		return NATION;
	}
	public void setNATION(String nATION) {
		NATION = nATION;
	}
	public String getLIVE_PLC() {
		return LIVE_PLC;
	}
	public void setLIVE_PLC(String lIVE_PLC) {
		LIVE_PLC = lIVE_PLC;
	}
	public String getCARD_PIC() {
		return CARD_PIC;
	}
	public void setCARD_PIC(String cARD_PIC) {
		CARD_PIC = cARD_PIC;
	}
	public String getCHK_RCD_NO() {
		return CHK_RCD_NO;
	}
	public void setCHK_RCD_NO(String cHK_RCD_NO) {
		CHK_RCD_NO = cHK_RCD_NO;
	}
	public String getINSP_OPR() {
		return INSP_OPR;
	}
	public void setINSP_OPR(String iNSP_OPR) {
		INSP_OPR = iNSP_OPR;
	}
	public String getTRA_TOOL_NO() {
		return TRA_TOOL_NO;
	}
	public void setTRA_TOOL_NO(String tRA_TOOL_NO) {
		TRA_TOOL_NO = tRA_TOOL_NO;
	}
	public Date getREG_DATE() {
		return REG_DATE;
	}
	public void setREG_DATE(Date rEG_DATE) {
		REG_DATE = rEG_DATE;
	}
	public String getCAG_TYPE() {
		return CAG_TYPE;
	}
	public void setCAG_TYPE(String cAG_TYPE) {
		CAG_TYPE = cAG_TYPE;
	}
	public String getPRHB_ENTER() {
		return PRHB_ENTER;
	}
	public void setPRHB_ENTER(String pRHB_ENTER) {
		PRHB_ENTER = pRHB_ENTER;
	}
	public String getCAG_NAME() {
		return CAG_NAME;
	}
	public void setCAG_NAME(String cAG_NAME) {
		CAG_NAME = cAG_NAME;
	}
	public String getUNQF_RSN() {
		return UNQF_RSN;
	}
	public void setUNQF_RSN(String uNQF_RSN) {
		UNQF_RSN = uNQF_RSN;
	}
	public String getNUM_UNIT() {
		return NUM_UNIT;
	}
	public void setNUM_UNIT(String nUM_UNIT) {
		NUM_UNIT = nUM_UNIT;
	}
	public String getWEIGHT_UNIT() {
		return WEIGHT_UNIT;
	}
	public void setWEIGHT_UNIT(String wEIGHT_UNIT) {
		WEIGHT_UNIT = wEIGHT_UNIT;
	}
	public String getIS_SAMP() {
		return IS_SAMP;
	}
	public void setIS_SAMP(String iS_SAMP) {
		IS_SAMP = iS_SAMP;
	}
	public String getRSV_SAMP_DPT() {
		return RSV_SAMP_DPT;
	}
	public void setRSV_SAMP_DPT(String rSV_SAMP_DPT) {
		RSV_SAMP_DPT = rSV_SAMP_DPT;
	}
	public String getCHECK_ITEM() {
		return CHECK_ITEM;
	}
	public void setCHECK_ITEM(String cHECK_ITEM) {
		CHECK_ITEM = cHECK_ITEM;
	}
	public String getFROM_PLC() {
		return FROM_PLC;
	}
	public void setFROM_PLC(String fROM_PLC) {
		FROM_PLC = fROM_PLC;
	}
	public String getITS_TYPE() {
		return ITS_TYPE;
	}
	public void setITS_TYPE(String iTS_TYPE) {
		ITS_TYPE = iTS_TYPE;
	}
	public String getCAG_PIC() {
		return CAG_PIC;
	}
	public void setCAG_PIC(String cAG_PIC) {
		CAG_PIC = cAG_PIC;
	}
	public String getVOC_NO() {
		return VOC_NO;
	}
	public void setVOC_NO(String vOC_NO) {
		VOC_NO = vOC_NO;
	}
	public String getDEAL_DISC() {
		return DEAL_DISC;
	}
	public void setDEAL_DISC(String dEAL_DISC) {
		DEAL_DISC = dEAL_DISC;
	}
	public String getPLC_CN() {
		return PLC_CN;
	}
	public void setPLC_CN(String pLC_CN) {
		PLC_CN = pLC_CN;
	}
	public String getDEAL_DATE() {
		return DEAL_DATE;
	}
	public void setDEAL_DATE(String dEAL_DATE) {
		DEAL_DATE = dEAL_DATE;
	}
	public String getUSE_TO() {
		return USE_TO;
	}
	public void setUSE_TO(String uSE_TO) {
		USE_TO = uSE_TO;
	}
	public String getITS_NO() {
		return ITS_NO;
	}
	public void setITS_NO(String iTS_NO) {
		ITS_NO = iTS_NO;
	}
	public String getDEAL_TYPE() {
		return DEAL_TYPE;
	}
	public void setDEAL_TYPE(String dEAL_TYPE) {
		DEAL_TYPE = dEAL_TYPE;
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
