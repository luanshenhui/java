package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL305 查询购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class CustCarQueryReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3558281598138653245L;
	private String totalPages;
	private String totalCount;
	private List<CustCarQueryGoodsReturn> goods = new ArrayList<CustCarQueryGoodsReturn>();

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

	public List<CustCarQueryGoodsReturn> getGoods() {
		return goods;
	}

	public void setGoods(List<CustCarQueryGoodsReturn> goods) {
		this.goods = goods;
	}

}
