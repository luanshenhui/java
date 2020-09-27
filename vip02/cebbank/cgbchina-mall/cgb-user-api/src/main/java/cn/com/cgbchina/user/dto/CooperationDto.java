package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.StageRateModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;

import java.io.Serializable;
import java.util.List;

/**
 * Created by niufw on 16-4-25.
 */
public class CooperationDto extends VendorInfoDto implements Serializable {
	private static final long serialVersionUID = -590551394635822534L;
	/**
	 * 分期费率
	 */
	private List<TblVendorRatioModel> tblVendorRatioModelList;

	public List<TblVendorRatioModel> getTblVendorRatioModelList() {
		return tblVendorRatioModelList;
	}

	public void setTblVendorRatioModelList(List<TblVendorRatioModel> tblVendorRatioModelList) {
		this.tblVendorRatioModelList = tblVendorRatioModelList;
	}

	/**
	 * 邮购分期
	 */
	private List<MailStagesModel> mailStagesModelList;

	public List<MailStagesModel> getMailStagesModelList() {
		return mailStagesModelList;
	}

	public void setMailStagesModelList(List<MailStagesModel> mailStagesModelList) {
		this.mailStagesModelList = mailStagesModelList;
	}
}
