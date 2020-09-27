/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-8.
 */

@Controller
@RequestMapping("/api/admin/topGoods") // 请求映射
@Slf4j // 日志
public class TopGoods {

	@Resource
	private BackCategoriesService backCategoriesService;
	@Resource
	private MessageSources messageSources;
	@Resource
	private GoodsService goodsService;
	@Resource
	private ItemService itemService;

	/**
	 * 查询后台类目一级list
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/findBackCategory", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BackCategory> findBackCategory(Long id) {
		Response<List<BackCategory>> result = backCategoriesService.withoutAttribute(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find back category {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 后台类目 ：根据父级id查询子级
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/withoutAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BackCategory> withoutAttribute(Long id) {
		Response<List<BackCategory>> result = backCategoriesService.withoutAttribute(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 根据商品名称,类目模糊查询所有产品
	 *
	 * @param goodsModel
	 * @return
	 */
	@RequestMapping(value = "/name", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ItemDto> findbyGoodsNameLike(GoodsModel goodsModel) {
		Response<List<ItemDto>> result = null;
		result = goodsService.findbyGoodsNameLike(goodsModel);

		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", goodsModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}
	//
	// /**
	// * 查询置顶商品
	// *
	// * @return
	// * @return add by liuhan
	// */
	// @RequestMapping(value = "/stickFlag", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	// @ResponseBody
	// public List<ItemDto> findAllbystickOrder() {
	// Response<List<ItemDto>> result = null;
	// result = itemService.findAllstickFlag();
	// if (result.isSuccess()) {
	// return result.getResult();
	// }
	// log.error("failed to find {},error code:{}", result.getError());
	// throw new ResponseException(500, messageSources.get(result.getError()));
	// }

	/**
	 * 查询置顶商品显示顺序
	 *
	 * @return
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/stickOrder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer findAllstickOrder() {
		Response<Integer> result = itemService.findAllstickOrder();
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 *
	 * 新增置顶
	 * 
	 * @param itemModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(ItemModel itemModel) {
		User user = UserUtil.getUser();
		Response<Boolean> result = new Response<Boolean>();
		itemModel.setModifyOper(user.getName());
		result = itemService.updateadd(itemModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 *
	 * 修改置顶
	 * 
	 * @param itemModel
	 * @return
	 */
	@RequestMapping(value = "/updateEdit", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateEdit(ItemModel itemModel) {
		User user = UserUtil.getUser();
		Response<Boolean> result = new Response<Boolean>();
		itemModel.setModifyOper(user.getName());
		result = itemService.updateEdit(itemModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 *
	 * 删除置顶
	 * 
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateDel(@PathVariable("id") String code) {
		User user = UserUtil.getUser();
		Response<Boolean> result = new Response<Boolean>();
		ItemModel itemModel = new ItemModel();
		itemModel.setModifyOper(user.getName());
		itemModel.setCode(code);
		itemModel.setStickFlag(0);
		itemModel.setStickOrder(0);
		result = itemService.updateDel(itemModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 判断单品是否可以置顶
	 *
	 * @return
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/{goodsCode}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String findGoodsByItemCode(@PathVariable("goodsCode") String code) {
		Response<String> result = goodsService.findGoodsByItemCode(code);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
