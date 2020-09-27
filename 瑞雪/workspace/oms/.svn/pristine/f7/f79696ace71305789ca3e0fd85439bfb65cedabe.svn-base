package cn.rkylin.apollo.controller;

import cn.rkylin.apollo.service.ProjectShopService;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Admin on 2016/7/2.
 */
@Controller
@RequestMapping("/project/shop")
public class ProjectShopController extends AbstractController {
	private static final Log log = LogFactory.getLog(ProjectShopController.class);
	
    @Autowired
    public ProjectShopService projectShopService;

    @RequestMapping("/updateProjectShop")
    @ResponseBody
	public Map<String, Object> updateProjectShop(HttpServletRequest request) {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		try {
			projectShopService.modifyProjectShop(params);
			retMap.put("resultId", 1);
			retMap.put("resultDescription", "修改成功！");
		} catch (Exception e) {
			log.error("修改店铺异常", e);
			retMap.put("resultId", 0);
			retMap.put("resultDescription", "修改店铺失败！");
		}
		return retMap;
	}

    @RequestMapping("/addProjectShop")
    @ResponseBody
    public Map addProjectShop(HttpServletRequest request) throws Exception {
        Map retMap = new HashMap();
        ApolloMap<String,Object> params = getParams(request);
        int r = projectShopService.addProjectShop(params);
        retMap.put("resultId", 1);
        retMap.put("resultDescription", "修改成功！");
        return retMap;
    }

}
