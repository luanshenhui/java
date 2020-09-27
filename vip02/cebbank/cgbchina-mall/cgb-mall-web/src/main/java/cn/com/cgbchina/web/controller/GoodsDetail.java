package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.item.dto.BirthdayTipDto;
import cn.com.cgbchina.item.dto.CardScaleDto;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.rest.visit.model.user.LoginResult;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.google.common.base.Throwables;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created by Cong on 2016/5/27.
 */
@Controller
@RequestMapping("/api/goodsDetail")
@Slf4j
public class GoodsDetail {

	@Autowired
	private GoodsDetailService goodsDetailService;
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private ACardCustToelectronbankService aCardCustToelectronbankService;
	@Autowired
	private UserFavoriteService userFavoriteService;

	/**
	 * 获取商品咨询信息
	 * 
	 * @param goodsCode
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@RequestMapping(value = "/getGoodsConsult", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Pager<GoodsConsultModel>> getGoodsConsultPager(String goodsCode, Integer pageNo, Integer size) {
		Response<Pager<GoodsConsultModel>> result = new Response<Pager<GoodsConsultModel>>();
		try {
			Pager<GoodsConsultModel> goodsConsultModelPager = new Pager<GoodsConsultModel>();
			User user = UserUtil.getUser();
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("goodsCode", goodsCode);
			goodsConsultModelPager = goodsDetailService.getGoodsConsultList(goodsCode, pageNo, size);
			result.setResult(goodsConsultModelPager);
			return result;
		} catch (Exception e) {
			log.error("GoodsDetailService.findGoodsDescribe.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("GoodsDetailService.findGoodsDescribe.fail");
			return result;
		}
	}

	/**
	 * 获取库存信息
	 * @param itemCode
	 * @return
	 */
	@RequestMapping(value = "/getItemStock", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> getItemStock(String itemCode) {
		Response<String> result = new Response<String>();
		if(itemCode == null){
			result.setError("itemCode.can.not.be.empty");
			return result;
		}
		try {
			Response<String> results = goodsDetailService.getItemStock(itemCode);
			String stock = results.getResult();
			result.setResult(stock);
			return result;
		} catch (Exception e) {
			result.setError("goodsDetail.getItemStock.fail");
			return result;
		}
	}

	/**
	 * 获取用户生日折扣信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getUserBirth", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<BirthdayTipDto> getUserBirth(HttpServletRequest request, HttpServletResponse response) {
		Response<BirthdayTipDto> result = new Response<BirthdayTipDto>();
		try {
			User user = UserUtil.getUser();
			Object obj = request.getSession().getAttribute(user.getCustId());
			LoginResult loginResult = new LoginResult();
			if (obj != null) {
				Map<String, Object> objResult = (Map<String, Object>) obj;
				// 存LoginResult信息
				loginResult.setCertNo(objResult.get((Object) "certNo").toString());
			}
			Response<BirthdayTipDto> results = goodsDetailService.getUserBirth(loginResult.getCertNo());
			BirthdayTipDto dto = results.getResult();
			result.setResult(dto);
			return result;
		} catch (Exception e) {
			result.setError("goodsDetailService.getUserBirth.fail");
			return result;
		}
	}

	/**
	 * 校验用户的积分类型和第三级卡是否符合要求
	 * TODO：开发中
	 */
	@RequestMapping(value = "/checkThreeCard", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> checkThreeCard(String goodsCode) {
		Response<Boolean> result = new Response<Boolean>();
		if(goodsCode == null){
			result.setError("GoodsDetailService.findGoodsDescribe.fail");
			return result;
		}
		result = goodsDetailService.checkThreeCard(goodsCode, UserUtil.getUser());
		return result;
	}

	@RequestMapping(value = "/cardScale", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<CardScaleDto>> findCardScale() {
		Response<List<CardScaleDto>> result = new Response<List<CardScaleDto>>();
		User user = UserUtil.getUser();
		Response<List<CardScaleDto>> response = goodsDetailService.findCardScaleByUserId(user);
		if(response.isSuccess()) {
			return response;
		}
		result.setResult(Collections.<CardScaleDto>emptyList());
		return result;
	}

	@RequestMapping(value = "/checkFavorite", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> checkFavorite(@Param("itemCode") String itemCode){
		User user = UserUtil.getUser();
		Response<String> response = new Response<String>();
		if(user!=null){
			response = userFavoriteService.checkFavorite(itemCode,user.getCustId());
			if(response.isSuccess()){
				return response;
			}
		}
		response.setResult("0");
		return response;
	}
}
