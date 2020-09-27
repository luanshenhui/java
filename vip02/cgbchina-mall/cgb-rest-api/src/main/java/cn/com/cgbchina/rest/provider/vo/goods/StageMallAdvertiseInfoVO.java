package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.AllowNull;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL321 广告查询(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallAdvertiseInfoVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4269108569327448380L;
	private String id;
	@XMLNodeName(value = "link_type")
	private String linkType;
	@XMLNodeName(value = "advertise_desc")
	private String advertiseDesc;
	@XMLNodeName(value = "advertise_seq")
	private String advertiseSeq;
	@XMLNodeName(value = "phone_href")
	private String phoneHref;
	@AllowNull
	private String keyword;
	@XMLNodeName(value = "picture_url")
	private String pictureUrl;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLinkType() {
		return linkType;
	}

	public void setLinkType(String linkType) {
		this.linkType = linkType;
	}

	public String getAdvertiseDesc() {
		return advertiseDesc;
	}

	public void setAdvertiseDesc(String advertiseDesc) {
		this.advertiseDesc = advertiseDesc;
	}

	public String getAdvertiseSeq() {
		return advertiseSeq;
	}

	public void setAdvertiseSeq(String advertiseSeq) {
		this.advertiseSeq = advertiseSeq;
	}

	public String getPhoneHref() {
		return phoneHref;
	}

	public void setPhoneHref(String phoneHref) {
		this.phoneHref = phoneHref;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

}
