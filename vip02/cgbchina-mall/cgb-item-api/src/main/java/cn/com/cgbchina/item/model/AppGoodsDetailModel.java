package cn.com.cgbchina.item.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

public class AppGoodsDetailModel implements Serializable {

	/**
	 * 商品详情
	 */
	private static final long serialVersionUID = -1;
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
	private String areaCode;
	@Getter
	@Setter
	private String jfType;
	@Getter
	@Setter
	private String jfTypeNm;
	@Getter
	@Setter
	private String goods_type;
	@Getter
	@Setter
	private String jpPricePayid;
	@Getter
	@Setter
	private String jpPrice;
	@Getter
	@Setter
	private String tzPricePayid;
	@Getter
	@Setter
	private String tzPrice;
	@Getter
	@Setter
	private String dzPricePayid;
	@Getter
	@Setter
	private String dzPrice;
	@Getter
	@Setter
	private String vipPricePayid;
	@Getter
	@Setter
	private String vipPrice;
	@Getter
	@Setter
	private String brhPricePayid;
	@Getter
	@Setter
	private String brhPrice;
	@Getter
	@Setter
	private String jfxjPricePayid;
	@Getter
	@Setter
	private String jfPart;
	@Getter
	@Setter
	private String xjPart;
	@Getter
	@Setter
	private String actPointId;
	@Getter
	@Setter
	private String actPoint;
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
	private String goodsSize;
	@Getter
	@Setter
	private String alertNum;
	@Getter
	@Setter
	private String goodsBacklog;
	@Getter
	@Setter
	private String goodsDetailDesc;
	@Getter
	@Setter
	private String paywayIdY;
	@Getter
	@Setter
	private String pictureUrl;
	@Getter
	@Setter
	private String canIntegral;
	@Getter
	@Setter
	private String unitIntegral;
	@Getter
	@Setter
	private String goodsProp1;
	@Getter
	@Setter
	private String goodsProp2;
	@Getter
	@Setter
	private String marketPrice;
	@Getter
	@Setter
	private String countLimit;
	@Getter
	@Setter
	private String wechatStatus;
	@Getter
	@Setter
	private String wechatAStatus;
	@Getter
	@Setter
	private String vendorPhone;
	@Getter
	@Setter
	private String goodsType;
	@Getter
	@Setter
	private String actBeginDate;
	@Getter
	@Setter
	private String actBeginTime;
	@Getter
	@Setter
	private String actEndDate;
	@Getter
	@Setter
	private String actEndTime;
	@Getter
	@Setter
	private String mallDate;
	@Getter
	@Setter
	private String mallTime;
	@Getter
	@Setter
	private String actStatus;
	@Getter
	@Setter
	private String custLevel;
	@Getter
	@Setter
	private String custPointRate;
	@Getter
	@Setter
	private String ifFixPoint;
	@Getter
	@Setter
	private String vendorTime;
	@Getter
	@Setter
	private String actionCount;
	@Getter
	@Setter
	private String soldNum;
	@Getter
	@Setter
	private String goodsTotal;
	@Getter
	@Setter
	private String remindStatus;
	@Getter
	@Setter
	private String collectStatus;
	@Getter
	@Setter
	private Double bestRate;
	@Getter
	@Setter
	private String appStatus;
	@Getter
	@Setter
	private String actId;
	@Getter
	@Setter
	private List<AppStageInfo> stageInfo = new ArrayList<AppStageInfo>();
	@Getter
	@Setter
	private List<AppPrivilegeInfo> privilegeInfo = new ArrayList<AppPrivilegeInfo>();
	@Getter
	@Setter
	private List<AppGoodsInfo> goodsInfo = new ArrayList<AppGoodsInfo>();
	@Getter
	@Setter
	private List<AppBackLogInfo> backlogInfo = new ArrayList<AppBackLogInfo>();
	@Getter
	@Setter
	private String rate;//倍率优先取"产品倍率"，若"产品倍率"为空，则取"全局倍率"
	@Getter
	@Setter
	private GoodsModel goodsModel;

}