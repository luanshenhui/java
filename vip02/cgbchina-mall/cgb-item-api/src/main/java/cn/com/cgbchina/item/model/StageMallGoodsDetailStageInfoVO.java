package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * MAL117 商品详细信息(分期商城)返回对象 --分期信息
 * 
 * @author 2016/7/7
 */
public class StageMallGoodsDetailStageInfoVO implements Serializable {

	private static final long serialVersionUID = -1L;
	@Getter
	@Setter
	private String stagesNum;
	@Getter
	@Setter
	private String perStage;
	@Getter
	@Setter
	private String paywayIdF;

}
