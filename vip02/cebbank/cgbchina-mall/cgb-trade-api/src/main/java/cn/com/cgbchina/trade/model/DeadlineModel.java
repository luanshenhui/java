package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import java.io.Serializable;
import java.util.Date;

public class DeadlineModel implements Serializable {

	private static final long serialVersionUID = -4362041916845342112L;
	private Long id;// id

	private String status;// 交易状态 0：等待买家付款 1：卖家已发货，等待买家确认收货 2：买家申请退款退货，等待卖家处理退款退货申请

	private Integer end;// 到几天结束

	private String rule;// 超时规则

	private Integer warn;// 超时提醒几天

	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除

	private String creatOper;// 创建人

	private java.util.Date createTime;// 创建时间
	private String updateOper;// 更新人
	private java.util.Date updateTime;// 更新时间

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getEnd() {
		return end;
	}

	public void setEnd(Integer end) {
		this.end = end;
	}

	public String getRule() {
		return rule;
	}

	public void setRule(String rule) {
		this.rule = rule;
	}

	public Integer getWarn() {
		return warn;
	}

	public void setWarn(Integer warn) {
		this.warn = warn;
	}

	public Integer getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(Integer delFlag) {
		this.delFlag = delFlag;
	}

	public String getCreatOper() {
		return creatOper;
	}

	public void setCreatOper(String creatOper) {
		this.creatOper = creatOper;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getUpdateOper() {
		return updateOper;
	}

	public void setUpdateOper(String updateOper) {
		this.updateOper = updateOper;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
}