package chinsoft.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CacheFilter implements Filter {
	boolean isFil = false;// 是否进行过滤
	boolean isPrintMsg = false;// 是否在控制台显示过滤消息
	List<String> noFilFolder = null;

	public void init(FilterConfig config) throws ServletException {
		if (config.getInitParameter("isFil").toLowerCase().equals("true"))
			this.isFil = true;
		if (this.isFil) {
			if (config.getInitParameter("noFilFolder") != null) {
				String noFilFolderstr = config.getInitParameter("noFilFolder");
				if (!noFilFolderstr.equals("")) {
					if (noFilFolderstr.indexOf(",") == -1) {
						this.noFilFolder = new ArrayList();
						this.noFilFolder.add(noFilFolderstr);
					} else {
						this.noFilFolder = new ArrayList();
						String[] noFilFolderarr = noFilFolderstr.split(",");
						for (String s : noFilFolderarr) {
							this.noFilFolder.add(s);
						}
					}
				}

			}

			if ((config.getInitParameter("printMsg") != null)
					&& (config.getInitParameter("printMsg").toLowerCase()
							.equals("true")))
				this.isPrintMsg = true;
		}
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		boolean isdoFilter = true;
		if (this.isFil) {
			HttpServletRequest httpRequest = (HttpServletRequest) request;
			HttpSession session = httpRequest.getSession();

			List filterFileNameList = new ArrayList();
			if (session.getAttribute("org.per.lm.att.filterFileName") != null)
				filterFileNameList = (List) session
						.getAttribute("org.per.lm.att.filterFileName");
			else {
				session.setAttribute("org.per.lm.att.filterFileName",
						filterFileNameList);
			}
			String url = httpRequest.getServletPath();
			url = url.substring(1);
			String hz = url.substring(url.lastIndexOf(".") + 1);
			isPrintMsg("-------------------------------------");
			isPrintMsg("过滤文件集合size:" + filterFileNameList.size());
			isPrintMsg(url);

			if (url.indexOf("/") != -1) {
				boolean flag = false;
				if (this.noFilFolder != null) {
					for (String name : this.noFilFolder) {
						if (url.indexOf(name) == 0) {
							flag = true;
							isPrintMsg(name + "文件夹不过滤!");
							break;
						}
					}
				}
				if (!flag) {
					if (filterFileNameList.contains(url)) {
						isPrintMsg("过滤掉:" + url);
						((HttpServletResponse) response).setStatus(304);

						isdoFilter = false;
					} else {
						isPrintMsg("新增过滤:" + url);
						filterFileNameList.add(url);
						session.setAttribute("org.per.lm.att.filterFileName",
								filterFileNameList);
					}

				}

			} else if (filterFileNameList.contains(url)) {
				isPrintMsg("过滤掉:" + url);
				((HttpServletResponse) response).setStatus(304);
				isdoFilter = false;
			} else {
				isPrintMsg("新增过滤:" + url);
				filterFileNameList.add(url);
				session.setAttribute("org.per.lm.att.filterFileName",
						filterFileNameList);
			}
		}

		if (isdoFilter)
			chain.doFilter(request, response);
	}

	public void destroy() {
	}

	private void isPrintMsg(String log) {
		if (this.isPrintMsg)
			System.out.println(log);
	}
}