package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL118 适合我的积分礼品查询 查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class MyIntergalPresentsQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = 7886547631747389026L;
	private String origin;
	private String mallType;
	private String bonus;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getBonus() {
		return bonus;
	}

	public void setBonus(String bonus) {
		this.bonus = bonus;
	}
}
