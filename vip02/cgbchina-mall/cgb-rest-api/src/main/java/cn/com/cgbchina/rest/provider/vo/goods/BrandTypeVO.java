package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL336 类别品牌查询
 * 
 * @author lizy 2016/4/28.
 */
public class BrandTypeVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7981200979994259587L;
	@XMLNodeName(value = "type_id")
	private String typeId;
	@XMLNodeName(value = "parent_id")
	private String parentId;
	@XMLNodeName(value = "orderType_id")
	private String orderTypeId;
	@XMLNodeName(value = "level_code")
	private String levelCode;
	@XMLNodeName(value = "level_nm")
	private String levelNm;
	@XMLNodeName(value = "level_seq")
	private String levelSeq;
	@XMLNodeName(value = "level_desc")
	private String levelDesc;
	@XMLNodeName(value = "picture_url")
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
