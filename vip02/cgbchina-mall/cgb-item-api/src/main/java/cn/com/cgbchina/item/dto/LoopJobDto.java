package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 活动范围
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class LoopJobDto implements Serializable {

	private static final long serialVersionUID = 2781082178466313570L;

	@Setter
	@Getter
	private String loopType;
	@Setter
	@Getter
	private String data;
	@Setter
	@Getter
	private String beginTime;
	@Setter
	@Getter
	private String endTime;

}
