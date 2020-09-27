package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import com.google.common.base.MoreObjects;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import com.spirit.core.exception.Server500Exception;
import com.spirit.core.model.Site;
import com.spirit.core.service.SiteService;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/api/admin/sites")
@Controller
@Slf4j
public class Sites {

    @Autowired
    private SiteService siteService;

    @Value("#{app.domain}")
    private String officialDomain;

    @Autowired
    private MessageSources messageSources;

    @RequestMapping(value = "/announcement/{id}/release", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public void release(@PathVariable("id") Long siteId, @RequestParam(value = "instanceId", required = false) Long instanceId) {
        Response<Site> siteR = siteService.findById(siteId);
        if(!siteR.isSuccess()){
            log.error("Response.error,error code: {}", siteR.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(siteR.getError()));
        }
        Server500Exception.failToThrow(siteR);
        Site site = siteR.getResult();
        if (site == null) {
            log.warn("site not found when release, siteId: {}", siteId);
            throw new ResponseException(400, "站点不存在");
        }
        User user = UserUtil.getUser();
        instanceId = MoreObjects.firstNonNull(instanceId, site.getDesignInstanceId());
        Response<Long> releaseR = siteService.release(siteId, instanceId);
        Server500Exception.failToThrow(releaseR);
        log.info("user id={} release site instanceId={}", user.getId(), instanceId);
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Long create(@RequestParam String name,
                       @RequestParam(required = false) String context,
                       @RequestParam(required = false) String domain,
                       @RequestParam(required = false) String subDomain) {
        User user = UserUtil.getUser();
        Site site = new Site();
        site.setName(name);
        site.setContext(context);
        if (!Strings.isNullOrEmpty(domain)) {
            if (domain.endsWith(officialDomain)) {
                log.error("domain can not end with {}", officialDomain);
                throw new ResponseException(500, messageSources.get("domain.error"));
            }
            Response<Site> sr = siteService.findBydomain(domain);
            if (sr.isSuccess()) {
                throw new ResponseException(500, messageSources.get("domain.exist"));
            }
            site.setDomain(domain);
        }
        if (!Strings.isNullOrEmpty(subDomain)) {
            if (subDomain.endsWith(officialDomain)) {
                log.error("subDomain can not end with {}", officialDomain);
                throw new ResponseException(500, messageSources.get("subDomain.error"));
            }
            Response<Site> sr = siteService.findBySubdomainAndContext(subDomain,context);
            if (sr.isSuccess()) {
                throw new ResponseException(500, messageSources.get("subDomain.exist"));
            }
            site.setSubdomain(subDomain);
        }
        Response<Long> createR = siteService.createSubSite(user.getId(), site);
        if(!createR.isSuccess()){
            log.error("Response.error,error code: {}", createR.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(createR.getError()));
        }
        Server500Exception.failToThrow(createR);

        log.info("user id={} create sub site by name={}, domain={}, subDomain={}",
                user.getId(), name, domain, subDomain);

        return createR.getResult();
    }

    @RequestMapping(value = "/templates", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Long createTemplate(@RequestParam String name) {
        User user = UserUtil.getUser();
        Site site = new Site();
        site.setName(name);
        Response<Long> createR = siteService.createTemplateSite(user.getId(), site);
        if(!createR.isSuccess()){
            log.error("Response.error,error code: {}", createR.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(createR.getError()));
        }
        Server500Exception.failToThrow(createR);
        log.info("user id={} create template by name={}", user.getId(), name);
        return createR.getResult();
    }

    /**
     * 0823 改造，只允许更新站点名称
     * @param siteId
     * @param name
     * @param context
     * @param domain
     * @param subDomain
     */
    @RequestMapping(value = "edit/{siteId}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public void update(@PathVariable Long siteId, @RequestParam String name, @RequestParam(required = false) String context,
                       @RequestParam(required = false) String domain,
                       @RequestParam(required = false) String subDomain) {
        Response<Site> sr = siteService.findById(siteId);
        if(!sr.isSuccess()){
            log.error("Response.error,error code: {}", sr.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(sr.getError()));
        }
        Server500Exception.failToThrow(sr);
        Site site = sr.getResult();
        if (site == null) {
            throw new ResponseException(400, "站点不存在");
        }
        User user = UserUtil.getUser();
        site.setName(name);
        Response<Boolean> updateR = siteService.update(site);
        Server500Exception.failToThrow(updateR);
        log.info("user id={} update site id={} name={}, domain={}, subDomain={}",
                user.getId(), siteId, name, domain, subDomain);
    }

    @RequestMapping(value = "delete/{siteId}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public void delete(@PathVariable Long siteId) {
        User user = UserUtil.getUser();
        Response<Boolean> deleteR = siteService.deleteSite(user.getId(), siteId);
        Server500Exception.failToThrow(deleteR);
        log.info("user id={} delete site id={}", user.getId(), siteId);
    }
}
