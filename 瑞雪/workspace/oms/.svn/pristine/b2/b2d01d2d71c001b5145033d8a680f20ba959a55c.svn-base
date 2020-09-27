package cn.rkylin.apollo.controller;

import cn.rkylin.core.controller.AbstractController;
import cn.rkylin.core.service.ApolloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Admin on 2016/6/28.
 */


@Controller
@RequestMapping("/ruixue")
public class RuiXueDataController extends AbstractController {

    @Autowired
    public ApolloService commonService;

    @RequestMapping("/findProjectPage")
    @ResponseBody
    public Map findProjectPage(@RequestParam(required = false, defaultValue = "1")
                          int page, @RequestParam(required = false, defaultValue = "20")
                          int rows, HttpServletRequest request) throws Exception {
        Map retMap = new HashMap();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("index","findRXProject");
        retMap = commonService.findByPage(page,rows,params);
        return retMap;
    }

    @RequestMapping("/findProjectData")
    @ResponseBody
    public List findProjectData( HttpServletRequest reques) throws Exception {
        Map retMap = new HashMap();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("index","findRXProject");
        List retList = commonService.findForList(params);
        return retList;
    }
}
