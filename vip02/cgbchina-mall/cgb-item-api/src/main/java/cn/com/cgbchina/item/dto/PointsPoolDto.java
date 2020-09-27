package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.PointPoolModel;

/**
 * Created by niufw on 16-5-31.
 */
public class PointsPoolDto extends PointPoolModel {


	private static final long serialVersionUID = -6105856271378099822L;
	private Integer flag;// 当前日期

	public Integer getFlag() {
		return flag;
	}

	public void setFlag(Integer flag) {
		this.flag = flag;
	}
}
