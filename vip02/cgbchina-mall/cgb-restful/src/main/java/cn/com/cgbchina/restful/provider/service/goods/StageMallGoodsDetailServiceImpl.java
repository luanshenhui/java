package cn.com.cgbchina.restful.provider.service.goods;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsDetaillModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsDetailService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailPrivilegeInfo;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailReturn;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailQuery;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.restful.provider.service.order.OrderChannelService;

@Slf4j
@Service
public class StageMallGoodsDetailServiceImpl implements StageMallGoodsDetailService {
	@Resource
	RestItemService restItemService;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	OrderChannelService orderChannelService;
	@Resource
	GoodsService goodsService;
	@Resource
	UserService userService;
	
	@Override
	public StageMallGoodsDetailReturn detail(StageMallGoodsDetailQuery stageMallGoodsDetailQuery) {
		
		Response<GoodsDetaillModel>  response=restItemService.getGoodsDetailByItemCodeAndOmid(stageMallGoodsDetailQuery.getGoodsOmid(), stageMallGoodsDetailQuery.getGoodsId(),stageMallGoodsDetailQuery.getContIdCard());
		StageMallGoodsDetailReturn rst=new StageMallGoodsDetailReturn();
		if(response.isSuccess()){
			GoodsDetaillModel goodsDetailModel=response.getResult();
			if (goodsDetailModel != null) {
				rst=BeanUtils.copy(goodsDetailModel, StageMallGoodsDetailReturn.class);
				Response<GoodsModel>  goodsModelResponse =	goodsService.findGoodsModelByItemCode(goodsDetailModel.getGoodsId());
				if (goodsModelResponse.isSuccess() && goodsModelResponse.getResult() != null) {
					GoodsModel goodsModel =  goodsModelResponse.getResult();
					// 优惠券处理
					// 调用个人网银接口查出客户号
					String contIdCard = stageMallGoodsDetailQuery.getContIdCard();
					UserInfo user  = null;
					if (contIdCard != null && !"".equals(contIdCard.trim())) {
						try {
							// 调用个人网银接口
							QueryUserInfo userInfo = new QueryUserInfo();
							userInfo.setCertNo(contIdCard.trim());
							user = userService.getCousrtomInfo(userInfo);
						} catch (Exception e) {// 如果连接异常
							rst.setReturnCode("000050");
							rst.setReturnDes(MallReturnCode.getReturnDes("000050"));
							return rst;
						}
					}
					if (user != null) {					
						List<CouponInfo> couponInfos =  orderChannelService.queryCouponInfo("",user,goodsModel, null, false);
						List<StageMallGoodsDetailPrivilegeInfo> privilegeInfos = Lists.newArrayList();
						if (couponInfos != null && !couponInfos.isEmpty()) {
							for (CouponInfo couponInfo : couponInfos) {
								StageMallGoodsDetailPrivilegeInfo privilegeInfo = new StageMallGoodsDetailPrivilegeInfo();
								privilegeInfo.setPrivilegeId(couponInfo.getPrivilegeId());
								privilegeInfo.setPrivilegeName(couponInfo.getPrivilegeName());
								privilegeInfo.setProjectNO(couponInfo.getProjectNO());
								privilegeInfo.setLiquidateRatio(new Double(couponInfo.getLiquidateRatio() == null ? "0.0" :couponInfo.getLiquidateRatio().toString()));
								Double privilegeMoney= new Double(couponInfo.getPrivilegeMoney() == null ? "0.0" :couponInfo.getPrivilegeMoney().toString());
								privilegeInfo.setPrivilegeMoney(privilegeMoney);
								Double limitMoney =new Double(couponInfo.getLimitMoney() == null ? "0.0" :couponInfo.getLimitMoney().toString());
								privilegeInfo.setLimitMoney(limitMoney);
								privilegeInfo.setUseActivatiState(couponInfo.getUseActivatiState());
								privilegeInfo.setPastDueState(couponInfo.getPastDueState());
								if(!Contants.CHANNEL_PHONE_CODE.equals(stageMallGoodsDetailQuery.getOrigin())){
									//除了手机银行，其他渠道都另外除了100，所以需要乘以100
									privilegeInfo.setPrivilegeMoney(privilegeMoney*100);
									privilegeInfo.setLimitMoney(limitMoney*100);
								}
								
								privilegeInfo.setRegulation(couponInfo.getRegulation());
								privilegeInfo.setBeginDate(couponInfo.getBeginDate());
								privilegeInfo.setEndDate(couponInfo.getEndDate());
								privilegeInfos.add(privilegeInfo);
							}
						}
						if (!privilegeInfos.isEmpty()) {
							rst.setStageMallGoodsDetailPrivilegeInfos(privilegeInfos);
						}
					}
				}
				// 读取进行中的活动
				boolean promotionFlag = false;
				Response<MallPromotionResultDto> mallPromotionResponse = mallPromotionService.findPromByItemCodes("0",
						stageMallGoodsDetailQuery.getGoodsId(), stageMallGoodsDetailQuery.getOrigin());
				MallPromotionResultDto dto = new MallPromotionResultDto();
				String actionType = "0";//普通商品
				if (response.isSuccess()) {
					dto = mallPromotionResponse.getResult();
					if (dto != null && dto.getPromType() != null) {// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
						// 证明有活动
						promotionFlag = true;
						if(dto.getPromType() == 30){
							actionType = "2";
						}
						if(dto.getPromType() == 40){
							actionType = "1";
						}
					}
				}
				rst.setActionType(actionType);
				
				// 开始日期
				GregorianCalendar mallDate = new GregorianCalendar(TimeZone.getDefault(), Locale.CHINA);
				SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
				String malldate = date.format(mallDate.getTime());
				// 开始时间
				SimpleDateFormat time = new SimpleDateFormat("HHmmss");
				String malltime = time.format(mallDate.getTime());
				
	            rst.setReturnDes("成功");
				rst.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			} else {
				rst.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
				rst.setReturnDes("找不到该商品");
			}
		}else{
			rst.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			rst.setReturnDes("商品查询失败");
		}
		
		return rst;
	}

}
