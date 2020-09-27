package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/29.
 */
public class DuliCheckTimeDto implements Serializable {

	private static final long serialVersionUID = 5853905536383909560L;
	@Getter
	@Setter
	private Date beginDate;// 开始时间
	@Getter
	@Setter
	private Date endDate;// 结束时间

}
