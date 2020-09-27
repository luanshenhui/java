/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-8.
 */

@Controller
@RequestMapping("/api/admin/topGoods")
@Slf4j
public class TopGoods {

	@Resource
	private MessageSources messageSources;
	@Resource
	private GoodsService goodsService;
	@Resource
	private ItemService itemService;

	/**
	 * 根据商品名称,类目模糊查询所有产品
	 *
	 * @param category3Id
	 * @param keyword
	 * @return
	 */
	@RequestMapping(value = "/findGoods/{category3Id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ItemDto> findGoodByNameAndCategoryId(@PathVariable("category3Id") String category3Id,
			@RequestParam("keyword") String keyword) {
		Map<String,Object> queryParams = Maps.newHashMap();
		queryParams.put("stickFlag", 0);
		if (keyword != null && !keyword.isEmpty()){
			queryParams.put("name", keyword);
		}
		Response<List<ItemDto>> result = goodsService.findbyGoodsNameLike(category3Id,
				queryParams);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", keyword, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 置顶 信息更新
	 *
	 * @param itemCode 更新 code
	 * @return Boolean
	 */
	@RequestMapping(value = "/updateStickOrder/{code}/{operate}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateStickOrder(@PathVariable("code") String itemCode,
									@PathVariable("operate") String operate,
									@RequestParam("stickOrder") Integer stickOrder) {
		User user = UserUtil.getUser();
		if (Strings.isNullOrEmpty(itemCode)) {
			throw new ResponseException(500, "itemCode.is.null");
		}
		Response<Boolean> response = itemService.updateStickOrder(itemCode,stickOrder,operate, user);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to find ,error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 查询置顶商品显示顺序
	 *
	 * @return add by liuhan
	 */
	// @RequestMapping(value = "/stickOrder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	// @ResponseBody
	// public Integer findAllstickOrder() {
	// Response<Integer> result = itemService.findAllstickOrder();
	// if (result.isSuccess()) {
	// return result.getResult();
	// }
	// log.error("failed to find {},error code:{}", result.getError());
	// throw new ResponseException(500, messageSources.get(result.getError()));
	// }
	/**
	 * 修改置顶
	 *
	 * @param itemModel
	 * @return
	 */
//	@RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public Boolean updateEdit(ItemModel itemModel) {
//		User user = UserUtil.getUser();
//		Response<Boolean> result = new Response<Boolean>();
//		itemModel.setModifyOper(user.getName());
//		result = itemService.updateEdit(itemModel);
//		if (result.isSuccess()) {
//			return result.getResult();
//		}
//		log.error("failed to find {},error code:{}", result.getError());
//		throw new ResponseException(500, messageSources.get(result.getError()));
//	}

	/**
	 * 删除置顶
	 *
	 * @param code
	 * @return
	 */
//	@RequestMapping(value = "/delete/{code}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public Boolean updateDel(@PathVariable("code") String code) {
//		User user = UserUtil.getUser();
//
//		ItemModel itemModel = new ItemModel();
//		itemModel.setCode(code);
//		itemModel.setStickFlag(0); // 置回未置顶
//		itemModel.setStickOrder(999999999);//999999999 --> DB默认值
//		itemModel.setModifyOper(user.getName());
//
//		Response<Boolean> result = itemService.updateDel(itemModel);
//		if (result.isSuccess()) {
//			return result.getResult();
//		}
//		log.error("failed to find {},error code:{}", result.getError());
//		throw new ResponseException(500, messageSources.get(result.getError()));
//	}

	/**
	 * 判断单品是否可以置顶
	 *
	 * @return add by liuhan
	 */
	// @RequestMapping(value = "addGoodsCheck/{goodsCode}", method = RequestMethod.POST, produces =
	// MediaType.APPLICATION_JSON_VALUE)
	// @ResponseBody
	// public String findGoodsByItemCode(@PathVariable("goodsCode") String code) {
	// Response<String> result = goodsService.findGoodsByItemCode(code);
	// if (result.isSuccess()) {
	// return result.getResult();
	// }
	// log.error("failed to find {},error code:{}", result.getError());
	// throw new ResponseException(500, messageSources.get(result.getError()));
	// }

}
