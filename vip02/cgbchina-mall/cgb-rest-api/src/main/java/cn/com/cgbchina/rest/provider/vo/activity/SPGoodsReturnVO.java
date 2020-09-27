package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL335 特殊商品列表查询
 * 
 * @author lizy 2016/4/28.
 */
public class SPGoodsReturnVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1576801148871373097L;
	@NotNull
	private String returnCode;
	private String returnDes;
	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public String getReturnDes() {
		return returnDes;
	}

	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}

	private String totalPages;
	@NotNull
	private String totalCount;
	@XMLNodeName(value = "area_nm")
	private String areaNm;
	@XMLNodeName(value = "type_pnm")
	private String typePnm;
	@XMLNodeName(value = "type_nm")
	private String typeNm;
	private List<SPGoodsInfoVO> spGoodsInfos = new ArrayList<SPGoodsInfoVO>();
	private String mallDate;
	private String mallTime;
	private String keyWord;
	

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

	public List<SPGoodsInfoVO> getSpGoodsInfos() {
		return spGoodsInfos;
	}

	public void setSpGoodsInfos(List<SPGoodsInfoVO> spGoodsInfos) {
		this.spGoodsInfos = spGoodsInfos;
	}

}
