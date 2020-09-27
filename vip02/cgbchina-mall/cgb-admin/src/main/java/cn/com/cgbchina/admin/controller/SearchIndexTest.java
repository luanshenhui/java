package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.service.ItemIndexService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

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
