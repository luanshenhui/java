package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL332 取消提醒
 * 
 * @author lizy 2016/4/28.
 */
public class NoticCancelVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6365766796794690766L;
	//
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	@XMLNodeName(value = "act_id")
	private String actId;
	@NotNull
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@NotNull
	@XMLNodeName(value = "end_date")
	private String endDate;
	@NotNull
	@XMLNodeName(value = "end_time")
	private String endTime;
	@NotNull
	@XMLNodeName(value = "do_date")
	private String doDate;
	@NotNull
	@XMLNodeName(value = "do_time")
	private String doTime;

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

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getDoDate() {
		return doDate;
	}

	public void setDoDate(String doDate) {
		this.doDate = doDate;
	}

	public String getDoTime() {
		return doTime;
	}

	public void setDoTime(String doTime) {
		this.doTime = doTime;
	}

}
