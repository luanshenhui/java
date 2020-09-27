package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsConsultService;
import cn.com.cgbchina.item.service.GoodsService;
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

	/**
	 * 添加咨询
	 * 
	 * @param goodsCode
	 * @param consultContext
	 * @return
	 */
	@RequestMapping(value = "/setGoodsConsult", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response insertGoodsConsult(String goodsCode, String consultContext) {
		// 获取用户
		User user = UserUtil.getUser();
		GoodsConsultModel goodsConsultModel = new GoodsConsultModel();
		goodsConsultModel.setMemberId(Long.parseLong(user.getId()));
		goodsConsultModel.setCreateOper(user.getName());
		goodsConsultModel.setGoodsCode(goodsCode);
		goodsConsultModel.setAdviceContent(consultContext);

		GoodsModel goodsModel = new GoodsModel();
		goodsModel = goodsService.findById(goodsCode).getResult();
		Long backCategory1Id = goodsModel.getBackCategory1Id();
		goodsConsultModel.setBackCategory1Id(backCategory1Id);
		Long backCategory2Id = goodsModel.getBackCategory2Id();
		goodsConsultModel.setBackCategory2Id(backCategory2Id);
		Long backCategory3Id = goodsModel.getBackCategory3Id();
		goodsConsultModel.setBackCategory3Id(backCategory3Id);
		Long goodsBrandId = goodsModel.getGoodsBrandId();
		goodsConsultModel.setGoodsBrandId(goodsBrandId);
		String ordertypeId = goodsModel.getOrdertypeId();
		goodsConsultModel.setOrdertypeId(ordertypeId);
		String vendorId = goodsModel.getVendorId();
		goodsConsultModel.setVendorId(vendorId);

		// 调用接口
		Response<Boolean> result = goodsConsultService.insertGoodsConsult(goodsConsultModel);

		if (result.isSuccess()) {
			return result;
		}

		log.error("insert.error, {},error code:{}", goodsConsultModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}
}
