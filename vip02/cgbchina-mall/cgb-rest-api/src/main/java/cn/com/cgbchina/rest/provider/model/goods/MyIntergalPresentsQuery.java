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
	private String origin;// 调用方标识:如CC:01 IVR:02 bps:11 个人网银:12
	private String mallType;// 商城类型标识,如分期商城:01 积分商城02
	private String bonus;// 积分值，积分类型必须为普通积分

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
