package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL336 类别品牌查询
 * 
 * @author lizy 2016/4/28.
 */
public class BrandTypeQueryReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 648499762332773438L;
	private String totalPages;
	@NotNull
	private String totalCount;
	private List<BrandTypeVO> brandTypes = new ArrayList<BrandTypeVO>();

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

	public List<BrandTypeVO> getBrandTypes() {
		return brandTypes;
	}

	public void setBrandTypes(List<BrandTypeVO> brandTypes) {
		this.brandTypes = brandTypes;
	}

}
