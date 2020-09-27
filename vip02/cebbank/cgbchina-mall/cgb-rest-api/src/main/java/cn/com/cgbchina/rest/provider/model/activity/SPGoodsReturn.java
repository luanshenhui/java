package cn.com.cgbchina.rest.provider.model.activity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL335 特殊商品列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class SPGoodsReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1576801148871373097L;
	private String totalPages;
	private String totalCount;
	private String areaNm;
	private String typePnm;
	private String typeNm;
	private String mallDate;
	private String mallTime;
	private String keyWord;
	private List<SPGoodsInfo> spGoodsInfos = new ArrayList<SPGoodsInfo>();

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

	public String getKeyWord() {
		return keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public List<SPGoodsInfo> getSpGoodsInfos() {
		return spGoodsInfos;
	}

	public void setSpGoodsInfos(List<SPGoodsInfo> spGoodsInfos) {
		this.spGoodsInfos = spGoodsInfos;
	}

}
