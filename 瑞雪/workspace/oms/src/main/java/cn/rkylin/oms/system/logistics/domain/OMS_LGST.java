package cn.rkylin.oms.system.logistics.domain;



import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import cn.rkylin.oms.common.base.BaseEntity;

/**
 * 
 * <p>
 * 描述： 物流公司访问对象
 * </p>
 */
public class OMS_LGST extends BaseEntity {
	/**
	 * 序列
	 */
	private static final long serialVersionUID = 6888637244431821029L;

	private String lgstId;
	
	private String lgstCode;
	
	private String lgstName;
	
	private String deleted;
	
	public String getLgstId() {
		return lgstId;
	}

	public void setLgstId(String lgstId) {
		this.lgstId = lgstId;
	}

	public String getLgstCode() {
		return lgstCode;
	}

	public void setLgstCode(String lgstCode) {
		this.lgstCode = lgstCode;
	}

	public String getLgstName() {
		return lgstName;
	}

	public void setLgstName(String lgstName) {
		this.lgstName = lgstName;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCreatetime() {
		return createtime;
	}

	public void setCreatetime(String createtime) {
		this.createtime = createtime;
	}

	public String getUpdatetime() {
		return updatetime;
	}

	public void setUpdatetime(String updatetime) {
		this.updatetime = updatetime;
	}

	private String remark;
	
	/**
	 * 创建时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private String createtime;
	
	/**
	 * 修改时间
	 */
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private String updatetime;
	

}