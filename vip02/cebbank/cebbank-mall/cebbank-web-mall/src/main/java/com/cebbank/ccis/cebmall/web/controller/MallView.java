package com.cebbank.ccis.cebmall.web.controller;

import com.cebbank.ccis.cebmall.common.components.ViewRender;
import com.google.common.base.Strings;
import com.google.common.collect.ImmutableSet;
import com.spirit.core.exception.NotFound404Exception;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Set;

/**
 * Created by 11140721050130 on 2016/4/4.
 */
@Controller
public class MallView {
    @Autowired
    private ViewRender viewRender;

    @Value("#{app.mainSite}")
    private String mainSite;
    @Value("#{app.domain}")
    private String siteDomain;
    @Value("#{app.context}")
    private String secContext;

    private static Set<String> platformDomainPrefix = ImmutableSet.<String>builder()
            .add("/cgbmall")
            .add("/integrate")
            .add("/dutch")
            .add("/secbuy")
            .add("/groupbuy")
            .add("/brands")
            .build();

    @RequestMapping(method = RequestMethod.GET, produces = MediaType.TEXT_HTML_VALUE)
    public void path(@RequestHeader("Host") String domain, HttpServletRequest request, HttpServletResponse response,
                     Map<String, Object> context) {

        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (path.startsWith("/api/") || path.startsWith("/design/")) {
            throw new NotFound404Exception();
        }
        String domainContext = "";
        for (String prefix : platformDomainPrefix) {
            if (path.startsWith(prefix)) { //如果是属于主站的页面
                path = path.substring(prefix.length());
                path = Strings.isNullOrEmpty(path) ? "/" : path;
                // remove first "/"
                domainContext = prefix.split("/")[1];
                break;
            }
        }

        if (Strings.isNullOrEmpty(domainContext)) {
            // remove first "/"
            domainContext = secContext.split("/")[1];
        }
        domain = domain.split(":")[0];

        viewRender.view(domain, domainContext, path.substring(1), request, response, context);

    }
}
