package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL117 商品详细信息(分期商城)返回对象 --分期信息
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailStageInfo extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 1212083175978327129L;
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
