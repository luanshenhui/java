package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/14.
 */
public class LoopJob implements Serializable {
	@Setter
	@Getter
	private String loopType;// 按天循环为d 按天循环;w 按星期循环；m 按月循环
	@Setter
	@Getter
	private String data;//
	@Setter
	@Getter
	private Date beginTime;// 开始时间
	@Setter
	@Getter
	private Date endTime;// 结束时间
}
