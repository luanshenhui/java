package cn.com.cgbchina.item.dto;

import javax.annotation.Nullable;
import java.io.Serializable;
import java.util.Date;

/**
 *
 */
public class GoodsConsultDto implements Serializable {


	private static final long serialVersionUID = 8134916786703857809L;
	private Long id;
	private String goodsCode;
	private String goodsName;
	private String vendorId;
	private String vendorName;
	private Long brandId;
	private String brandName;
	private Long backCategory1Id;
	private String backCategory1Name;
	private Long backCategory2Id;
	private String backCategory2Name;
	private Long backCategory3Id;
	private String backCategory3Name;
	private String adviceContent;
	private Date adviceDateTime;
	@Nullable
	private String replyContent;
	private Date replyDateTime;
	private Integer isShow;
	private String image1;//图片1

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getGoodsCode() {
		return goodsCode;
	}

	public void setGoodsCode(String goodsCode) {
		this.goodsCode = goodsCode;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getVendorName() {
		return vendorName;
	}

	public void setVendorName(String vendorName) {
		this.vendorName = vendorName;
	}

	public Long getBrandId() {
		return brandId;
	}

	public void setBrandId(Long brandId) {
		this.brandId = brandId;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public Long getBackCategory1Id() {
		return backCategory1Id;
	}

	public void setBackCategory1Id(Long backCategory1Id) {
		this.backCategory1Id = backCategory1Id;
	}

	public String getBackCategory1Name() {
		return backCategory1Name;
	}

	public void setBackCategory1Name(String backCategory1Name) {
		this.backCategory1Name = backCategory1Name;
	}

	public Long getBackCategory2Id() {
		return backCategory2Id;
	}

	public void setBackCategory2Id(Long backCategory2Id) {
		this.backCategory2Id = backCategory2Id;
	}

	public String getBackCategory2Name() {
		return backCategory2Name;
	}

	public void setBackCategory2Name(String backCategory2Name) {
		this.backCategory2Name = backCategory2Name;
	}

	public Long getBackCategory3Id() {
		return backCategory3Id;
	}

	public void setBackCategory3Id(Long backCategory3Id) {
		this.backCategory3Id = backCategory3Id;
	}

	public String getBackCategory3Name() {
		return backCategory3Name;
	}

	public void setBackCategory3Name(String backCategory3Name) {
		this.backCategory3Name = backCategory3Name;
	}

	public String getAdviceContent() {
		return adviceContent;
	}

	public void setAdviceContent(String adviceContent) {
		this.adviceContent = adviceContent;
	}

	public Date getAdviceDateTime() {
		return adviceDateTime;
	}

	public void setAdviceDateTime(Date adviceDateTime) {
		this.adviceDateTime = adviceDateTime;
	}

	public String getReplyContent() {
		return replyContent;
	}

	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}

	public Date getReplyDateTime() {
		return replyDateTime;
	}

	public void setReplyDateTime(Date replyDateTime) {
		this.replyDateTime = replyDateTime;
	}

	public Integer getIsShow() {
		return isShow;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}

	public String getImage1() {
		return image1;
	}

	public void setImage1(String image1) {
		this.image1 = image1;
	}
}
