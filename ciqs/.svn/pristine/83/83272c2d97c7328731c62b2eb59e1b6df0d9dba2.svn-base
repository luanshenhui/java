package com.dpn.ciqqlc.webservice.io;

import java.io.Serializable;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

public class VslUpdateDecIo implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6106967464134109539L;

	/**不可为空	主键传递过来的*/
	@NotEmpty(message="VSL_DEC_ID:不能为空")
	@Length(max=50)
	private String  VSL_DEC_ID;
	
	/** 不可为空	中文船名 */
	@Length(max=25,message="VSL_CN_NAME:中文船名不能超过25个字")
	private String  VSL_CN_NAME;
	
	/** 不可为空	英文船名 */
	@Length(max=50,message="VSL_EN_NAME:英文船名长度不能超过50")
	private String  VSL_EN_NAME;
	
	/** 不可为空	中文国籍 */
	@Length(max=50,message="COUNTRY_CN_NAME:中文国籍长度不能超过25")
	private String  COUNTRY_CN_NAME;
	
	/** 不可为空	英文国籍 */
	@Length(max=50,message="COUNTRY_EN_NAME:中文国籍长度不能超过50")
	private String  COUNTRY_EN_NAME;
	
	/** 不可为空	呼号 */
	@Length(max=50,message="CALL_SIGN:呼号长度不能为空")
	private String  CALL_SIGN;
	
	/** 不可为空	吨数 */
	private String  TOTAL_TON;
	
	/**  不可为空	净吨*/
	private String  NET_TON;//
	
	/** 不可为空	航次 */
	@Length(max=50,message="VOYAGE_NO:航次不能长度超过50")
	private String  VOYAGE_NO;//
	
	/** 不可为空	始发港 */
	@Length(max=50,message="LOAD_PORT:长度不能超过50")
	private String  LOAD_PORT;
	
	/** 不可为空	船舶类型 */
	private String  SHIP_TYPE;
	
	/** 不可为空	船上有无尸体 */
	private String  HAVE_CORPSE;
	
	private String  HAVE_BIER;
	
	/** 不可为空	载货种类数量及预靠泊地点 */
	private String  CUR_CARGO_SIT;
	
	/** 不可为空	上航次载货种类数量及本次到港作业任务 */
	private String  HIS_CARGO_SIT;
	
	/** 不可为空	船员人数 */
	private String  SHIPPER_PSN_NUM;
	
	/** 不可为空	旅客人数 */
	private String  VISITOR_PSN_NUM;
	
	/** 不可为空	发航港及出发日期 */
	private String  START_SHIP_SIT;
	
	/** 不可为空	预计抵达日期及时间 */
//	@Pattern(regexp="[0-9]{4}-[0-9]{2}-[0-9]{2}",message="EST_ARRIV_DATE:时间格式错误 ")
	private String  EST_ARRIV_DATE;//
	
	/** 不可为空	近四周寄港及日期 */
	private String  LAST_FOUR_PORT;
	
	/** 不可为空	船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期 */
	private String  SHIP_SANIT_CERT;
	
	/** 交通工具卫生证书签发港及日期 */
	private String  TRAF_CERT;
	
	/** 不可为空	船上有无病人 */
	private String  HAVING_PATIENT;
	
	/** 不可为空	船上是否有人非因意外死亡 */
	private String  HAVING_CORPSE;
	
	/** 不可为空	在航海中船上是否有鼠类或其它医学媒介生物反常死亡 */
	private String  HAVING_MDK_MDI_CPS;
	
	/** 不可为空	申报单位 */
	private String  DEC_ORG;
	
	/** 不可为空	申报时间 */
	private String  DEC_DATE;
	
	/** 不可为空	申报人员 */
	private String  DEC_USER;
	
	/** 不可为空	检疫方式（申报） */
	private String  QUAR_TYPE_DEC;
	
	/** 可为空	审批时间(审批) */
	private String  APPROVE_DATE;
	
	/** 可为空	审批人员(审批) */
	private String  APPROVE_USER;
	
	/** 不可为空	监管局代码 */
	private String  INSP_ORG_CODE;
	
	/** 不可为空	监管局名称 */
	private String  INSP_ORG_NAME;
	
	/** 可为空	检疫方式（审批） */
	private String  QUAR_TYPE_APPR;
	
	/** 可为空	登轮检疫结果（审批） */
	private String  CHECK_RST;
	
	private String  ARRV_RST;
	
	public String getARRV_RST() {
		return ARRV_RST;
	}
	public void setARRV_RST(String aRRV_RST) {
		ARRV_RST = aRRV_RST;
	}
	
	public String getVSL_DEC_ID() {
		return VSL_DEC_ID;
	}
	public void setVSL_DEC_ID(String vSL_DEC_ID) {
		VSL_DEC_ID = vSL_DEC_ID;
	}
	public String getVSL_CN_NAME() {
		return VSL_CN_NAME;
	}
	public void setVSL_CN_NAME(String vSL_CN_NAME) {
		VSL_CN_NAME = vSL_CN_NAME;
	}
	public String getVSL_EN_NAME() {
		return VSL_EN_NAME;
	}
	public void setVSL_EN_NAME(String vSL_EN_NAME) {
		VSL_EN_NAME = vSL_EN_NAME;
	}
	public String getCOUNTRY_CN_NAME() {
		return COUNTRY_CN_NAME;
	}
	public void setCOUNTRY_CN_NAME(String cOUNTRY_CN_NAME) {
		COUNTRY_CN_NAME = cOUNTRY_CN_NAME;
	}
	public String getCOUNTRY_EN_NAME() {
		return COUNTRY_EN_NAME;
	}
	public void setCOUNTRY_EN_NAME(String cOUNTRY_EN_NAME) {
		COUNTRY_EN_NAME = cOUNTRY_EN_NAME;
	}
	public String getCALL_SIGN() {
		return CALL_SIGN;
	}
	public void setCALL_SIGN(String cALL_SIGN) {
		CALL_SIGN = cALL_SIGN;
	}
	public String getTOTAL_TON() {
		return TOTAL_TON;
	}
	public void setTOTAL_TON(String tOTAL_TON) {
		TOTAL_TON = tOTAL_TON;
	}
	public String getNET_TON() {
		return NET_TON;
	}
	public void setNET_TON(String nET_TON) {
		NET_TON = nET_TON;
	}
	public String getVOYAGE_NO() {
		return VOYAGE_NO;
	}
	public void setVOYAGE_NO(String vOYAGE_NO) {
		VOYAGE_NO = vOYAGE_NO;
	}
	public String getLOAD_PORT() {
		return LOAD_PORT;
	}
	public void setLOAD_PORT(String lOAD_PORT) {
		LOAD_PORT = lOAD_PORT;
	}
	public String getSHIP_TYPE() {
		return SHIP_TYPE;
	}
	public void setSHIP_TYPE(String sHIP_TYPE) {
		SHIP_TYPE = sHIP_TYPE;
	}
	public String getHAVE_CORPSE() {
		return HAVE_CORPSE;
	}
	public void setHAVE_CORPSE(String hAVE_CORPSE) {
		HAVE_CORPSE = hAVE_CORPSE;
	}
	public String getHAVE_BIER() {
		return HAVE_BIER;
	}
	public void setHAVE_BIER(String hAVE_BIER) {
		HAVE_BIER = hAVE_BIER;
	}
	public String getCUR_CARGO_SIT() {
		return CUR_CARGO_SIT;
	}
	public void setCUR_CARGO_SIT(String cUR_CARGO_SIT) {
		CUR_CARGO_SIT = cUR_CARGO_SIT;
	}
	public String getHIS_CARGO_SIT() {
		return HIS_CARGO_SIT;
	}
	public void setHIS_CARGO_SIT(String hIS_CARGO_SIT) {
		HIS_CARGO_SIT = hIS_CARGO_SIT;
	}
	public String getSHIPPER_PSN_NUM() {
		return SHIPPER_PSN_NUM;
	}
	public void setSHIPPER_PSN_NUM(String sHIPPER_PSN_NUM) {
		SHIPPER_PSN_NUM = sHIPPER_PSN_NUM;
	}
	public String getVISITOR_PSN_NUM() {
		return VISITOR_PSN_NUM;
	}
	public void setVISITOR_PSN_NUM(String vISITOR_PSN_NUM) {
		VISITOR_PSN_NUM = vISITOR_PSN_NUM;
	}
	public String getSTART_SHIP_SIT() {
		return START_SHIP_SIT;
	}
	public void setSTART_SHIP_SIT(String sTART_SHIP_SIT) {
		START_SHIP_SIT = sTART_SHIP_SIT;
	}
	public String getEST_ARRIV_DATE() {
		return EST_ARRIV_DATE;
	}
	public void setEST_ARRIV_DATE(String eST_ARRIV_DATE) {
		EST_ARRIV_DATE = eST_ARRIV_DATE;
	}
	public String getLAST_FOUR_PORT() {
		return LAST_FOUR_PORT;
	}
	public void setLAST_FOUR_PORT(String lAST_FOUR_PORT) {
		LAST_FOUR_PORT = lAST_FOUR_PORT;
	}
	public String getSHIP_SANIT_CERT() {
		return SHIP_SANIT_CERT;
	}
	public void setSHIP_SANIT_CERT(String sHIP_SANIT_CERT) {
		SHIP_SANIT_CERT = sHIP_SANIT_CERT;
	}
	public String getTRAF_CERT() {
		return TRAF_CERT;
	}
	public void setTRAF_CERT(String tRAF_CERT) {
		TRAF_CERT = tRAF_CERT;
	}
	public String getHAVING_PATIENT() {
		return HAVING_PATIENT;
	}
	public void setHAVING_PATIENT(String hAVING_PATIENT) {
		HAVING_PATIENT = hAVING_PATIENT;
	}
	public String getHAVING_CORPSE() {
		return HAVING_CORPSE;
	}
	public void setHAVING_CORPSE(String hAVING_CORPSE) {
		HAVING_CORPSE = hAVING_CORPSE;
	}
	public String getHAVING_MDK_MDI_CPS() {
		return HAVING_MDK_MDI_CPS;
	}
	public void setHAVING_MDK_MDI_CPS(String hAVING_MDK_MDI_CPS) {
		HAVING_MDK_MDI_CPS = hAVING_MDK_MDI_CPS;
	}
	public String getDEC_ORG() {
		return DEC_ORG;
	}
	public void setDEC_ORG(String dEC_ORG) {
		DEC_ORG = dEC_ORG;
	}
	public String getDEC_DATE() {
		return DEC_DATE;
	}
	public void setDEC_DATE(String dEC_DATE) {
		DEC_DATE = dEC_DATE;
	}
	public String getDEC_USER() {
		return DEC_USER;
	}
	public void setDEC_USER(String dEC_USER) {
		DEC_USER = dEC_USER;
	}
	public String getQUAR_TYPE_DEC() {
		return QUAR_TYPE_DEC;
	}
	public void setQUAR_TYPE_DEC(String qUAR_TYPE_DEC) {
		QUAR_TYPE_DEC = qUAR_TYPE_DEC;
	}
	public String getAPPROVE_DATE() {
		return APPROVE_DATE;
	}
	public void setAPPROVE_DATE(String aPPROVE_DATE) {
		APPROVE_DATE = aPPROVE_DATE;
	}
	public String getAPPROVE_USER() {
		return APPROVE_USER;
	}
	public void setAPPROVE_USER(String aPPROVE_USER) {
		APPROVE_USER = aPPROVE_USER;
	}
	public String getINSP_ORG_CODE() {
		return INSP_ORG_CODE;
	}
	public void setINSP_ORG_CODE(String iNSP_ORG_CODE) {
		INSP_ORG_CODE = iNSP_ORG_CODE;
	}
	public String getINSP_ORG_NAME() {
		return INSP_ORG_NAME;
	}
	public void setINSP_ORG_NAME(String iNSP_ORG_NAME) {
		INSP_ORG_NAME = iNSP_ORG_NAME;
	}
	public String getQUAR_TYPE_APPR() {
		return QUAR_TYPE_APPR;
	}
	public void setQUAR_TYPE_APPR(String qUAR_TYPE_APPR) {
		QUAR_TYPE_APPR = qUAR_TYPE_APPR;
	}
	public String getCHECK_RST() {
		return CHECK_RST;
	}
	public void setCHECK_RST(String cHECK_RST) {
		CHECK_RST = cHECK_RST;
	}
	
	

}
