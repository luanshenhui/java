package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL302 查询收藏商品(分期商城) 的返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoritesReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = -1443261222705517281L;
	@NotNull
	private String totalPages;
	@NotNull
	private String totalCount;
	private List<StageMallFavoriteGoodsVO> stageMallFavoriteGoodses = new ArrayList<StageMallFavoriteGoodsVO>();

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

	public List<StageMallFavoriteGoodsVO> getStageMallFavoriteGoodses() {
		return stageMallFavoriteGoodses;
	}

	public void setStageMallFavoriteGoodses(List<StageMallFavoriteGoodsVO> stageMallFavoriteGoodses) {
		this.stageMallFavoriteGoodses = stageMallFavoriteGoodses;
	}

}
