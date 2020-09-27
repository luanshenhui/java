/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.modules.visualization.web;

import com.hepowdhc.dcapp.api.bean.MapperBean;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaHomePageEntity;
import com.hepowdhc.dcapp.modules.visualization.service.DcaHomePageService;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.web.BaseController;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 首页Controller
 *
 * @author liuc
 * @version 2016-12-26
 */
@Controller
@RequestMapping(value = "${adminPath}/index")
public class DcaHomePageController extends BaseController {

    @Autowired
    private DcaHomePageService dcaHomePageService;

    @Autowired(required=false)
    @Qualifier("sqlApi")
   
    private HashMap queryMap;


    /**
     * 首页框显示
     */
    @RequestMapping(value = "/homepage")
    public String showHomePage(Model model) {

        DcaHomePageEntity result = dcaHomePageService.getHomePage();

        if (result != null) {
            model.addAttribute("closingTime", result.getClosingTime());
            model.addAttribute("refreshTime", result.getRefreshTime());
            model.addAttribute("frequency", result.getFrequency());
            model.addAttribute("powerName", result.getPowerName());
        }

        return "modules/dca/homePage";
    }

    /**
     * 首页左一仪表盘图使用数据
     *
     * @author liuc
     * @date 2017年1月3日
     */

    @ResponseBody
    @RequestMapping(value = "/getDataForGauge")
    public String getDataForGauge() {
        DcaHomePageEntity result = dcaHomePageService.getDataForGauge();

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页左二风险/告警等级使用数据
     *
     * @author liuc
     * @date 2017年1月3日
     */

    @ResponseBody
    @RequestMapping(value = "/getDataForRiskAlarm")
    public String getDataForRiskAlarm(String powerId, String sysDate) {
        DcaHomePageEntity result = dcaHomePageService.getDataForRiskAlarm(powerId, sysDate);

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页左三数据引擎监控情况使用数据
     *
     * @author liuc
     * @date 2017年1月6日
     */

    @ResponseBody
    @RequestMapping(value = "/getBizDataLastList")
    public String getBizDataLastList() {
        List<Integer> result = dcaHomePageService.getBizDataLastList();

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页中间雷达图使用数据
     *
     * @author liuc
     * @date 2017年1月3日
     */

    @ResponseBody
    @RequestMapping(value = "/getDataForRadar")
    public String getDataForRadar() {
        DcaHomePageEntity result = dcaHomePageService.getDataForRadar();

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页右一柱状图使用数据
     *
     * @author liuc
     * @date 2017年1月3日
     */

    @ResponseBody
    @RequestMapping(value = "/getDataForWorkBar")
    public String getDataForWorkBar() {
        DcaHomePageEntity result = dcaHomePageService.getDataForWorkBar();

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页右二饼图使用数据
     *
     * @author liuc
     * @date 2017年1月3日
     */

    @ResponseBody
    @RequestMapping(value = "/getDataForPie")
    public String getDataForPie() {
        DcaHomePageEntity result = dcaHomePageService.getDataForPie();

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页右三数据展示使用数据
     *
     * @author liuc
     * @date 2017年1月3日
     */

    @ResponseBody
    @RequestMapping(value = "/getDataForShowData")
    public String getDataForShowData(String sysDate) {
        DcaHomePageEntity result = dcaHomePageService.getDataForShowData(sysDate);

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 获取大屏第二屏相关数据
     *
     * @author liuc
     * @date 2016年12月26日
     */

    @ResponseBody
    @RequestMapping(value = "/getSecondData")
    public String getHomePageSecondData(String powerId, String sysDate, Model model) {
        DcaHomePageEntity result = dcaHomePageService.getHomePageSecondData(powerId, sysDate);

        return JsonMapper.nonDefaultMapper().toJson(result);
    }

    /**
     * 首页内容显示
     */
    @RequestMapping(value = "/homepageInfo")
    public String showHomePageInfo() {

        return "modules/dca/homePageInfo";
    }

    /**
     * 首页第二页显示
     */
    @RequestMapping(value = "/homepageDetail")
    public String showHomePageDetail(String powerId, Model model) {
        model.addAttribute("powerId", powerId);
        return "modules/dca/homePageDetail";
    }

    /**
     * 首页风险点
     */
    @RequestMapping(value = "/riskpoint")
    public String showriskPoint() {

        return "modules/dca/riskpoint";
    }

    /**
     * 首页流程说明
     */
    @RequestMapping(value = "/workflowinstruction")
    public String showworkflowinstruction() {

        return "modules/dca/workflowinstruction";
    }

    /**
     * 首页监管职责
     */
    @RequestMapping(value = "/duty")
    public String showduty() {

        return "modules/dca/duty";
    }

    /**
     * 首页sql执行接口
     *
     * @return 查询结果
     * @throws Exception geshuo
     *                   20170110
     */
    @ResponseBody
    @RequestMapping(value = "/api")
    public Object pageApi(HttpServletRequest request, HttpSession session) throws Exception {

        Map<String, String[]> requestParameterMap = request.getParameterMap();

        //构造查询参数
        Map<String, Object> paramMap = new HashMap<>();


        for (Entry<String, String[]> me : requestParameterMap.entrySet()) {
            String[] values = me.getValue();
            if(ArrayUtils.isEmpty(values)){
                continue;
            }
            paramMap.put(me.getKey(),values.length==1 ? values[0] : values);
        }

        if (paramMap.isEmpty()) {
            return "{msg:'参数不能为空!'}";
        }
        String queryId = (String) paramMap.get("_id");//获取查询id


        if (StringUtils.isEmpty(queryId)) {
            return "{msg:'id不能为空!'}";
        }

        MapperBean queryMapper = (MapperBean) queryMap.get(queryId);//获取查询对象

        if (null == queryMapper) {
            return "{msg:'SQL对应的_id配置错误!'}";
        }

        paramMap.remove("_id");// 查询参数中不包括_id
        Path path = Paths.get(session.getServletContext().getRealPath("WEB-INF/sql"), queryId + "" +
                ".sql");
        return queryMapper.execute(path,paramMap);

    }


//    /**
//     * 首页sql执行接口(废弃 20170113)
//     *
//     * @param ds  数据源name，和spring-context.xml中bean的name对应
//     * @param fn  sql文件名称，包括后缀名
//     * @param arg 参数数组
//     * @return 查询结果
//     * @throws Exception geshuo
//     *                   20170110
//     */
//    @ResponseBody
//    @RequestMapping(value = "/api")
//    public Object pageApi(@RequestParam("ds") String ds,
//                          @RequestParam("fn") String fn,
//                          @RequestParam("arg[]") String[] arg,
//                          HttpSession session) throws Exception {
//
//        String sqlpath = session.getServletContext().getRealPath("/WEB-INF/sql/");
//
//        //校验参数
//        if (StringUtils.isEmpty(ds)) {
//            return "{msg:'数据源不能为空!'}";
//        }
//        //加载数据库配置
//        final DruidDataSource dataSourceBean = SpringContextHolder.getBean(ds);
//
//        if (dataSourceBean == null) {
//            return "{msg:'数据源设置错误!'}";
//        }
//
//        final JdbcTemplate template = new JdbcTemplate(dataSourceBean);
//
//        if (StringUtils.isEmpty(fn)) {
//            return "{msg:'文件名不能为空!'}";
//        }
//
//        final String sql = FileUtils.readFileToString(Paths.get(sqlpath, fn).toFile(), "UTF8");
//
//        final VerifySql ver = new VerifySql() {
//
//            @Override
//            public void setConfig(WallConfig config) {
//                config.setCallAllow(false);
//                config.setCreateTableAllow(false);
//                config.setDropTableAllow(false);
//                config.setAlterTableAllow(false);
//                config.setRenameTableAllow(false);
//                config.setLockTableAllow(false);
//                config.setStartTransactionAllow(false);
//                config.setDeleteAllow(false);
//                config.setUpdateAllow(false);
//                config.setInsertAllow(false);
//                config.setMergeAllow(false);
//                config.setIntersectAllow(false);
//                config.setReplaceAllow(false);
//                config.setCommitAllow(false);
//                config.setRollbackAllow(false);
//                config.setUseAllow(false);
//                config.setDescribeAllow(false);
//                config.setShowAllow(false);
//                config.setSchemaCheck(false);
//                config.setTableCheck(false);
//                config.setFunctionCheck(false);
//                config.setObjectCheck(false);
//                config.setVariantCheck(false);
//
//            }
//        };
//
//        logger.debug("======sql=====>" + sql);
//        try {
//            if (!ver.verify(sql)) {
//                throw new SQLException();
//            }
//        } catch (SQLException e) {
//            return "{msg:'非法的查询sql!'}";
//        }
//        //=============
//
//        List<Map<String, Object>> list;
//        if (arg.length == 0) {
//            list = template.queryForList(sql);
//        } else {
//            //构造参数
//            Object[] params = new Object[arg.length];
//            for (int i = 0; i < arg.length; i++) {
//                params[i] = arg[i];
//            }
//            list = template.queryForList(sql, params);
//        }
//        return list;
//    }

}