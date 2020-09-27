/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.restful.provider.impl.order;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.time.DateUtils;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPrice;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPriceRetrun;
import cn.com.cgbchina.rest.provider.service.order.PreferentialPriceQueryService;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceCardFormatNbrs;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceJgIds;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

/**
 * 接口322 获取最优价 日期 : 2016-7-20<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-rest<br>
 * 功能 : <br>
 */
@Service
@Slf4j
public class PreferentialPriceQueryServiceImpl implements PreferentialPriceQueryService {

	@Resource
	GoodsService goodsService;
	@Resource
	RestItemService restItemService;
	@Resource
	private ItemService itemService;

	@Override
	public PreferentialPriceRetrun query(PreferentialPrice preferentialPrice) {
		PreferentialPriceRetrun preferentialPriceRetrun = new PreferentialPriceRetrun();
		String goodsId = preferentialPrice.getGoodsId();
		try {
			// 判断是否有该商品
			if (!Strings.isNullOrEmpty(goodsId)) {
				Response<ItemModel> itemResponse = itemService.findInfoById(goodsId);
				if (!itemResponse.isSuccess() || itemResponse.getResult() == null) {
					log.info("PreferentialPriceQueryServiceImpl.query.item.error:"+MallReturnCode.NotFound_Goods_Code);
					preferentialPriceRetrun.setReturnCode(MallReturnCode.NotFound_Goods_Code);
					preferentialPriceRetrun.setReturnDes(MallReturnCode.NotFound_Goods_Des);
					return preferentialPriceRetrun;
				}
				
				ItemModel itemModel = itemResponse.getResult();
				Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
				if (goodsModelResponse.isSuccess() && goodsModelResponse.getResult() != null) {
					GoodsModel goodsModel = goodsModelResponse.getResult();
					String channelPhone = goodsModel.getChannelPhone();
					if (!Contants.CHANNEL_POINTS_02.equals(channelPhone)) {// 不为手机上架商品，不能加入购物车
						preferentialPriceRetrun.setReturnCode(MallReturnCode.Not_Cell_Up_Code);
						preferentialPriceRetrun.setReturnDes(MallReturnCode.Not_Cell_Up_Des);
						return preferentialPriceRetrun;
					}
					// 判断该客户卡板是否满足购买此礼品条件
					List<String> formatNbrs = Lists.newArrayList();
					if (preferentialPrice.getCardFormatNbrs() != null) {
						for (PreferentialPriceCardFormatNbrs nbr : preferentialPrice.getCardFormatNbrs()) {
							if (!Strings.isNullOrEmpty(nbr.getCardFormatNbr())) {
								formatNbrs.add(nbr.getCardFormatNbr());
							}
						}
					}
					Response<Boolean> judgeCardFormatResponse = restItemService.judgeCardFormatNbr(
							preferentialPrice.getGoodsId(), Lists.newArrayList(formatNbrs));
					if (judgeCardFormatResponse.isSuccess()) {
						if (!judgeCardFormatResponse.getResult()) {
							preferentialPriceRetrun.setReturnCode(MallReturnCode.No_Rigth_CardFormat_Code);
							preferentialPriceRetrun.setReturnDes(MallReturnCode.No_Rigth_CardFormat_Des);
							return preferentialPriceRetrun;
						}
					}
					// 判断客户是否有符合条件的积分类型
					String pointType = goodsModel.getPointsType();
					if (pointType == null) {
						pointType = "";
					}
					boolean jgIdFlag = false;
					for (PreferentialPriceJgIds jgIds : preferentialPrice.getPriceJgIds()) {
						if (pointType.equals(jgIds.getJgId())) {
							jgIdFlag = true;
						}
					}
					if (!jgIdFlag) {
						preferentialPriceRetrun.setReturnCode(MallReturnCode.No_Cell_PiontType_Code);
						preferentialPriceRetrun.setReturnDes(MallReturnCode.No_Cell_PiontType_Des);
						return preferentialPriceRetrun;
					}
					// 判断当天是否为客户生日
					String birthDay = preferentialPrice.getBirthDay();
					boolean isbirthDay = false;
					if(!Strings.isNullOrEmpty(birthDay)){
						isbirthDay = DateHelper.isBrithDay(birthDay);
					}
					if (isbirthDay) {
						preferentialPriceRetrun.setIsBir("0");
					} else {
						preferentialPriceRetrun.setIsBir("1");
					}
					// 填写生日价可用次数
					Response<String> birthUserdCountResponse = restItemService.findCustBirthTimes(preferentialPrice
							.getCustId());
					if (birthUserdCountResponse.isSuccess()) {
						preferentialPriceRetrun.setBrthTimes(birthUserdCountResponse.getResult());
					}
					// 得到最优等级支付方式
					Response<TblGoodsPaywayModel> goodsPaywayResponse = restItemService.findPreferencePayway(
							preferentialPrice.getCustLevel(), preferentialPrice.getGoodsId());
					if (goodsPaywayResponse.isSuccess()) {
						TblGoodsPaywayModel goodsPayway = goodsPaywayResponse.getResult();
						if (goodsPayway != null) {
							preferentialPriceRetrun.setGoodsPaywaId(goodsPayway.getGoodsPaywayId());
							preferentialPriceRetrun.setLevel(goodsPayway.getMemberLevel());
							preferentialPriceRetrun.setGoodsPoint(String.valueOf(goodsPayway.getGoodsPoint()));
						}
					}
					// 生日价
					Response<TblGoodsPaywayModel> paywayBirResponse = restItemService.findBirthPayway(preferentialPrice
							.getGoodsId());
					if (paywayBirResponse.isSuccess()) {
						TblGoodsPaywayModel paywayBir = paywayBirResponse.getResult();
						if (paywayBir != null) {
							preferentialPriceRetrun.setGoodsPaywaIdBir(paywayBir.getGoodsPaywayId());
							preferentialPriceRetrun.setGoodsPointBir(String.valueOf(paywayBir.getGoodsPoint()));
						}
					}
					// 积分加现金价
					Response<TblGoodsPaywayModel> paywayJmResponse = restItemService.findJmPayway(preferentialPrice
							.getGoodsId());
					if (paywayJmResponse.isSuccess()) {
						TblGoodsPaywayModel paywayJm = paywayJmResponse.getResult();
						if (paywayJm != null) {
							preferentialPriceRetrun.setGoodsPaywaIdJm(paywayJm.getGoodsPaywayId());
							preferentialPriceRetrun.setGoodsPointJm(String.valueOf(paywayJm.getGoodsPoint()));
							preferentialPriceRetrun.setGoodsPriceJm(String.valueOf(paywayJm.getGoodsPrice()));
						}
					}
				} else {
					log.error("" + MallReturnCode.NotFound_Goods_Code);
					preferentialPriceRetrun.setReturnCode(MallReturnCode.NotFound_Goods_Code);
					preferentialPriceRetrun.setReturnDes(MallReturnCode.NotFound_Goods_Des);
					return preferentialPriceRetrun;
				}
				preferentialPriceRetrun.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				preferentialPriceRetrun.setReturnDes("");
				return preferentialPriceRetrun;
			} else {
				log.error("" + MallReturnCode.NotFound_Goods_Code);
				preferentialPriceRetrun.setReturnCode(MallReturnCode.NotFound_Goods_Code);
				preferentialPriceRetrun.setReturnDes(MallReturnCode.NotFound_Goods_Des);
				return preferentialPriceRetrun;
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("" + e.getMessage());
			preferentialPriceRetrun.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			preferentialPriceRetrun.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
			return preferentialPriceRetrun;
		}
	}

}
