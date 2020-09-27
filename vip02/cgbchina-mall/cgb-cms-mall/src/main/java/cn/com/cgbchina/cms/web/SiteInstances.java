package cn.com.cgbchina.cms.web;

import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Objects;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import com.spirit.core.exception.Server500Exception;
import com.spirit.core.model.Page;
import com.spirit.core.model.Site;
import com.spirit.core.model.SiteInstance;
import com.spirit.core.model.TemplateInstance;
import com.spirit.core.model.TemplatePage;
import com.spirit.core.service.PageService;
import com.spirit.core.service.SiteInstanceService;
import com.spirit.core.service.SiteService;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * @author changji.zhang
 */
@Slf4j
@Controller
@RequestMapping("/api/design/instances")
public class SiteInstances {

    @Autowired
    private SiteService siteService;

    @Autowired
    private SiteInstanceService siteInstanceService;
    @Autowired
    private PageService pageService;

    @Autowired
    private MessageSources messageSources;

    private JsonMapper jsonMapper = JsonMapper.JSON_NON_EMPTY_MAPPER;
    private JavaType gdatasType = jsonMapper.createCollectionType(Map.class, String.class, String.class);

    @RequestMapping(value = "/template/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    public void saveTemplateInstance(@PathVariable Long id, @RequestParam Long pageId,
                                     @RequestParam String header, @RequestParam String body, @RequestParam String footer,
                                     @RequestParam(required = false) String parts,
                                     @RequestParam(required = false) String gdatas) {
        try {
            Response<TemplateInstance> sir = siteInstanceService.findTemplateInstanceById(id);
            Response<TemplatePage> pr = pageService.findTemplatePageById(pageId);
            Server500Exception.failToThrow(pr);
            pr.getResult().setJsonParts(parts);
            pr.getResult().setFixed(body);
            if ((pr.getResult().getIsTemplate() != null && pr.getResult().getIsTemplate() == 0) || pr.getResult().getIsTemplate() == null) {
                Server500Exception.failToThrow(sir);
                sir.getResult().setHeader(header);
                sir.getResult().setFooter(footer);
            } else {
                pr.getResult().setTemHeader(header);
                pr.getResult().setTemFooter(footer);
            }
            Map<String, String> gdatasMap = null;
            if (!Strings.isNullOrEmpty(gdatas)) {
                gdatasMap = JsonMapper.nonEmptyMapper().fromJson(gdatas, gdatasType);
            }
            Response<Long> saveR = siteInstanceService.saveTemplateInstanceWithPage(sir.getResult(), pr.getResult(), gdatasMap);
            Server500Exception.failToThrow(saveR);
        } catch (Server500Exception e) {
            log.error("failed to save template instance for template(id={}) and page(id={}),error code:{} ", id, pageId, e.getMessage());
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
    }

    @RequestMapping(value = "/site/{instanceId}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    public void saveSiteInstance(@PathVariable Long instanceId, @RequestParam Long pageId, @RequestParam String parts) {
        if (parts.length() > 10240) {
            log.error("parts length is {},and long than 10k", parts.length());
            throw new ResponseException(500, messageSources.get("content.too.long"));
        }
        Response<SiteInstance> sir = siteInstanceService.findSiteInstanceById(instanceId);
        if (!sir.isSuccess()) {
            log.error("failed to find siteInstance(id={}),error code:{}", instanceId, sir.getError());
            throw new ResponseException(500, messageSources.get(sir.getError()));
        }
        Response<Site> sr = siteService.findById(sir.getResult().getSiteId());
        if (!sr.isSuccess()) {
            log.error("failed to find site(id={}),error code:{}", sir.getResult().getSiteId(), sr.getError());
            throw new ResponseException(500, messageSources.get(sir.getError()));
        }
        Site site = sr.getResult();
        User user = UserUtil.getUser();
        if (!Objects.equal(site.getUserId(), user.getId())) {
            log.error("site(id={}) not belong to user(id={})", site.getId(), user.getId());
            throw new ResponseException(403, "site not belong to u");
        }

        Response<Page> pr = pageService.findPageById(pageId);
        if (!pr.isSuccess()) {
            log.error("failed to find page(id={}),error code:{}", pageId, pr.getError());
            throw new ResponseException(500, messageSources.get(pr.getError()));
        }
        pr.getResult().setJsonParts(parts);
        Response<Long> saveR = pageService.updatePage(pr.getResult());
        if (!pr.isSuccess()) {
            log.error("failed to save siteInstance(id={}) and page(id={}),error code:{}", instanceId, pageId, saveR.getError());
            throw new ResponseException(500, messageSources.get(saveR.getError()));
        }
    }
}
