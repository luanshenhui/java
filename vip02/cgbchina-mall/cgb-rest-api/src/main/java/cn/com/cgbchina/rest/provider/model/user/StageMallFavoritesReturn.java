package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL302 查询收藏商品(分期商城) 的返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoritesReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -1443261222705517281L;
	private String totalPages;
	private String totalCount;
	private List<StageMallFavoriteGoods> stageMallFavoriteGoodses = new ArrayList<StageMallFavoriteGoods>();

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

	public List<StageMallFavoriteGoods> getStageMallFavoriteGoodses() {
		return stageMallFavoriteGoodses;
	}

	public void setStageMallFavoriteGoodses(List<StageMallFavoriteGoods> stageMallFavoriteGoodses) {
		this.stageMallFavoriteGoodses = stageMallFavoriteGoodses;
	}

}
