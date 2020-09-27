package cn.com.cgbchina.admin.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProject;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import lombok.extern.slf4j.Slf4j;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

/**
 * Created by 11140721050130 on 16-3-28.
 */
@Controller
@RequestMapping("/api/admin/coupon")
@Slf4j
public class Coupons {
	@Autowired
	private MessageSources messageSources;
	@Resource
	private CouPonInfService couPonInfService;
	@Autowired
	private CouponService couponService;

	private static List<String> getCouponids(List<CouponProject> couponProjects) {
		Predicate<String> predicate = new Predicate<String>() {
			@Override
			public boolean apply(String input) {
				return !input.isEmpty();
			}
		};
		List<String> couponids = Lists.transform(couponProjects, new Function<CouponProject, String>() {
			@Override
			public String apply(@NotNull CouponProject input) {
				return input.getProjectNO();
			}
		});
		Collection<String> result = Collections2.filter(couponids, predicate);
		return Lists.newArrayList(result);

	}
	/**
	 * 获取外部接口的优惠券信息
	 * 
	 * @return
	 */

	@RequestMapping(value = "/findAllCoupon", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<CouponProject> findAllCoupon() {
		User user = UserUtil.getUser();
		List<CouponProject> couponProjects = new ArrayList<>();
		List<CouponInfModel> couponInfModelList = new ArrayList<>();
		// 先查出有几页数据 然后根据数据页数进行循环查询
		CouponProjectPage page = new CouponProjectPage();
		page.setCurrentPage("0");// 请求页数
		page.setChannel(Contants.CHANNEL_BC);// 商城
		page.setRowsPage("10");// 10条数据
		QueryCouponProjectResult res;
		try {
			res = couponService.queryCouponProject(page);
		}catch (Exception e){
			throw new ResponseException(500, messageSources.get("couponInf.find.error"));
		}
		if(!"000000".equals(res.getRetCode())){
			//获取优惠券失败
			throw new ResponseException(500, messageSources.get("couponInf.find.error"));
		}
		// 每页条数
		int totalCount = Integer.parseInt(res.getTotalCount());
		// 总记录数
		int totalPages = Integer.parseInt(res.getTotalPages());
		// 总页数
		int pageCounts = (totalCount + totalPages - 1) / totalCount;
		for (int i = 0; i <= pageCounts-1; i++) {
			page.setCurrentPage(String.valueOf(i));// 请求页数
			QueryCouponProjectResult result;
			try {
				result = couponService.queryCouponProject(page);
			}catch (Exception e){
				throw new ResponseException(500, messageSources.get("couponInf.find.error"));
			}
			if (result == null || !"000000".equals(result.getRetCode())) {
				//获取优惠券失败
				throw new ResponseException(500, messageSources.get("couponInf.find.error"));
			} else {
				couponProjects.addAll(result.getCouponProjects());
			}
		}
		//数据异常的优惠券编号
		List<String> errorProject = Lists.newArrayList();
		if (!couponProjects.isEmpty()){
			for (CouponProject couponProject : couponProjects) {
				CouponInfModel couponInfModel = new CouponInfModel();
				if(couponProject.getProjectNO()==null || couponProject.getProjectNO().isEmpty()){
					errorProject.add("null");
					break;
				}
				if(couponProject.getProjectName()==null || couponProject.getProjectName().isEmpty()){
					errorProject.add(couponProject.getProjectNO());
					break;
				}
				if(couponProject.getBeginDate()==null || couponProject.getEndDate()==null){
					errorProject.add(couponProject.getProjectNO());
					break;
				}
				couponInfModel.setCouponId(couponProject.getProjectNO());
				couponInfModel.setCouponNm(couponProject.getProjectName());
				couponInfModel.setIsManual(0);//默认为否
				couponInfModel.setIsFirstlogin(0);//默认为否
				couponInfModel.setDelFlag(0);//接口返回则存在
				couponInfModel.setCreateOper(user.getId());
				couponInfModel.setModifyOper(user.getId());
				couponInfModel.setBeginDate(couponProject.getBeginDate());//优惠券使用有效开始时间
				couponInfModel.setEndDate(couponProject.getEndDate());//优惠券使用有效结束时间
				couponInfModelList.add(couponInfModel);
			}
		}
		//接口查询出的优惠券id集合
		List<String> couponids = getCouponids(couponProjects);
		List<String> couponInfModelListDb;
		//数据库中已存在且在接口查询出的优惠券集合
		if (couponids!=null && !couponids.isEmpty()){
			Response<List<String>> couponInfosResponse = couPonInfService.findCouponsExist(couponids);
			if (!couponInfosResponse.isSuccess()){
				throw new ResponseException(500, messageSources.get("couponInf.time.query.error"));
			}
			couponInfModelListDb= couponInfosResponse.getResult();
		}else {
			couponInfModelListDb = Lists.newArrayList();
		}
		//删除、新增、更新优惠券
		Response<Boolean> result = couPonInfService.synchronizeCoupon(couponInfModelList,couponInfModelListDb);
		if(!result.isSuccess()){
			log.error("create.update.delete.coupon.error{}",result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		if(errorProject !=null && !errorProject.isEmpty()){
			throw new ResponseException(500, messageSources.get("couponInf.projectNO.error") + errorProject.toString());
		}
		return couponProjects;
	}

	/**
	 * 根据ID查询
	 *
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public CouponInfModel findById(@PathVariable("id") String id) {
		Response<CouponInfModel> result = couPonInfService.findById(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 优惠券设置新增
	 *
	 * @param couponInfModel
	 * @return
	 */
	@RequestMapping(value = "/updateCouponInf", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateCouponInf(CouponInfModel couponInfModel,
			@RequestParam(value = "startTimes", required = true) String startTimes,
			@RequestParam(value = "endTimes", required = true) String endTimes) {
		User user = UserUtil.getUser();
		couponInfModel.setCreateOper(user.getName());
		couponInfModel.setModifyOper(user.getName());
		couponInfModel.setDelFlag(Integer.valueOf(Contants.DEL_FLAG_0));
		if (!"".equals(startTimes) && !"".equals(endTimes)) {
			try {
				Date startdate = DateHelper.string2Date(startTimes,DateHelper.YYYY_MM_DD_HH_MM_SS);
				Date enddate = DateHelper.string2Date(endTimes,DateHelper.YYYY_MM_DD_HH_MM_SS);
				couponInfModel.setStartTime(startdate);
				couponInfModel.setEndTime(enddate);
			} catch (Exception e) {
				log.error("update.error,error code:{}", Throwables.getStackTraceAsString(e));
				throw new ResponseException(Contants.ERROR_CODE_500, "couponInf.update.error");
			}
		}
		Response<Boolean> result = couPonInfService.update(couponInfModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error code:{}", couponInfModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询所有的优惠券
	 *
	 * @return
	 */
	@RequestMapping(value = "/couponInf", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<CouponInfModel> couponInf() {
		Response<List<CouponInfModel>> result = couPonInfService.findAll();
		if (!result.isSuccess()) {
			log.error("find couponInf failed, cause:{}", result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}
}
