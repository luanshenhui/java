package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/13.
 */
public class SecKillDto implements Serializable {

	private static final long serialVersionUID = 178744941891437760L;
	@Setter
	@Getter
	private Integer limitCount;// 限购数量
	@Setter
	@Getter
	private Integer countType;// 限购数量种类
}
