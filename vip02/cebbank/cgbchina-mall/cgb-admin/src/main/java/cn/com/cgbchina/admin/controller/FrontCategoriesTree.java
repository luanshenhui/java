package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.model.CategoryNode;
import cn.com.cgbchina.item.model.FrontCategory;
import cn.com.cgbchina.item.service.FrontCategoryTreeService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Created by 郝文佳 on 2016/5/12.
 */
@Controller
@Slf4j
@RequestMapping("/api/admin/frontCategoriesTree")
public class FrontCategoriesTree {
	@Resource
	private FrontCategoryTreeService frontCategoryTreeService;
	@Resource
	private MessageSources messageSources;

	/**
	 * 返回所有前台类目的树级接口 注意跟节点是虚拟节点 跟节点为所有类目 在数据库中不存在
	 *
	 * @return
	 */
	@RequestMapping(value = "/frontCategoryTree", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public CategoryNode<FrontCategory> frontCategoryTree() {

		Response<CategoryNode<FrontCategory>> result = frontCategoryTreeService.buildCategoryTree();

		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to build frontCategory tree,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

}
