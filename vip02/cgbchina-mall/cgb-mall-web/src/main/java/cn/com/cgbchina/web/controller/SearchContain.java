package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.item.dto.BrowseHistoryInfoDateDto;
import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import cn.com.cgbchina.item.model.GoodsPriceRegionModel;
import cn.com.cgbchina.item.service.BrowseHistoryService;
import cn.com.cgbchina.item.service.ItemSearchService;
import cn.com.cgbchina.related.service.KeywordSearchService;
import com.google.common.collect.Maps;
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

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by liuchang on 16-5-24.
 */

@Controller
@RequestMapping("/api/mall/SearchContain")
@Slf4j
public class SearchContain {
	@Autowired
	private MessageSources messageSources;
	@Resource
	private ItemSearchService itemSearchService;
	@Resource
	private KeywordSearchService keywordSearchService;
	@Resource
	private BrowseHistoryService browseHistoryService;

	/**
	 * 查询商品价格区间数据
	 *
	 * @return 结果
	 */
	@RequestMapping(value = "/findGoodsPriceRegion", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<GoodsPriceRegionModel> findGoodsPriceRegion() {
		Response<List<GoodsPriceRegionModel>> result = itemSearchService.findGoodsPriceRegion();
		if (result.isSuccess()) {
			return result.getResult();
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询商品积分区间数据
	 *
	 * @return 结果
	 */
	@RequestMapping(value = "/findGoodsPointRegion", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody

	public List<GoodsPointRegionModel> findGoodsPointRegion() {
		Response<List<GoodsPointRegionModel>> result = itemSearchService.findGoodsPointRegion();
		if (result.isSuccess()) {
			return result.getResult();
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 将关键字插入数据库
	 *
	 * @param keyWords, businessType, sourceId
	 * @return
	 */
	@RequestMapping(value = "/insertKeyword", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean insertKeyword(String keyWords, String businessType) {
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("keyWords", keyWords);
		paramMap.put("ordertypeId", businessType);
		paramMap.put("sourceId", "00"); // 商城
		User user = UserUtil.getUser();
		if (user != null) {
			paramMap.put("id", user.getName());
		}
		Response<Map<String, Object>> result = keywordSearchService.create(paramMap);
		if (result.isSuccess()) {
			return Boolean.TRUE;
		}
		log.error("failed to insertKeyword{},error code:{}", keyWords, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 搜索页取得我的足迹
	 *
	 * @return
	 */
	@RequestMapping(value = "/getHistoryDownList", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<BrowseHistoryInfoDateDto> getHistoryDownList() {
		Response<Pager<BrowseHistoryInfoDateDto>> result = Response.newResponse();
		User user = UserUtil.getUser();
		if (user != null) {
			result = browseHistoryService.browseHistoryByPager(user, 1, 5);
			if (result.isSuccess()) {
				return result.getResult();
			}
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}


}
