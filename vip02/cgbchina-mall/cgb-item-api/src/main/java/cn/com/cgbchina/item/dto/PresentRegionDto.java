package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by shixing on 16-4-27.
 */
public class PresentRegionDto implements Serializable {

	private static final long serialVersionUID = -5178818568432307012L;
	@Getter
	@Setter
	private Long id;

	@Getter
	@Setter
	private String name;

	@Getter
	@Setter
	private String integraltypeId;// 积分类型id

	@Getter
	@Setter
	private String integraltypeNm;// 积分类型名称

	@Getter
	@Setter
	private String limitCards;

	@Getter
	@Setter
	private String areaId;//专区代码
}
