/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.common.utils.excel.annotation.ExcelField;

/**
 * 单表生成Entity
 * @author ThinkGem
 * @version 2017-01-02
 */
public class DcaCompany extends DataEntity<DcaCompany> {
	
	private static final long serialVersionUID = 1L;
	private String companyId;		// 单位编号
	private String companyYm;		// 企业上报年月
	private String companyY;		// 企业上报年
	private String companyName;		// 企业名
	private String reviewType;		// 审核类型
	private String reviewTypeCount;		// 审核类型件数
	private String fileName;		// 文件名
	private byte[] companyFile;		// 企业上传文件
	private String companyNameAll; // all
	private String sumErr;		   // 问题总数
	private String uid;		       // uid
	private String companyYmF;		// 企业上报年月 
	
	public String getCompanyYmF() {
		return companyYmF;
	}

	public void setCompanyYmF(String companyYmF) {
		this.companyYmF = companyYmF;
	}


	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getCompanyY() {
		return companyY;
	}

	public void setCompanyY(String companyY) {
		this.companyY = companyY;
	}
	
	public String getSumErr() {
		return sumErr;
	}

	public void setSumErr(String sumErr) {
		this.sumErr = sumErr;
	}

	public DcaCompany() {
		super();
	}

	public DcaCompany(String id){
		super(id);
	}
	public String getCompanyNameAll() {
		return companyNameAll;
	}

	public void setCompanyNameAll(String companyNameAll) {
		this.companyNameAll = companyNameAll;
	}

	
	@Length(min=1, max=50, message="企业ID长度必须介于 1 和 50 之间")
	@ExcelField(title="单位编号", align=2, sort=10)
	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	@Length(min=0, max=50, message="企业上报年月长度必须介于 0 和 50 之间")
	@ExcelField(title="所在报表", align=2, sort=20)
	public String getCompanyYm() {
		return companyYm;
	}

	public void setCompanyYm(String companyYm) {
		this.companyYm = companyYm;
	}
	
	@Length(min=0, max=50, message="企业名长度必须介于 0 和 50 之间")
	@ExcelField(title="公式编号", align=2, sort=30)
	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	
	@ExcelField(title="审核类型", align=2, sort=40)
	public String getReviewType() {
		return reviewType;
	}

	public void setReviewType(String reviewType) {
		this.reviewType = reviewType;
	}
	
	public byte[] getCompanyFile() {
		return companyFile;
	}

	public void setCompanyFile(byte[] companyFile) {
		this.companyFile = companyFile;
	}
	
	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getReviewTypeCount() {
		return reviewTypeCount;
	}

	public void setReviewTypeCount(String reviewTypeCount) {
		this.reviewTypeCount = reviewTypeCount;
	}
}