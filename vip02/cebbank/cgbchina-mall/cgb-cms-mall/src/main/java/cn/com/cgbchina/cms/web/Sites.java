package cn.com.cgbchina.cms.web;

import com.spirit.common.model.Response;
import com.spirit.core.model.Site;
import com.spirit.core.service.SiteService;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;

/**
 * 站点装修
 * 
 * @author changji.zhang
 * 
 */
@Slf4j
@Controller
@RequestMapping("/api/design/sites")
public class Sites {

	@Resource
	private SiteService siteService;
	@Resource
	private MessageSources messageSources;

	@RequestMapping("release")
	public String release(@RequestParam(value = "templateId") Long templateId) {
		User user = UserUtil.getUser();
		String userId = user.getId();
		Response<Site> siteR = siteService.findShopByUserId(userId);
		if (!siteR.isSuccess()) {
			log.warn("site not found when release, userId={},error code:{}", userId, siteR.getError());
			throw new ResponseException(500, messageSources.get(siteR.getError()));
		}
		Site site = siteR.getResult();
		Response<Long> releaseR = null;//siteService.useAndRelease(site.getId(), templateId);
		if (!releaseR.isSuccess()) {
			log.error("failed to for user(id={}) to use and release template(id={}),error code:{}", userId, templateId,
					releaseR.getError());
			throw new ResponseException(500, messageSources.get(releaseR.getError()));
		}
		return "ok";
	}

	@RequestMapping("reset")
	public void reset(@RequestParam(value = "templateId") Long templateId) {
		User user = UserUtil.getUser();
		String userId = user.getId();
		Response<Site> rSite = null;// siteService.findShopByUserId(userId);
		if (!rSite.isSuccess()) {
			log.warn("site not found when release, userId={},error code:{}", userId, rSite.getError());
			throw new ResponseException(500, messageSources.get(rSite.getError()));
		}
		Site site = rSite.getResult();
		Response<Boolean> resetR = siteService.resetTemplate(site.getId(), templateId);
		if (!resetR.isSuccess()) {
			log.error("failed to for user(id={}) to reset template(id={}),error code:{}", userId, templateId,
					resetR.getError());
			throw new ResponseException(500, messageSources.get(resetR.getError()));
		}
	}

}
