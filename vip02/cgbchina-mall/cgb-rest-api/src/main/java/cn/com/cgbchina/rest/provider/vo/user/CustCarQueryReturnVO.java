package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL305 查询购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class CustCarQueryReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3558281598138653245L;

	private String totalPages;
	@NotNull
	private String totalCount;
	private List<CustCarQueryGoodsReturnVO> goods = new ArrayList<CustCarQueryGoodsReturnVO>();

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(String totalCount) {
		this.totalCount = totalCount;
	}

	public List<CustCarQueryGoodsReturnVO> getGoods() {
		return goods;
	}

	public void setGoods(List<CustCarQueryGoodsReturnVO> goods) {
		this.goods = goods;
	}

}
