package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import cn.com.cgbchina.item.service.GoodsRecommendationService;
import cn.com.cgbchina.item.service.GoodsService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by 王译宣 on 2016/6/13.
 */
@Controller
@RequestMapping("/api/admin/recommendation")
@Slf4j
public class GoodsRecommendation {
	@Resource
	private MessageSources messageSources;
	@Resource
	private GoodsService goodsService;
	@Resource
	private GoodsRecommendationService goodsRecommendationService;

	/**
	 * 根据单品编码取得推荐单品的相关信息
	 *
	 * @param itemCode
	 * @return
	 */
	@RequestMapping(value = "/findItemInfoByItemCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public RecommendGoodsDto findItemInfoByItemCode(String itemCode) {

		RecommendGoodsDto result = goodsService.findItemInfoByItemCode(itemCode).getResult();

		return result;
	}

	/**
	 * 添加网银商品推荐
	 *
	 * @param tblGoodsRecommendationYgModel
	 * @return
	 */
	@RequestMapping(value = "/insertGoodsRecommendation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> insertGoodsRecommendation(TblGoodsRecommendationYgModel tblGoodsRecommendationYgModel) {
		User user = new User();

		Response<Integer> count = goodsRecommendationService.findGoodsCommendationCount();

		tblGoodsRecommendationYgModel.setCreateOper(user.getName());
		tblGoodsRecommendationYgModel.setModifyOper(user.getName());
		tblGoodsRecommendationYgModel.setGoodsSeq(count.getResult() + 1);

		Response<Integer> result = goodsRecommendationService.insertGoodsRecommendation(tblGoodsRecommendationYgModel);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to find {},error code:{}", tblGoodsRecommendationYgModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据商品名称,类目模糊查询所有产品
	 *
	 * @param goodsModel
	 * @return
	 */
	@RequestMapping(value = "/recommendation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<TblGoodsRecommendationYgModel> findGoodsRecommendation(GoodsModel goodsModel) {
		Response<List<TblGoodsRecommendationYgModel>> commendation = new Response<List<TblGoodsRecommendationYgModel>>();

		Response<List<ItemDto>> result = goodsService.findbyGoodsNameLike(goodsModel);
		if (result.getResult().size() <= 0) {
			return commendation.getResult();
		} else {
			List<String> stringList = new ArrayList<String>();
			for (int i = 0; i < result.getResult().size(); i++) {
				String code = result.getResult().get(i).getItemModel().getCode();
				stringList.add(code);
			}

			commendation = goodsRecommendationService.findGoodsRecommendation(stringList);

			if (commendation.isSuccess()) {
				return commendation.getResult();
			}
		}

		log.error("failed to find {},error code:{}", goodsModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 根据商品名称,类目模糊查询所有产品
	 *
	 * @param goodsModel
	 * @return
	 */
	@RequestMapping(value = "/checkgoodscode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> checkGoodsCode(GoodsModel goodsModel) {
		Response<Integer> flag = new Response<Integer>();

		Response<Integer> count = goodsRecommendationService.findCountById(goodsModel.getCode());
		if (count.getResult() > 0) {
			flag.setResult(Contants.PROMOTION_PROM_TYPE_3);
		} else {
			Response<List<ItemDto>> result = goodsService.findbyGoodsNameLike(goodsModel);

			for (ItemDto itemDto : result.getResult()) {
				if (itemDto.getItemModel().getCode().equals(goodsModel.getCode())) {
					flag.setResult(Contants.PROMOTION_PROM_TYPE_1);
					return flag;
				} else {
					flag.setResult(Contants.PROMOTION_PROM_TYPE_2);
				}
			}

		}
		return flag;
	}

	/**
	 * 删除网银商品推荐
	 *
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value = "/{goodsId}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> deleteGoodsRe(@PathVariable("goodsId") String goodsId) {
		Response<Integer> response = new Response<Integer>();
		if (goodsId == null) {
			response.setError("delete.id.notNull");
			return response;
		}
		Response<Integer> result = goodsRecommendationService.deleteGoodsRe(goodsId);
		if (result.isSuccess()) {
			response.setResult(result.getResult());
			return response;
		}
		log.error("failed to create {},error code:{}", goodsId, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 交换顺序
	 *
	 * @param currentId
	 * @param changeId
	 * @return
	 */
	@RequestMapping(value = "/changeSort", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean changeSort(String currentId, String currentDelFlag, String changeId, String changeDelFlag) {

		Response<Boolean> result = goodsRecommendationService.changeSord(currentId, currentDelFlag, changeId,
				changeDelFlag);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to change sort currentId is {},changeId is {},error code:{}", currentId, changeId,
				result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
