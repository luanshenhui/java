package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL336 类别品牌查询
 * 
 * @author lizy 2016/4/28.
 */
public class BrandTypeQueryReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 648499762332773438L;
	private String totalPages;
	private String totalCount;
	private List<BrandType> brandTypes = new ArrayList<BrandType>();

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

	public List<BrandType> getBrandTypes() {
		return brandTypes;
	}

	public void setBrandTypes(List<BrandType> brandTypes) {
		this.brandTypes = brandTypes;
	}

}
