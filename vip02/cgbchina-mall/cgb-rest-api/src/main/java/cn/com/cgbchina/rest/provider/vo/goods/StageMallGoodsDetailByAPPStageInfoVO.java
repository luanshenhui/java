package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class StageMallGoodsDetailByAPPStageInfoVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3538169775658257704L;
	@XMLNodeName(value = "stages_num")
	private String stagesNum;
	@XMLNodeName(value = "per_stage")
	private String perStage;
	@XMLNodeName(value = "payway_id_f")
	private String paywayIdF;

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getPerStage() {
		return perStage;
	}

	public void setPerStage(String perStage) {
		this.perStage = perStage;
	}

	public String getPaywayIdF() {
		return paywayIdF;
	}

	public void setPaywayIdF(String paywayIdF) {
		this.paywayIdF = paywayIdF;
	}

}
