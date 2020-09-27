package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL336 类别品牌查询
 * 
 * @author lizy 2016/4/28.
 */
public class BrandTypeQueryVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7846343151200732570L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	private String queryType;
	@XMLNodeName(value = "type_id")
	private String typeId;
	@NotNull
	private String rowsPage;
	@NotNull
	private String currentPage;

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

	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public String getRowsPage() {
		return rowsPage;
	}

	public void setRowsPage(String rowsPage) {
		this.rowsPage = rowsPage;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}

}
