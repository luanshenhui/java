package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.model.VendorInfoModel;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.ListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by lvzd on 2016/9/15.
 */
@Setter
@Getter
@Slf4j
public class OrderMainDto extends BaseOrderDto implements Serializable {
    private static final long serialVersionUID = -54520433264642729L;
    private String sourceId;
    private String sourceNm;

    private String itemCode;
    private Integer totalNum = 0;
    private Long jfTotalNum = 0L;
    private Long jfTotalNumNoFix = 0L;
    private BigDecimal totalPrice = new BigDecimal("0");
    private BigDecimal voucherPriceTotal = new BigDecimal("0");
    private BigDecimal deduction = new BigDecimal("0");
    private MemberAddressModel memberAddressModel;
    // 商品类型
    private String goodsType = "";
    private List<String> vendorCodes;
    private List<ItemModel> itemModels;
    private Map<String, Long> stockMap;
    private Map<String, TblGoodsPaywayModel> goodsPaywayModelMap;
    // 活动商品集合
    private List<Map<String, String>> promItemMap;
    private Map<String, Integer> promotionTypeMap;
    private ListMultimap<String, OrderCommitInfoDto> orderCommitInfoDtoListMultimap;
    private Map<String, VendorInfoModel> vendorInfo;
    private PointPoolModel pointPoolModel;
    private String miaoshaFlag = "";
    private Map<String, GoodsModel> goodsInfo;
    private Map<String, VendorInfoDto> vendorInfoDtoMap;
    private Map<String, ItemModel> itemModelMap;
    private int goodsCount;
    private Map<String, Long> stockRestMap;
    private Map<String, String> privilegeIdMap;// 优惠券ID map key是itemCode
    private EspCustNewModel espCustNewModel;
    private Map<String, BigDecimal> privilegeMoneyMap;// 优惠券抵扣金额
    private Map<String, String> privilegeNameMap;// 优惠券名称
    private Map<String, Long> jfCountMap;// 积分总数 key itemCode
    private Map<String, Boolean> fixFlagMap;// key itemCode
    private Map<String, MallPromotionResultDto> promotionMap;// 活动详情
							     // key为itemCode
    private Map<String, String> cartIdMap;// 购物车
    private Map<String, BigDecimal> discountPrivMonMap;// 积分抵扣金额MAP
    private Map<String, Integer> goodsCountMap;// 每个商品购买件数
    private Map<String, String> pointTypeMap;// 积分类型

    private Long singlePoint;// 积分异常
    private Map<String,BigDecimal> oriPriceMap;//原价
    
    public void addOriPriceMap(String itemCode, BigDecimal oriPrice) {
		if (oriPrice == null) {
			return;
		}
		if (oriPriceMap == null) {
			oriPriceMap = Maps.newHashMap();
		}
		this.oriPriceMap.put(itemCode, oriPrice);
	}

    public void addPointTypeMap(String itemCode, String pointType) {
		if (pointType == null) {
			return;
		}
		if (pointTypeMap == null) {
			pointTypeMap = Maps.newHashMap();
		}
		this.pointTypeMap.put(itemCode, pointType);
    }

    public void addGoodsCountMap(String itemCode, int count) {
		if (goodsCountMap == null) {
			goodsCountMap = Maps.newHashMap();
		}
		if (goodsCountMap.containsKey(itemCode)) {
			this.goodsCountMap.put(itemCode, goodsCountMap.get(itemCode) + count);
		} else {
			this.goodsCountMap.put(itemCode, count);
		}
    }

    public void addDiscountPriviMonMap(String itemCode, BigDecimal discountPriviMoney) {
		if (discountPriviMoney == null) {
			return;
		}
		if (discountPrivMonMap == null) {
			discountPrivMonMap = Maps.newHashMap();
		}
		if (discountPrivMonMap.containsKey(itemCode)) {
			this.discountPrivMonMap.put(itemCode, discountPrivMonMap.get(itemCode).add(discountPriviMoney));
		} else {
			this.discountPrivMonMap.put(itemCode, discountPriviMoney);
		}
    }

    public void addCartIdMap(String itemCode, String cartId) {
		if (cartId == null) {
			return;
		}
		if (cartIdMap == null) {
			cartIdMap = Maps.newHashMap();
		}
		this.cartIdMap.put(itemCode, cartId);
    }

    public void addPromotionMap(String itemCode, MallPromotionResultDto promotion) {
		if (promotion == null) {
			return;
		}
		if (promotionMap == null) {
			promotionMap = Maps.newHashMap();
		}
		this.promotionMap.put(itemCode, promotion);
    }

    public void addjfCountMap(String itemCode, Long jfCount) {
		if (jfCount == null) {
			return;
		}
		if (jfCountMap == null) {
			jfCountMap = Maps.newHashMap();
		}
		if (jfCountMap.containsKey(itemCode)) {
			this.jfCountMap.put(itemCode, jfCountMap.get(itemCode) + jfCount);
		} else {
			this.jfCountMap.put(itemCode, jfCount);
		}
    }

    public void addFixFlagMap(String itemCode, Boolean fixFlag) {
		if (fixFlag == null) {
			return;
		}
		if (fixFlagMap == null) {
			fixFlagMap = Maps.newHashMap();
		}
		this.fixFlagMap.put(itemCode, fixFlag);
    }

    public void addPrivilegeIdMap(String itemCode, String privilegeId) {
		if (privilegeId == null) {
			return;
		}
		if (privilegeIdMap == null) {
			privilegeIdMap = Maps.newHashMap();
		}
		this.privilegeIdMap.put(itemCode, privilegeId);
    }

    public void addPrivilegeMoneyMap(String itemCode, BigDecimal privilegeMoney) {
		if (privilegeMoney == null) {
			return;
		}
		if (privilegeMoneyMap == null) {
			privilegeMoneyMap = Maps.newHashMap();
		}
		if (privilegeMoneyMap.containsKey(itemCode)) {
			this.privilegeMoneyMap.put(itemCode, privilegeMoneyMap.get(itemCode).add(privilegeMoney));
		} else {
			this.privilegeMoneyMap.put(itemCode, privilegeMoney);
		}

    }

    public void addPrivilegeNameMap(String itemCode, String privilegeName) {
		if (privilegeName == null) {
			return;
		}
		if (privilegeNameMap == null) {
			privilegeNameMap = Maps.newHashMap();
		}
		this.privilegeNameMap.put(itemCode, privilegeName);
    }

    private void addGoodsCount(int goodsCount) {
	this.goodsCount = this.goodsCount + goodsCount;
    }

    public void addTotalNum(Integer totalNum) {
		if (totalNum == null) return;
		this.totalNum = this.totalNum + totalNum;
    }

    public void addJfTotalNum(Long jfTotalNum) {
		if (jfTotalNum == null) return;
		this.jfTotalNum = this.jfTotalNum + jfTotalNum;
    }

    public void addJfTotalNumNoFix(Long jfTotalNumNoFix) {
		if (jfTotalNumNoFix == null) return;
		this.jfTotalNumNoFix = this.jfTotalNumNoFix + jfTotalNumNoFix;
    }

    public void addTotalPrice(BigDecimal totalPrice) {
		if (totalPrice == null) return;
		this.totalPrice = this.totalPrice.add(totalPrice);
    }

    public void addVoucherPriceTotal(BigDecimal voucherPriceTotal) {
		if (voucherPriceTotal == null) return;
		this.voucherPriceTotal = this.voucherPriceTotal.add(voucherPriceTotal);
    }

    public void addDeduction(BigDecimal deduction) {
		if (deduction == null) return;
		this.deduction = this.deduction.add(deduction);
    }

    public void addVendorCode(String vendorCode) {
		if (vendorCode == null)
			return;
		if (this.vendorCodes == null) {
			vendorCodes = Lists.newArrayList();
		}
		vendorCodes.add(vendorCode);
    }

    public void putStock(String itemCd, Long stock) {
		if (stockMap == null) {
			this.stockMap = Maps.newHashMap();
		}
		this.stockMap.put(itemCd, stock);
    }

    public void putRestStock(String itemCd, Integer cnt) {
		if (stockRestMap == null) {
			this.stockRestMap = Maps.newHashMap();
		}
		if (stockRestMap.containsKey(itemCd)) {
			this.stockRestMap.put(itemCd, stockRestMap.get(itemCd) + cnt);
		} else {
			this.stockRestMap.put(itemCd, (long) cnt);
		}
    }

    public void addItemModel(ItemModel itemModel) {
		if (itemModel == null)
			return;
		if (this.itemModels == null) {
			this.itemModels = Lists.newArrayList();
		}
		if (orderCommitInfoDtoListMultimap == null
			|| !orderCommitInfoDtoListMultimap.keySet().contains(
				itemModel.getCode())) {
			this.itemModels.add(itemModel);
		}
		if (itemModelMap == null) {
			itemModelMap = Maps.newHashMap();
		}
		itemModelMap.put(itemModel.getCode(), itemModel);
    }


	private Map<String, PromotionPayWayModel> promotionGoodsPaywayModelMap;
	public void putPromotionGoodsPayway(String paywayId, PromotionPayWayModel promotionPayWayModel) {
		if (paywayId == null)
			return;
		if (promotionPayWayModel == null)
			return;
		if (this.promotionGoodsPaywayModelMap == null) {
			this.promotionGoodsPaywayModelMap = Maps.newHashMap();
		}
		this.promotionGoodsPaywayModelMap.put(paywayId, promotionPayWayModel);
	}

    public void putGoodsPayway(String paywayId, TblGoodsPaywayModel tblGoodsPaywayModel) {
		if (paywayId == null)
			return;
		if (tblGoodsPaywayModel == null)
			return;
		if (this.goodsPaywayModelMap == null) {
			this.goodsPaywayModelMap = Maps.newHashMap();
		}
		this.goodsPaywayModelMap.put(paywayId, tblGoodsPaywayModel);
    }

    public void addProItemMap(Map<String, String> map) {
		if (map == null)
			return;
		if (promItemMap == null) {
			promItemMap = Lists.newArrayList();
		}
		promItemMap.add(map);
    }

    public void putOrderCommitInfoDto(String itemCode, OrderCommitInfoDto orderCommitInfoDto) {
		if (itemCode == null)
			return;
		if (orderCommitInfoDto == null)
			return;
		if (orderCommitInfoDtoListMultimap == null) {
			orderCommitInfoDtoListMultimap = ArrayListMultimap.create();
		}
		orderCommitInfoDtoListMultimap.put(itemCode, orderCommitInfoDto);
    }

    public void putVendorInfo(String key, VendorInfoModel vendorInfoModel) {
		if (key == null) return;
		if (vendorInfoModel == null) return;
		if (vendorInfo == null) {
			vendorInfo = Maps.newHashMap();
		}
		vendorInfo.put(key, vendorInfoModel);
    }

    public void putGoodsInfo(String key, GoodsModel goodsModel) {
		if (key == null) return;
		if (goodsModel == null) return;
		if (goodsInfo == null) {
			goodsInfo = Maps.newHashMap();
		}
		this.goodsInfo.put(key, goodsModel);
    }

    public void putVendorInfoDto(String key, VendorInfoDto vendorInfoDto) {
		if (key == null) return;
		if (vendorInfoDto == null) return;
		if (vendorInfoDtoMap == null) {
			vendorInfoDtoMap = Maps.newHashMap();
		}
		vendorInfoDtoMap.put(key, vendorInfoDto);
    }

	private Map<String, Integer> promotionLimitMap;
	public void putPromotionLimitMap(OrderCommitInfoDto orderCommitInfoDto) {
		if (orderCommitInfoDto == null) return;
		if (orderCommitInfoDto.getPromotion() != null && orderCommitInfoDto.getPromotion().getId() != null) {
			// 满减活动不校验
			if (orderCommitInfoDto.getPromotion().getPromType().intValue() == 50) {
				return;
			}
			if (promotionLimitMap == null) {
				promotionLimitMap = Maps.newHashMap();
			}
			String idAndPeriodId = orderCommitInfoDto.getPromotion().getId().toString() + "," + orderCommitInfoDto.getPromotion().getPeriodId()
					+ "," + orderCommitInfoDto.getCode();
			int itemCount = orderCommitInfoDto.getItemCount();
			if (promotionLimitMap.containsKey(idAndPeriodId)) {
				promotionLimitMap.put(idAndPeriodId, promotionLimitMap.get(idAndPeriodId).intValue() + itemCount);
			} else {
				promotionLimitMap.put(idAndPeriodId, itemCount);
			}
		}
	}

    public void addOrderMainData(OrderMainSingleCheckDto ret) {
		if (ret.getItemModel() == null) {
			return;
		}
		this.setReturnCode(ret.getReturnCode());
		this.setReturnDes(ret.getReturnDes());
		this.addTotalNum(ret.getTotalNum());
		this.addJfTotalNum(ret.getJfTotalNum());
		this.addJfTotalNumNoFix(ret.getJfTotalNumNoFix());
		this.addTotalPrice(ret.getTotalPrice());
		this.addVoucherPriceTotal(ret.getVoucherPriceTotal());
		this.addDeduction(ret.getDeduction());
		this.putGoodsPayway(ret.getPayWayId(), ret.getTblGoodsPaywayModel());
		this.putPromotionGoodsPayway(ret.getPayWayId(), ret.getPromotionPayWayModel());
		this.addItemModel(ret.getItemModel());
		this.putOrderCommitInfoDto(ret.getItemModel().getCode(),
			ret.getOrderCommitInfoDto());
		this.putPromotionLimitMap(ret.getOrderCommitInfoDto());
		if (ret.getPromotionType() != null) {
			if (this.promotionTypeMap == null) {
				this.promotionTypeMap = Maps.newHashMap();
			}
			this.getPromotionTypeMap().put(ret.getItemCode(),
				ret.getPromotionType());
		}
		this.addGoodsCount(ret.getGoodsCount());
		if (ret.getItemModel() != null) {
			this.putGoodsInfo(ret.getItemModel().getGoodsCode(),
				ret.getGoodsModel());
		}
		if ((this.goodsType.equals("") || this.goodsType == null) && ret.getGoodsModel() != null) {
			this.goodsType = ret.getGoodsModel().getGoodsType();
		}
		this.putVendorInfoDto(ret.getVendorId(), ret.getVendorInfoDto());
		this.putRestStock(ret.getItemModel().getCode(), ret.getGoodsCount());
		this.addPrivilegeIdMap(ret.getItemModel().getCode(),
			ret.getPrivilegeId());// 优惠券ID MAP
		this.addPrivilegeNameMap(ret.getItemModel().getCode(),
			ret.getPrivilegeName());// 优惠券名称 map
		this.addPrivilegeMoneyMap(ret.getItemModel().getCode(),
			ret.getPrivilegeMoney());// 优惠券 金额 map
		// 是否固定积分
		this.addFixFlagMap(ret.getItemModel().getCode(), ret.getFixFlag());
		// 总积分数
		this.addjfCountMap(ret.getItemModel().getCode(), ret.getJfCount());
		// 活动信息
		this.addPromotionMap(ret.getItemModel().getCode(),
			ret.getMallPromotionResultDto());
		// 购物车map keyItemCode
		this.addCartIdMap(ret.getItemModel().getCode(), ret.getCustCartId());
		// 积分抵扣金额
		this.addDiscountPriviMonMap(ret.getItemModel().getCode(),
			ret.getDiscountPrivMon());
		// 每种商品数量
		this.addGoodsCountMap(ret.getItemModel().getCode(), ret.getGoodsCount());
		// 积分类型
		this.addPointTypeMap(ret.getItemModel().getCode(), ret.getPointType());
		// 普通价格
		this.addOriPriceMap(ret.getItemModel().getCode(), ret.getOriPrice());
    }

//    @Setter
//    @Getter
//    @ToString
//    private class OrderPromotionDto {
//		private Long promId;
//		private String periodId;
//		private String itemCd;
//		private Integer itemCount;
//		private int promType;
//    }
}
