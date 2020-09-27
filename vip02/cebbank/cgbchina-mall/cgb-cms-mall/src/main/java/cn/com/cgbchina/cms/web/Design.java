package cn.com.cgbchina.cms.web;

import cn.com.cgbchina.web.common.ViewRender;
import com.google.common.base.MoreObjects;
import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.core.enums.SiteCategory;
import com.spirit.core.exception.Server500Exception;
import com.spirit.core.model.Page;
import com.spirit.core.model.Site;
import com.spirit.core.model.TemplateInstance;
import com.spirit.core.model.TemplatePage;
import com.spirit.core.render.RenderConstants;
import com.spirit.core.service.PageService;
import com.spirit.core.service.SiteInstanceService;
import com.spirit.core.service.SiteService;
import com.spirit.exception.NotFound404Exception;
import com.spirit.exception.ResponseException;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Created by changji.zhang on 15-12-25.
 */
@Slf4j
@Controller
@RequestMapping("/design")
public class Design {

	@Autowired
	private ViewRender viewRender;
	@Autowired
	private SiteService siteService;
	@Autowired
	private SiteInstanceService siteInstanceService;
	@Autowired
	private PageService pageService;
	@Autowired
	private CommonConstants commonConstants;

	@Value("#{app.editorLayout}")
	private String editorLayout;
	@Value("#{app.decorationLayout}")
	private String decorationLayout;

	@RequestMapping(method = RequestMethod.GET)
	public String design() {
		return "views/" + editorLayout;
	}

	@RequestMapping(value = "templates/{siteId}")
	public String designTemplate(@PathVariable("siteId") Long siteId, Map<String, Object> context) {
		Map<String, Object> editorContext = Maps.newHashMap();
		Response<Site> sr = siteService.findById(siteId);
		Server500Exception.failToThrow(sr);
		Site site = sr.getResult();
		if (site == null) {
			log.error("can not find site when edit template, siteId: {}", siteId);
			throw new NotFound404Exception("未找到对应的站点");
		}
		// User user = UserUtil.getUser();
		// User.TYPE currentUserType = UserUtil.getUser().getEnumType();
		// if (site.getCategory() == SiteCategory.OFFICIAL) { // 子站只有管理员和运营可以编辑
		// if (currentUserType != User.TYPE.ADMIN
		// && currentUserType != User.TYPE.SITE_OWNER) {
		// log.error("only admin and site_owner can design sub site, currentUser: {}",
		// UserUtil.getUser().getId());
		// throw new UnAuthorize401Exception("管理员和运营才能编辑子站");
		// }
		// }
		// if (site.getCategory() == SiteCategory.TEMPLATE) { // 模板只有管理员可以编辑
		// if (currentUserType != User.TYPE.ADMIN) {
		// log.error("only admin can design sub template, currentUser: {}",
		// UserUtil.getUser().getId());
		// throw new UnAuthorize401Exception("管理员才能编辑模板");
		// }
		// }
		editorContext.put("site", site);
		editorContext.put("mode", site.getCategory());
		Response<TemplateInstance> tir = siteInstanceService.findTemplateInstanceById(site.getDesignInstanceId());
		Server500Exception.failToThrow(tir);
		TemplateInstance templateInstance = tir.getResult();
		if (templateInstance == null) {
			log.error("can not find site instance when edit template, instanceId: {}", site.getDesignInstanceId());
			throw new NotFound404Exception("Can't find template instance.");
		}
		// clean unnecessary data
		templateInstance.setHeader(null);
		templateInstance.setFooter(null);
		editorContext.put("instance", templateInstance);
		Response<List<? extends Page>> pr = pageService.findPages(siteId, templateInstance.getId());
		Server500Exception.failToThrow(pr);
		List<? extends Page> pages = pr.getResult();
		if (pages != null && !pages.isEmpty()) {
			Map<String, Page> pageMap = Maps.newHashMap();
			for (Page page : pages) {
				page.setParts(null);
				page.setJsonParts(null);
				if (page instanceof TemplatePage) {
					((TemplatePage) page).setFixed(null);
				}
				pageMap.put(page.getPath(), page);
			}
			editorContext.put("pages", pageMap);
			Page indexPage = pageMap.get(
					Strings.isNullOrEmpty(templateInstance.getIndexPath()) ? "index" : templateInstance.getIndexPath());
			editorContext.put("indexPage", indexPage);
			editorContext.put("currentPage", MoreObjects.firstNonNull(indexPage, pages.get(0)));
		}
		context.put("editorContext", editorContext);
		context.put("title", site.getCategory() == SiteCategory.OFFICIAL ? "子站编辑" : "模板编辑");
		return "views/" + editorLayout;
	}

	@RequestMapping(value = "/pages", method = RequestMethod.GET)
	public void designPage(@RequestHeader("Host") String domain, @RequestParam(required = false) Long instanceId,
						   @RequestParam String path, @RequestParam boolean isSite, HttpServletRequest request,
						   HttpServletResponse response, @RequestParam Map<String, Object> context) {
		context.put(RenderConstants.DESIGN_MODE, true);
		if (instanceId == null) {
			domain = domain.split(":")[0];
			String subDomain = domain.substring(0, domain.length() - commonConstants.getBase().length() - 1);
			Response<Site> siteR = siteService.findBySubdomain(subDomain);
			// Server500Exception.failToThrow(siteR, "find site by subDomain error", subDomain);
			Site site = siteR.getResult();
			if (site == null) {
				throw new NotFound404Exception("site not found for subDomain [" + subDomain + "]");
			}
			viewRender.viewTemplate(site.getReleaseInstanceId(), path, request, response, context);
			return;
		}
		if (isSite) {
			// shop component need sellerId
			context.put("sellerId", UserUtil.getUser().getId());
			viewRender.viewSite(instanceId, path, request, response, true, context);
		} else {
			viewRender.viewTemplate(instanceId, path, request, response, context);
		}
	}
}
