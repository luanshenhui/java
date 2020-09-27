package cn.com.cgbchina.user.dto;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.user.model.TblVendorRatioModel;

/**
 * Created by niufw on 16-4-25.
 */
public class StageRateDto implements Serializable {
	private static final long serialVersionUID = -502958742920550328L;
	private List<TblVendorRatioModel> tblVendorRatioModelList;

	public List<TblVendorRatioModel> getTblVendorRatioModelList() {
		return tblVendorRatioModelList;
	}

	public void setTblVendorRatioModelList(List<TblVendorRatioModel> tblVendorRatioModelList) {
		this.tblVendorRatioModelList = tblVendorRatioModelList;
	}
}
