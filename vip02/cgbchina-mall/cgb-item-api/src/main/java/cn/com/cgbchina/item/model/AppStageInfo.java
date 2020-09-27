package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by 11150221040129 on 16-4-8.
 */
public class AppStageInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -1;
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
