package cn.com.cgbchina.admin.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProject;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 16-3-28.
 */
@Controller
@RequestMapping("/api/admin/coupon")
@Slf4j
public class Coupons {
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private CouPonInfService couPonInfService;
	@Autowired
	private CouponService couponService;

	/**
	 * 获取外部接口的优惠券信息
	 * 
	 * @return
	 */

	@RequestMapping(value = "/findAllCoupin", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<CouponProject> findAllCoupin() {
		User user = UserUtil.getUser();
		List<CouponProject> couponProjects = new ArrayList<>();
		// 先查出有几页数据 然后根据数据页数进行循环查询
		CouponProjectPage page = new CouponProjectPage();
		page.setCurrentPage("1");// 请求页数
		page.setChannel(Contants.CHANNEL_BC);// 商城
		page.setRowsPage("10");// 10条数据
		QueryCouponProjectResult res = couponService.queryCouponProject(page);
		for (int i = 1; i <= Integer.parseInt(res.getTotalCount()); i++) {
			page.setCurrentPage(String.valueOf(i));// 请求页数
			QueryCouponProjectResult result = couponService.queryCouponProject(page);
			if (result == null) {
				break;
			} else {
				couponProjects.addAll(result.getCouponProjects());
			}
		}
		// 循环请求所有数据后 添加到本地数据库
		for (CouponProject couponProject : couponProjects) {
			Response<CouponInfModel> couponId = couPonInfService.findByCouponId(couponProject.getProjectNO());
			if (!couponId.isSuccess()) {
				CouponInfModel couponInfModel = new CouponInfModel();
				couponInfModel.setCouponId(couponProject.getProjectNO());
				couponInfModel.setCouponNm(couponProject.getProjectName());
				couponInfModel.setCreateOper(user.getName());
				couponInfModel.setModifyOper(user.getName());
				couPonInfService.create(couponInfModel);
			}

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
		if (!"".equals(startTimes) && !"".equals(endTimes)) {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			try {
				Date startdate = dateFormat.parse(startTimes);
				Date enddate = dateFormat.parse(endTimes);
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
