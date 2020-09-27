
package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dto.MyCouponDto;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * 优惠券
 */
@Controller
@RequestMapping("/api/mall/coupon")
@Slf4j
public class Coupon {

	@Autowired
	private CouponService couponService;
	@Autowired
	private CouPonInfService couPonInfService;
	@Autowired
	private MessageSources messageSources;

	@RequestMapping(value = "/findMyCoupon",method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<MyCouponDto> findMyCoupon(Integer pageNo, String usedState, String pastState) {
		// 获取用户
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException(401, messageSources.get("user.not.login"));
		}

		Pager<MyCouponDto> couponDtoPa = new Pager<MyCouponDto>();

		List<MyCouponDto> myCouponDtoList = new ArrayList<MyCouponDto>();
		pageNo = pageNo - 1;
		// 请求参数
		QueryCouponInfo info = new QueryCouponInfo();
		info.setChannel("BC");// 交易渠道
		info.setQryType("01");// 查询类型
		info.setRowsPage("10");// 每页行数
		info.setCurrentPage(pageNo.toString());// 当前页数
		info.setContIdCard(user.getCertNo());// 证件号码
		info.setUseState(Byte.valueOf(usedState));// 使用状态
		info.setPastDueState(Byte.valueOf(pastState));// 过期状态

		// 调用接口
		QueryCouponInfoResult result;
		try{
			result = couponService.queryCouponInfo(info);
		} catch (Exception e){
			log.error("trade.time.query.error ,error :{}", "querycoupon.error");
			// 返回错误信息
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("trade.time.query.error"));
		}
		if (!"000000".equals(result.getRetCode())) {
			log.error("trade.time.query.error ,error :{}", result.getRetErrMsg());
			// 返回错误信息
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("trade.time.query.error"));
		}

		// 循环赋值
		if (result.getCouponInfos().size() > 0) {
			for (CouponInfo couponInfo : result.getCouponInfos()) {
				MyCouponDto myCouponDto = new MyCouponDto();
				myCouponDto.setProjectNO(couponInfo.getProjectNO());// 优惠券项目编号
				myCouponDto.setPrivilegeName(couponInfo.getPrivilegeName());// 优惠券名称
				myCouponDto.setPrivilegeMoney(couponInfo.getPrivilegeMoney());// 优惠券金额
				myCouponDto.setLimitMoney(couponInfo.getLimitMoney());// 订单下限金额
				myCouponDto.setBeginDate(couponInfo.getBeginDate());// 有效开始日期
				myCouponDto.setEndDate(couponInfo.getEndDate());// 有效结束日期
				myCouponDto.setRegulation(couponInfo.getRegulation());// 使用规则
				myCouponDtoList.add(myCouponDto);
			}
			//对当前页查询出的优惠券进行排序（开始日期倒序） 对应bug306512  niufw
			Collections.sort(myCouponDtoList, new Comparator<MyCouponDto>() {
				@Override
				public int compare(MyCouponDto myCouponDto1, MyCouponDto myCouponDto2) {
					Long beginTime1 = Long.parseLong(myCouponDto1.getBeginDate());
					Long beginTime2 = Long.parseLong(myCouponDto2.getBeginDate());
					//倒序排列
					if(beginTime1 - beginTime2 > 0 ){
						return -1;
					}else if(beginTime1 - beginTime2 < 0 ){
						return 1;
					}else{
						return 0;
					}
				}
			});
			couponDtoPa.setData(myCouponDtoList);
			couponDtoPa.setTotal(Long.valueOf(result.getTotalPages()));
		}else{
			couponDtoPa.setData( Collections.<MyCouponDto> emptyList());
			couponDtoPa.setTotal(0L);
		}
		log.info("首次登陆优惠卷发放结果查询,totalPages{}条,totalCount{}条，返回错误信息{}",
				result.getTotalPages(),result.getTotalCount(),result.getRetErrMsg());
		return couponDtoPa;
	}

	/**
	 * 优惠券激活
	 *
	 * @param activatedCode
	 * @return
	 */

	@RequestMapping(value = "/activatedCoupon", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean activatedCoupon(String activatedCode) {

		// 获取用户
		User user = UserUtil.getUser();

		ActivateCouponInfo info = new ActivateCouponInfo();
		info.setChannel("BC");// 交易渠道
		info.setContIdCard(user.getCertNo());// 证件号码
		info.setActivation(activatedCode);

		// 调用接口
		ActivateCouponProjectResutl result = couponService.activateCoupon(info);

		if (!"000000".equals(result.getRetCode())) {
			if ("000001".equals(result.getRetCode())) {
				log.error("activation.code.already.exists ,error :{}", result.getRetErrMsg());
				//返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("activation.code.already.exists"));
			}else if("GWERR".equals(result.getRetErrMsg().substring(0,5))){
				log.error("activation.code.error.cause.by.system ,error :{}", result.getRetErrMsg());
				//返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("activation.code.error.cause.by.system"));
			}else {
				log.error("activation.was.not.successful ,error :{}", result.getRetErrMsg());
				// 返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, result.getRetErrMsg());
			}

		}
		return Boolean.TRUE;
	}

	/**
	 * 我的优惠券，详细
	 *
	 * @param projectNO
	 * @return
	 */

	@RequestMapping(value = "/detailedCoupon", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<String>> detailedCoupon(String projectNO) {

		Response<List<String>> couponInfModel = couPonInfService.detailedCoupon(projectNO);

		return couponInfModel;
	}

}
