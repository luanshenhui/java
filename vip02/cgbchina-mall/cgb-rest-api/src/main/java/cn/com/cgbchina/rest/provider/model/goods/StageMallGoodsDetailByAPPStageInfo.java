package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

/**
 * MAL313 商品详细信息(分期商城) App
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailByAPPStageInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3931707297801936840L;
	private String stagesNum;
	private String perStage;
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
