package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL312 商品搜索列表(分期商城)
 * 
 * @author lizy 2016/4/29.
 */
public class StageMallGoodsQueryReturnVO extends BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8838942300152754281L;
	private String totalPages;
	@NotNull
	private String totalCount;
	@XMLNodeName(value="area_nm")
	private String areaNm;
	@XMLNodeName(value="type_pnm")
	private String typePnm;
	@XMLNodeName(value="type_nm")
	private String typeNm;
	private String mallDate;
	private String mallTime;
	
	public String getMallDate() {
		return mallDate;
	}
	public void setMallDate(String mallDate) {
		this.mallDate = mallDate;
	}
	public String getMallTime() {
		return mallTime;
	}
	public void setMallTime(String mallTime) {
		this.mallTime = mallTime;
	}
	private List<StageMallGoodsQueryInfoVO> stageMallGoodsQueryInfo = new ArrayList<StageMallGoodsQueryInfoVO>();
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
	public String getAreaNm() {
		return areaNm;
	}
	public void setAreaNm(String areaNm) {
		this.areaNm = areaNm;
	}
	public String getTypePnm() {
		return typePnm;
	}
	public void setTypePnm(String typePnm) {
		this.typePnm = typePnm;
	}
	public String getTypeNm() {
		return typeNm;
	}
	public void setTypeNm(String typeNm) {
		this.typeNm = typeNm;
	}
	public List<StageMallGoodsQueryInfoVO> getStageMallGoodsQueryInfo() {
		return stageMallGoodsQueryInfo;
	}
	public void setStageMallGoodsQueryInfo(List<StageMallGoodsQueryInfoVO> stageMallGoodsQueryInfo) {
		this.stageMallGoodsQueryInfo = stageMallGoodsQueryInfo;
	}
	
}	
