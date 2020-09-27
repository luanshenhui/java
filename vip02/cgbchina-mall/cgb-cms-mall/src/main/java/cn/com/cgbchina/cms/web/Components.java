package cn.com.cgbchina.cms.web;

import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.core.enums.ComponentCategory;
import com.spirit.core.exception.Server500Exception;
import com.spirit.core.handlebars.HandlebarsEngine;
import com.spirit.core.model.ComponentModel;
import com.spirit.core.render.RenderConstants;
import com.spirit.core.service.ComponentService;
import com.spirit.exception.ResponseException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * 
 * @author changji.zhang
 * 
 */
@Controller
@RequestMapping("/api/design/components")
public class Components {

	@Autowired
	private HandlebarsEngine handlebarEngine;
	@Autowired
	private ComponentService componentService;

	@RequestMapping(value = "render", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String render(@RequestParam("template") String template, @RequestParam(required = false) String gdata,
			@RequestParam Map<String, Object> context) {
		context.remove("template");
		context.put(RenderConstants.DESIGN_MODE, true);
		if (!Strings.isNullOrEmpty(gdata)) {
			context.remove("gdata");
			context.put(RenderConstants.DESIGN_GDATA, gdata);
		}
		String html = handlebarEngine.execInline(template, context);
		if (StringUtils.isBlank(html)) {
			throw new ResponseException(404, "组件未找到或者渲染出错");
		}
		return html;
	}

	@RequestMapping(value = "/categories", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> listCategory(@RequestParam("mode") String modeName) {
		modeName = modeName.toUpperCase();
		ComponentCategory.Mode mode = ComponentCategory.Mode.valueOf(modeName);
		Map<String, Object> categoryMap = Maps.newHashMap();
		for (ComponentCategory category : ComponentCategory.listByMode(mode)) {
			categoryMap.put(category.name(), category.getName());
		}
		return categoryMap;
	}

	@RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ComponentModel> list(@RequestParam("category") String categoryName) {
		categoryName = categoryName.toUpperCase();
		ComponentCategory category = ComponentCategory.valueOf(categoryName);
		if (category == null) {
			throw new ResponseException(400, "category not found");
		}
		if (category.getSuitableModes() == null) {
			throw new ResponseException(400, "category isnt designable");
		}
		Response<List<ComponentModel>> componentsR = componentService.findByCategory(category.name());
		Server500Exception.failToThrow(componentsR);
		return componentsR.getResult();
	}
}
