package cn.com.cgbchina.item.model;

import javax.annotation.Nullable;
import java.io.Serializable;
import java.util.Date;

/**
 * Created by 11150221040129 on 16-4-8.
 */
public class GoodsConsultModel implements Serializable {

	private static final long serialVersionUID = -4906031262248769233L;
	private Long id;//

	private String goodsCode;// 商品CODE

	private String ordertypeId;// 业务类型代码YG：广发JF：积分

	private Long backCategory1Id;// 一级后台类目

	private Long backCategory2Id;// 二级后台类目

	private Long backCategory3Id;// 三级后台类目

	private Long goodsBrandId;// 品牌ID

	private String vendorId;// 供应商ID

	private String adviceContent;// 咨询内容

	private java.util.Date adviceDatetime;// 咨询时间

	@Nullable
	private String replyContent;// 回复内容

	private java.util.Date replyDatetime;// 回复时间

	private Long memberId;// 会员ID

	private Integer isShow;// 是否显示0显示1隐藏

	private Integer delFlag;// 逻辑删除标识0未删除1已删除

	private String createOper;// 创建者

	private java.util.Date createTime;// 创建时间

	private String modifyOper;// 修改者

	private java.util.Date modifyTime;// 修改时间

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

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
	}

	public Long getBackCategory1Id() {
		return backCategory1Id;
	}

	public void setBackCategory1Id(Long backCategory1Id) {
		this.backCategory1Id = backCategory1Id;
	}

	public Long getBackCategory2Id() {
		return backCategory2Id;
	}

	public void setBackCategory2Id(Long backCategory2Id) {
		this.backCategory2Id = backCategory2Id;
	}

	public Long getBackCategory3Id() {
		return backCategory3Id;
	}

	public void setBackCategory3Id(Long backCategory3Id) {
		this.backCategory3Id = backCategory3Id;
	}

	public Long getGoodsBrandId() {
		return goodsBrandId;
	}

	public void setGoodsBrandId(Long goodsBrandId) {
		this.goodsBrandId = goodsBrandId;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getAdviceContent() {
		return adviceContent;
	}

	public void setAdviceContent(String adviceContent) {
		this.adviceContent = adviceContent;
	}

	public Date getAdviceDatetime() {
		return adviceDatetime;
	}

	public void setAdviceDatetime(Date adviceDatetime) {
		this.adviceDatetime = adviceDatetime;
	}

	public String getReplyContent() {
		return replyContent;
	}

	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}

	public Date getReplyDatetime() {
		return replyDatetime;
	}

	public void setReplyDatetime(Date replyDatetime) {
		this.replyDatetime = replyDatetime;
	}

	public Long getMemberId() {
		return memberId;
	}

	public void setMemberId(Long memberId) {
		this.memberId = memberId;
	}

	public Integer getIsShow() {
		return isShow;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}

	public Integer getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(Integer delFlag) {
		this.delFlag = delFlag;
	}

	public String getCreateOper() {
		return createOper;
	}

	public void setCreateOper(String createOper) {
		this.createOper = createOper;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getModifyOper() {
		return modifyOper;
	}

	public void setModifyOper(String modifyOper) {
		this.modifyOper = modifyOper;
	}

	public Date getModifyTime() {
		return modifyTime;
	}

	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

}
