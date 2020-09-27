package cn.com.cgbchina.cms;

import cn.com.cgbchina.web.common.ViewRender;
import com.spirit.exception.NotFound404Exception;
import com.spirit.web.MessageSources;
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

/**
 * Created by 11140721050130 on 2016/4/4.
 */
@Controller
public class CmsView {
	@Autowired
	private ViewRender viewRender;

	@Value("#{app.mainSite}")
	private String mainSite;
	@Value("#{app.domain}")
	private String siteDomain;
	@Autowired
	private MessageSources messageSources;

	@RequestMapping(method = RequestMethod.GET, produces = MediaType.TEXT_HTML_VALUE)
	public void path(@RequestHeader("Host") String domain, HttpServletRequest request, HttpServletResponse response,
			Map<String, Object> context) {
		String path = request.getRequestURI().substring(request.getContextPath().length());
		if (path.startsWith("/api/") || path.startsWith("/design/")) {
			throw new NotFound404Exception();
		}
		domain = domain.split(":")[0];
		viewRender.view(domain, path.substring(1), request, response, context);
	}
}
