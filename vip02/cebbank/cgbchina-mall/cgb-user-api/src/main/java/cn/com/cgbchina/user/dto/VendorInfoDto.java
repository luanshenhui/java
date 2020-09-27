package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;

import java.io.Serializable;
import java.util.List;

/**
 * Created by niufw on 16-4-25.
 */
public class VendorInfoDto extends VendorInfoModel implements Serializable {
	private static final long serialVersionUID = -1794095723466360945L;
	/**
	 * 供应商用户信息表model
	 */
	private VendorModel vendorModel;

	public VendorModel getVendorModel() {
		return vendorModel;
	}

	public void setVendorModel(VendorModel vendorModel) {
		this.vendorModel = vendorModel;
	}

	/**
	 * 分期费率
	 */

	private String stageRate;

	public String getStageRate() {
		return stageRate;
	}

	public void setStageRate(String stageRate) {
		this.stageRate = stageRate;
	}

	/**
	 * 邮购分期
	 */
	private String mailStages;

	public String getMailStages() {
		return mailStages;
	}

	public void setMailStages(String mailStages) {
		this.mailStages = mailStages;
	}

	/**
	 * 分期费率id的集合
	 */
	private String stageRateIdList;

	public String getStageRateIdList() {
		return stageRateIdList;
	}

	public void setStageRateIdList(String stageRateIdList) {
		this.stageRateIdList = stageRateIdList;
	}

	/**
	 * 邮购分期id的集合
	 */
	private String mailStagesIdList;

	public String getMailStagesIdList() {
		return mailStagesIdList;
	}

	public void setMailStagesIdList(String mailStagesIdList) {
		this.mailStagesIdList = mailStagesIdList;
	}

	//一次密码
	private String passwordFirst;

	public String getPasswordFirst() {
		return passwordFirst;
	}

	public void setPasswordFirst(String passwordFirst) {
		this.passwordFirst = passwordFirst;
	}
}
