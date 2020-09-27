package cn.com.cgbchina.admin.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.spirit.search.Pair;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import cn.com.cgbchina.item.service.GoodsRecommendationService;
import cn.com.cgbchina.item.service.GoodsService;
import lombok.extern.slf4j.Slf4j;

/**
 * 网银商品推荐Controller
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
	@Resource
	private ItemService itemService;


	private final int CHECK_GOODS_RECOMM = 0;	//check通过
	private final int NOT_EXIST_CATEGORY = 1;	//类目下不存在该商品
	private final int EXIST_GOODS_RECOMM = 2;	//该商品已经存在表中
	private final int NOTEXIST_GOODS = 3; // 该商品不存在
	/**
	 * 根据单品编码取得推荐单品的相关信息
	 *
	 * @param goodsMid
	 * @return
	 */
	@RequestMapping(value = "/findItemInfoByItemCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public GoodsDetailDto findItemInfoByItemCode(String goodsMid) {

		Response<GoodsDetailDto> result = goodsService.findGoodsInfoByMid(goodsMid);
		if(result.isSuccess() && null != result.getResult()) {
			return result.getResult();
		}else{
			log.error("failed to find {},error code:{}", goodsMid, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	/**
	 * 添加网银商品推荐
	 *
	 * @param tblGoodsRecommendationYgModel
	 * @return
	 */
	@RequestMapping(value = "/insertGoodsRecommendation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> insertGoodsRecommendation(TblGoodsRecommendationYgModel tblGoodsRecommendationYgModel) {
		User user = UserUtil.getUser();

		Response<Integer> response = goodsRecommendationService.findGoodsSeqMax();
		if (response.isSuccess()) {
			Integer goodsSeqMax = 0;
			if(null == response.getResult())
				goodsSeqMax = 0;
			else
				goodsSeqMax = response.getResult() + 1;

			tblGoodsRecommendationYgModel.setCreateOper(user.getId());
			tblGoodsRecommendationYgModel.setCreateDate(DateHelper.getyyyyMMdd());
			tblGoodsRecommendationYgModel.setCreateTime(DateHelper.getHHmmss());
			tblGoodsRecommendationYgModel.setModifyOper(user.getId());
			tblGoodsRecommendationYgModel.setGoodsSeq(goodsSeqMax);
			tblGoodsRecommendationYgModel.setDelFlag(Contants.DEL_FLAG_0);

			Response<Integer> result = goodsRecommendationService.insertGoodsRecommendation(tblGoodsRecommendationYgModel);
			if (result.isSuccess()) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("successFlag", result);
				map.put("goodsSeqMax",goodsSeqMax);
				return map;
			}
			log.error("failed to find {},error code:{}", tblGoodsRecommendationYgModel, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		log.error("failed to find {},error code:{}", tblGoodsRecommendationYgModel, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 根据商品名称,类目模糊查询所有产品
	 *
	 * @param backgoryId
	 * @return
	 */
	@RequestMapping(value = "/recommendation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Map<String,Object>> findGoodsRecommendation(@RequestParam("backgoryId")String backgoryId) {
		Response<List<TblGoodsRecommendationYgModel>> commendation = new Response<List<TblGoodsRecommendationYgModel>>();

//		Response<List<ItemDto>> result = goodsService.findbyGoodsNameLike(backgoryId, "");
		Response<List<Map<String,Object>>> result = goodsRecommendationService.findGoodsRecommendation(backgoryId);
		if(result.isSuccess()){
			return result.getResult();
		}
//		if(!result.isSuccess()){
//			log.error("Response.error,error code: {}", result.getError());
//			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
//		}
//		if (result.getResult().size() <= 0) {
//			return commendation.getResult();
//		} else {
//			List<String> stringList = new ArrayList<String>();
//			for (int i = 0; i < result.getResult().size(); i++) {
//				String code = result.getResult().get(i).getItemModel().getCode();
//				stringList.add(code);
//			}
//
//			commendation = goodsRecommendationService.findGoodsRecommendation(stringList);
//
//			if (commendation.isSuccess()) {
//				return commendation.getResult();
//			}
//		}

		log.error("failed to find {},error code:{}", backgoryId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 根据商品名称,类目模糊查询所有产品
	 *
	 * @param mid
	 * @param itemCode
	 * @param backgoryId
	 * @return
	 */

	@RequestMapping(value = "/checkgoodscode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkGoodCode(String mid,String itemCode,Long backgoryId) {
		//校验该商品是否存在
		Response<ItemModel> itemR = itemService.findByMid(mid);
		if(!itemR.isSuccess()){
			log.error("fail.to.find.item.model,code{},cause.by{}",itemCode,itemR.getError());
			throw new ResponseException(500, messageSources.get(itemR.getError()));
		}
		if(itemR.getResult()==null){
			return Boolean.FALSE;
		}
		//校验该商品是否已经增加
		Response<Integer> exsitR = goodsRecommendationService.findCountById(mid);
		if(!exsitR.isSuccess()){
			log.error("fail.to.find.this.recommend.goods.exsit.error,code{},cause.by{}",itemCode,itemR.getError());
			throw new ResponseException(500, messageSources.get(itemR.getError()));
		}
		if(exsitR.getResult()>0){
			throw new ResponseException(500, messageSources.get("this.recommend.goods.has.exsit"));
		}

		String goodsCode=itemR.getResult().getGoodsCode();
		//校验该商品是否在此类目下
		Response<List<Pair>> cateR = goodsService.findCategoryByGoodsCode(goodsCode);
		if(!cateR.isSuccess() || cateR.getResult().size()==0){
			log.error("fail.to.find.goods.category,code{},itemcode{},cause.by{}",goodsCode,itemCode,cateR.getError());
			throw new ResponseException(500, messageSources.get(itemR.getError()));
		}
		List<Long> cateIds = Lists.transform(cateR.getResult(), new Function<Pair, Long>() {
			@Nullable
			@Override
			public Long apply(@Nullable Pair pair) {
				return pair.getId();
			}
		});
		if(!cateIds.contains(backgoryId)){
			throw new ResponseException(500, messageSources.get("this.goods.not.in.this.category"));
		}
		return Boolean.TRUE;
	}



	/**
	 * 删除网银商品推荐
	 *
	 * @param goodsId
	 * @return
	 */
	@RequestMapping(value = "/delete/{goodsId}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
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
