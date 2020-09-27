package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;
import java.util.Date;

public class HotSearchTermModel implements Serializable {

	private static final long serialVersionUID = -1072993141617568438L;
	private Long id;//

	private String name;// 热搜词名字

	private Integer sort;// 排序

	private String status;// 状态 0：开启 1：关闭

	private String delFlag;// 逻辑删除标记 0：未删除 1：已删除

	private String creatOper;// 创建人

	private java.util.Date createTime;// 创建时间

	private String modifyOper;// 更新人

	private java.util.Date modifyTime;// 更新时间

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}
}