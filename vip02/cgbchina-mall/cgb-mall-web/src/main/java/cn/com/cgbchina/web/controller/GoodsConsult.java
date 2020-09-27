package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import com.google.common.html.HtmlEscapers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsConsultService;
import cn.com.cgbchina.item.service.GoodsService;
import lombok.extern.slf4j.Slf4j;

/**
 * 咨询
 */
@Controller
@RequestMapping("/api/goodsConsult")
@Slf4j
public class GoodsConsult {

	@Autowired
	private GoodsConsultService goodsConsultService;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private BadWordCheck badWordCheck;

	/**
	 * 添加咨询
	 * 
	 * @param goodsCode
	 * @param consultContext
	 * @return
	 */
	@RequestMapping(value = "/addGoodsConsult", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response insertGoodsConsult(String goodsCode, String consultContext) {
		Response<String> response = new Response<String>();
		// 脏词过滤
		consultContext = HtmlEscapers.htmlEscaper().escape(badWordCheck.check(consultContext));
		// 获取用户
		User user = UserUtil.getUser();
		if (user == null) {
			response.setResult("99");
			return response;
		}
		try {
			GoodsConsultModel goodsConsultModel = new GoodsConsultModel();
			goodsConsultModel.setMemberId(Long.parseLong(user.getId()));
			goodsConsultModel.setCreateOper(user.getName());
			goodsConsultModel.setGoodsCode(goodsCode);
			goodsConsultModel.setAdviceContent(consultContext);
			GoodsModel goodsModel;
			Response<GoodsModel> resultGoods = goodsService.findById(goodsCode);
			if(!resultGoods.isSuccess()){
				log.error("Response.error,error code: {}", resultGoods.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(resultGoods.getError()));
			}
			goodsModel = resultGoods.getResult();
			goodsConsultModel.setGoodsBrandId(goodsModel.getGoodsBrandId());
			goodsConsultModel.setOrdertypeId(goodsModel.getOrdertypeId());
			goodsConsultModel.setVendorId(goodsModel.getVendorId());

			// 调用接口
			Response<Boolean> result = goodsConsultService.insertGoodsConsult(goodsConsultModel);

			if (result.isSuccess()) {
				response.setResult("1");
				return response;
			} else {
				response.setResult("98");
				throw new ResponseException(500, messageSources.get(result.getError()));
			}
		} catch (Exception e) {
			response.setResult("98");
			return response;
		}
	}
}
