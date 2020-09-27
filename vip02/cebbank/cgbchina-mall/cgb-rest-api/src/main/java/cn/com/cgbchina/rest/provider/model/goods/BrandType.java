package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL336 类别品牌查询
 * 
 * @author lizy 2016/4/28.
 */
public class BrandType extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7981200979994259587L;
	private String typeId;
	private String parentId;
	private String orderTypeId;
	private String levelCode;
	private String levelNm;
	private String levelSeq;
	private String levelDesc;
	private String pictureUrl;

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getOrderTypeId() {
		return orderTypeId;
	}

	public void setOrderTypeId(String orderTypeId) {
		this.orderTypeId = orderTypeId;
	}

	public String getLevelCode() {
		return levelCode;
	}

	public void setLevelCode(String levelCode) {
		this.levelCode = levelCode;
	}

	public String getLevelNm() {
		return levelNm;
	}

	public void setLevelNm(String levelNm) {
		this.levelNm = levelNm;
	}

	public String getLevelSeq() {
		return levelSeq;
	}

	public void setLevelSeq(String levelSeq) {
		this.levelSeq = levelSeq;
	}

	public String getLevelDesc() {
		return levelDesc;
	}

	public void setLevelDesc(String levelDesc) {
		this.levelDesc = levelDesc;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

}
