package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by niufw on 16-4-25.
 */
public class VendorInfoDto extends VendorInfoModel implements Serializable {
	private static final long serialVersionUID = 1261826825003785237L;
	/**
	 * 供应商用户信息表model
	 */
	@Getter
	@Setter
	private VendorModel vendorModel;
	/**
	 * 分期费率
	 */
	@Getter
	@Setter
	private String stageRate;
	/**
	 * 邮购分期
	 */
	@Getter
	@Setter
	private String mailStages;
	/**
	 * 分期费率id的集合
	 */
	@Getter
	@Setter
	private String stageRateIdList;
	/**
	 * 邮购分期id的集合
	 */
	@Getter
	@Setter
	private String mailStagesIdList;
	//一次密码
	@Getter
	@Setter
	private String passwordFirst;

	@Getter
	@Setter
	private List<MailStagesModel> mailStageList;
	@Getter
	@Setter
	private List<TblVendorRatioModel> vendorRatios;

}
