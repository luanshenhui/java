package cn.com.cgbchina.admin.controller;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.item.dto.SearchItemDto;
import cn.com.cgbchina.item.dto.itemSearchDto;
import cn.com.cgbchina.item.service.ItemIndexService;
import cn.com.cgbchina.item.service.ItemSearchService;

/**
 * Created by liuchang on 16-5-24.
 */

@Controller
@RequestMapping("/api/admin/SearchIndexTest")
public class SearchIndexTest {
	@Resource
	ItemIndexService itemIndexService;

	/**
	 * 搜索
	 *
	 * @return 搜索结果
	 */
	@RequestMapping(value = "/fullItemIndex", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody

	public void fullItemIndex() {
		itemIndexService.fullItemIndex();
	}

}
