package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.item.dto.ItemSearchResultDto;
import cn.com.cgbchina.item.dto.SearchItemDto;
import cn.com.cgbchina.item.dto.itemSearchDto;
import cn.com.cgbchina.item.service.ItemIndexService;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.cgbchina.item.service.ItemSearchService;

import java.util.List;

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
	ItemSearchService itemSearchService;
	@Resource
	ItemIndexService itemIndexService;
	@Resource
	UserFavoriteService userFavoriteService;

	/**
	 * 搜索
	 *
	 * @return 搜索结果
	 */
	@RequestMapping(value = "/searchItem", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody

	public itemSearchDto searchItem(@RequestBody SearchItemDto searchItemDto) {
		Response<itemSearchDto> result = itemSearchService.searchItem(searchItemDto.getBusinessType(),
				searchItemDto.getChannelType(), searchItemDto.getKeywords(), searchItemDto.getSortField(),
				searchItemDto.getSortDir(), Integer.parseInt(searchItemDto.getStartPage()),
				Integer.parseInt(searchItemDto.getPageSize()), searchItemDto.getFilterParams());
		if (result.isSuccess()) {
			itemSearchDto searchDto = result.getResult();
			if (UserUtil.getUser() != null
					&& searchDto.getItemSearchResultList() != null) {
				List<ItemSearchResultDto> list = searchDto.getItemSearchResultList();
				for (ItemSearchResultDto dto : list) {
					Response<String> response = userFavoriteService.checkFavorite(dto.getItemCode(), UserUtil.getUserId());
					if (response.isSuccess()) {
						// 1:收藏 0:未收藏
						dto.setFavoriteType(response.getResult());
					}
				}
			}
			return searchDto;
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
