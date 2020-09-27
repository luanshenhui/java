package cn.com.cgbchina.score;

import cn.com.cgbchina.web.common.ViewRender;
import com.spirit.core.exception.NotFound404Exception;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@Controller
public class DefaultView {

	@Autowired
	private ViewRender viewRender;

	@RequestMapping(method = RequestMethod.GET, produces = MediaType.TEXT_HTML_VALUE)
	public void path(HttpServletRequest request, HttpServletResponse response, Map<String, Object> context) {
		String path = request.getRequestURI().substring(request.getContextPath().length());
		if (path.startsWith("/api/") || path.startsWith("/design/")) {
			throw new NotFound404Exception();
		}
		viewRender.layoutView(path.substring(1), request, response, context);
	}
}
