package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL118 适合我的积分礼品查询 查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class MyIntergalPresentsQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = 7886547631747389026L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
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
