package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * @author lizy 2016/4/28.
 */
public class MyLoveCGBGoodsQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -3121350784418063252L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "create_oper")
	private String createOper;

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

	public String getCreateOper() {
		return createOper;
	}

	public void setCreateOper(String createOper) {
		this.createOper = createOper;
	}
}
