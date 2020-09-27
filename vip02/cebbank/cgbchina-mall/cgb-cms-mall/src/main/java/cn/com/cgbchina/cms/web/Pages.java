package cn.com.cgbchina.cms.web;

import com.spirit.common.model.Response;
import com.spirit.core.enums.PageCategory;
import com.spirit.core.enums.SiteCategory;
import com.spirit.core.exception.Server500Exception;
import com.spirit.core.model.*;
import com.spirit.core.service.PageService;
import com.spirit.core.service.SiteInstanceService;
import com.spirit.core.service.SiteService;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 页面装修
 *
 * @author changji.zhang
 */
@Controller
@RequestMapping("/api/design/pages")
public class Pages {

    @Autowired
    private PageService pageService;
    @Autowired
    private SiteService siteService;
    @Autowired
    private SiteInstanceService siteInstanceService;

    @RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Long create(@RequestParam Long instanceId,
                       @RequestParam String name,
                       @RequestParam String path,
                       @RequestParam(required = false) String keywords,
                       @RequestParam(required = false) String description) {
        path = path.toLowerCase();
        TemplateInstance templateInstance = authCheck(instanceId);
        Response<List<? extends Page>> pagesR = pageService.findPages(templateInstance.getSiteId(), templateInstance.getId());
        Server500Exception.failToThrow(pagesR);
        for (Page existedPage : pagesR.getResult()) {
            if (existedPage.getPath().equals(path)) {
                throw new ResponseException(400, "路径已经存在，不能重复");
            }
        }
        TemplatePage page = new TemplatePage();
        page.setInstanceId(instanceId);
        page.setPageCategory(PageCategory.OTHER);
        page.setName(name);
        page.setPath(path);
        page.setKeywords(keywords);
        page.setDescription(description);
        Response<Long> idr = pageService.createSubSitePage(page);
        Server500Exception.failToThrow(idr);
        return idr.getResult();
    }

    @RequestMapping(value = "/set-index", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public void setIndex(@RequestParam Long instanceId, @RequestParam String path) {
        TemplateInstance templateInstance = authCheck(instanceId);
        templateInstance.setIndexPath(path);
        Response<Long> r = siteInstanceService.updateTemplateInstance(templateInstance);
        Server500Exception.failToThrow(r);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public void update(@PathVariable Long id,
                       @RequestParam String name,
                       @RequestParam String path,
                       @RequestParam(required = false) String keywords,
                       @RequestParam(required = false) String description) {
        // always lower case
        path = path.toLowerCase();
        Response<TemplatePage> pr = pageService.findTemplatePageById(id);
        Server500Exception.failToThrow(pr);
        TemplatePage page = pr.getResult();
        TemplateInstance templateInstance = authCheck(page.getInstanceId());
        Response<List<? extends Page>> pagesR = pageService.findPages(templateInstance.getSiteId(), templateInstance.getId());
        Server500Exception.failToThrow(pagesR);
        if (!page.getPath().equals(path)) {
            for (Page existedPage : pagesR.getResult()) {
                if (existedPage.getPath().equals(path)) {
                    throw new ResponseException(400, "路径已经存在，不能重复");
                }
            }
        }
        page.setName(name);
        page.setPath(path);
        page.setKeywords(keywords);
        page.setDescription(description);
        Response<Long> updateR = pageService.updateSubSitePage(page);
        Server500Exception.failToThrow(updateR);
    }

    @RequestMapping(value = "/shop/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public void updateSitePage(@PathVariable Long id,
                               @RequestParam(required = false) String keywords,
                               @RequestParam(required = false) String description) {
        Response<Page> pr = pageService.findPageById(id);
        Server500Exception.failToThrow(pr);
        Page page = pr.getResult();
        Response<SiteInstance> sir = siteInstanceService.findSiteInstanceById(page.getInstanceId());
        Server500Exception.failToThrow(sir);
        Response<Site> sr = siteService.findById(sir.getResult().getSiteId());
        Server500Exception.failToThrow(sr);
        if (!sr.getResult().getUserId().equals(UserUtil.getUserId())) {
            throw new ResponseException(403, "site isnt belong to u");
        }
        page.setKeywords(keywords);
        page.setDescription(description);
        Response<Long> updateR = pageService.updatePage(page);
        Server500Exception.failToThrow(updateR);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public void delete(@PathVariable Long id) {
        Response<TemplatePage> pr = pageService.findTemplatePageById(id);
        Server500Exception.failToThrow(pr);
        TemplatePage page = pr.getResult();
        if (page == null) {
            throw new ResponseException(400, "page not found");
        }
        authCheck(page.getInstanceId());

        Response<Boolean> deleteR = pageService.deleteSubSitePage(id);
        Server500Exception.failToThrow(deleteR);
    }

    private TemplateInstance authCheck(Long instanceId) {
        Response<TemplateInstance> sir = siteInstanceService.findTemplateInstanceById(instanceId);
        Server500Exception.failToThrow(sir);
        Response<Site> sr = siteService.findById(sir.getResult().getSiteId());
        Server500Exception.failToThrow(sr);
        Site site = sr.getResult();
        // only official site can set index
        if (site.getCategory() != SiteCategory.OFFICIAL) {
            throw new ResponseException(500, "category illegal");
        }
//        User.TYPE currentUserType = UserUtil.getUser().getEnumType();
//        if (currentUserType != User.TYPE.ADMIN && currentUserType != User.TYPE.SITE_OWNER) {
//            throw new ResponseException(403, "only admin or site_owner can control site pages");
//        }
        return sir.getResult();
    }
}
