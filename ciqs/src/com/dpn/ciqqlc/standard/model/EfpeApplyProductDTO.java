package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 申请产品信息表
 * @author Administrator
 *
 */
public class EfpeApplyProductDTO {
	
	private String productid;//产品ID
	
	private String applyid;//申请ID
	
	private String exportarea;//主要出口国家或地区
	
	private String productname;//产品名称
	
	private String productkind;//产品种类
	
	private String regtrademark;//注册商标
	
	private Date startdate;//申请时间
	
	private String belongmode;//所属模块:01 备案申请书 02 彩信申请书 03变更申请
	
	private String producttype;//产品类型:01本次申请的备案产品 02其他产品
	
	private String productabi;//设计生产能力（吨/年）

	public String getProductid() {
		return productid;
	}

	public void setProductid(String productid) {
		this.productid = productid;
	}

	public String getApplyid() {
		return applyid;
	}

	public void setApplyid(String applyid) {
		this.applyid = applyid;
	}

	public String getExportarea() {
		return exportarea;
	}

	public void setExportarea(String exportarea) {
		this.exportarea = exportarea;
	}

	public String getProductname() {
		return productname;
	}

	public void setProductname(String productname) {
		this.productname = productname;
	}

	public String getProductkind() {
		return productkind;
	}

	public void setProductkind(String productkind) {
		this.productkind = productkind;
	}

	public String getRegtrademark() {
		return regtrademark;
	}

	public void setRegtrademark(String regtrademark) {
		this.regtrademark = regtrademark;
	}

	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public String getBelongmode() {
		return belongmode;
	}

	public void setBelongmode(String belongmode) {
		this.belongmode = belongmode;
	}

	public String getProducttype() {
		return producttype;
	}

	public void setProducttype(String producttype) {
		this.producttype = producttype;
	}

	public String getProductabi() {
		return productabi;
	}

	public void setProductabi(String productabi) {
		this.productabi = productabi;
	}

}
