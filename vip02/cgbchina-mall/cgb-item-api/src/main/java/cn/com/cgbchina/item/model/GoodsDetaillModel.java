package cn.com.cgbchina.item.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

public class GoodsDetaillModel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8765328962406396235L;
	@Getter
	@Setter
	private String goodsId;
	@Getter
	@Setter
	private String goodsNm;
	@Getter
	@Setter
	private String goodsMid;
	@Getter
	@Setter
	private String goodsOid;
	@Getter
	@Setter
	private String goodsXid;
	@Getter
	@Setter
	private String goodsPrice;
	@Getter
	@Setter
	private String vendorId;
	@Getter
	@Setter
	private String vendorFnm;
	@Getter
	@Setter
	private String vendorSnm;
	@Getter
	@Setter
	private String typePid;
	@Getter
	@Setter
	private String levelPnm;
	@Getter
	@Setter
	private String typeId;
	@Getter
	@Setter
	private String levelNm;
	@Getter
	@Setter
	private String goodsColor;
	@Getter
	@Setter
	private String goodsSize;
	@Getter
	@Setter
	private String goodsBacklog;
	@Getter
	@Setter
	private String goodsBaseDesc;
	@Getter
	@Setter
	private String goodsDetailDesc;
	@Getter
	@Setter
	private String phone;
	@Getter
	@Setter
	private String paywayIdY;
	@Getter
	@Setter
	private String goodsPresent;
	@Getter
	@Setter
	private String actionType;
	@Getter
	@Setter
	private String canIntegral;
	@Getter
	@Setter
	private String unitIntegral;
	@Getter
	@Setter
	private String loopCount;
	@Getter
	@Setter
	private List<StageMallGoodsDetailStageInfoVO> stageMallGoodsDetailStageInfos = new ArrayList<StageMallGoodsDetailStageInfoVO>();
	@Getter
	@Setter
	private List<StageMallGoodsDetailPrivilegeInfoVO> stageMallGoodsDetailPrivilegeInfos = new ArrayList<StageMallGoodsDetailPrivilegeInfoVO>();
}