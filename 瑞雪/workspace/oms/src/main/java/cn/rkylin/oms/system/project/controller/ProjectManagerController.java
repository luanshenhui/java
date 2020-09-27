package cn.rkylin.oms.system.project.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.github.pagehelper.PageInfo;

import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.common.context.CurrentUser;
import cn.rkylin.oms.common.context.WebContextFactory;
import cn.rkylin.oms.common.export.IExport;
import cn.rkylin.oms.system.project.dao.ProjectManageDAOImpl;
import cn.rkylin.oms.system.project.domain.ProjectManager;
import cn.rkylin.oms.system.project.service.ProjectManagerService;
import cn.rkylin.oms.system.project.vo.ProjectVO;

/**
 * 项目控制类
 *
 * @author 李明
 */

@Controller
@RequestMapping("/projectManager")
public class ProjectManagerController extends ApolloController {
    // 常量定义
    private static final String PAGE_SELECT_STATEMENT = "pageSelectProject";
    private static final String VALUE_N = "n";          // 值：n
    private static final String VALUE_Y = "y";          // 值：y
    private static final Log log = LogFactory.getLog(ProjectManagerController.class);


    @Autowired
    public ApolloService commonService;
    
    @Autowired
    public ProjectManagerService projectManagerService;

    @Override
    public void afterPropertiesSet() throws Exception {
        setExportService((IExport) projectManagerService);
    }
    
    /**
     * 查询项目数据
     *
     * @param quickSearch 快速查询条件
     * @return 返回项目map
     * @throws Exception
     * @Param start 第几页
     * @Param length 每页多少行
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @ResponseBody
    @RequestMapping(value = "/getProjectList")
    public Map getProjectList(String quickSearch, String enable, @RequestParam(required = false, defaultValue = "0") int start,
                              @RequestParam(required = false, defaultValue = "10") int length
    ) throws Exception {

        Map map = new HashMap();
        try {
            quickSearch = URLDecoder.decode(quickSearch, "UTF-8");
            // 处理分页
            if (length == -1) {
                length = Integer.MAX_VALUE;
            }
            int page = start / length + 1;
            ProjectVO param = new ProjectVO();
            if (!StringUtils.isEmpty(quickSearch)) {
                param.setPrjName(quickSearch);
            }
            if (!StringUtils.isEmpty(enable)) {
                param.setEnable(enable);
                CurrentUser currentUser = WebContextFactory.getWebContext().getCurrentUser();
                List list=currentUser.getUnitList();
                if(list.size()>0){
                    param.setUnitList(list);
                }else{
                    map.put(JSON_RESULT, SUCCESS);
                    map.put("recordsFiltered", 0);
                    map.put("recordsTotal", 0);
                    map.put(RETURN_DATA, new ArrayList<T>());
                    return map;
                }
            }

            // 处理转义的字段
            Map<String, String> replaceFieldsMap = new HashMap<String, String>();
            replaceFieldsMap.put("enableStatus", "enable");

            // 排序语句生成
            String orderStatement = getOrderString(ProjectManageDAOImpl.class.getName(), PAGE_SELECT_STATEMENT, replaceFieldsMap);
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }

            PageInfo<ProjectVO> projectVOList = projectManagerService.findByWhere(page, length, param);
            map.put(JSON_RESULT, SUCCESS);
            map.put("recordsFiltered", projectVOList.getTotal());
            map.put("recordsTotal", projectVOList.getTotal());
            map.put(RETURN_DATA, projectVOList.getList());

        } catch (Exception ex) {
            ex.printStackTrace();
            map.put("result", "failed");
            map.put("msg", ex.getMessage());
        }
        return map;
    }

    /**
     * 获取所有“启用”且“未删除”的项目
     *
     * @return 封装结果的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getAllAvailableProjects")
    public String getAllAvailableProjects() throws Exception {
        JSONObject returnJSON = new JSONObject();
        try {
            ProjectVO param = new ProjectVO();
            // 项目是启用状态且没有被逻辑删除
            param.setEnable(VALUE_Y);
            param.setDeleted(VALUE_N);
            PageInfo<ProjectVO> projectVOList = projectManagerService.findByWhere(1, Integer.MAX_VALUE, param);
            returnJSON.put(JSON_RESULT, SUCCESS);
            returnJSON.put(RETURN_DATA, projectVOList.getList());
        } catch (Exception ex) {
            ex.printStackTrace();
            returnJSON.put(JSON_RESULT, FAILED);
            returnJSON.put(JSON_MSG, ex.getMessage());
        }
        return JSONObject.toJSONString(returnJSON, SerializerFeature.WriteMapNullValue);
    }
    
    /**
     * 获取所有“启用”且“未删除”的“带有子店铺”项目
     *
     * @return 封装结果的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getSplitProjects")
    public String getSplitProjects() throws Exception {
        JSONObject returnJSON = new JSONObject();
        try {
            ProjectVO param = new ProjectVO();
            // 项目是启用状态且没有被逻辑删除
            param.setEnable(VALUE_Y);
            param.setDeleted(VALUE_N);
            PageInfo<ProjectVO> projectVOList = projectManagerService.findSplitProjects(1, Integer.MAX_VALUE, param);
            returnJSON.put(JSON_RESULT, SUCCESS);
            returnJSON.put(RETURN_DATA, projectVOList.getList());
        } catch (Exception ex) {
            ex.printStackTrace();
            returnJSON.put(JSON_RESULT, FAILED);
            returnJSON.put(JSON_MSG, ex.getMessage());
        }
        return JSONObject.toJSONString(returnJSON, SerializerFeature.WriteMapNullValue);
    }

    /**
     * 获取所有“未删除”的项目 用于平台商品查询高级查询条件
     *
     * @return 封装结果的json串
     * @throws Exception
     * @author wangxing
     */
    @ResponseBody
    @RequestMapping(value = "/getAllValidProjects")
    public String getAllValidProjects() throws Exception {
        JSONObject returnJSON = new JSONObject();
        try {
            ProjectVO param = new ProjectVO();
            // 项目是启用状态且没有被逻辑删除
//            param.setEnable(VALUE_Y);
            param.setDeleted(VALUE_N);
            PageInfo<ProjectVO> projectVOList = projectManagerService.findByWhere(1, Integer.MAX_VALUE, param);
            returnJSON.put(JSON_RESULT, SUCCESS);
            returnJSON.put(RETURN_DATA, projectVOList.getList());
        } catch (Exception ex) {
            ex.printStackTrace();
            returnJSON.put(JSON_RESULT, FAILED);
            returnJSON.put(JSON_MSG, ex.getMessage());
        }
        return JSONObject.toJSONString(returnJSON, SerializerFeature.WriteMapNullValue);
    }

    /**
     * 创建项目
     *
     * @return 创建结果map
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/insertProject")
    public Map<String, String> insertProject(@RequestBody ProjectManager projectManager) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        String prjId = java.util.UUID.randomUUID().toString().replace("-", "");
        params.put("prjId", prjId);
        params.put("prjType", projectManager.getPrjType());
        params.put("prjName", projectManager.getPrjName());
        params.put("cons", projectManager.getCons());
        params.put("tel", projectManager.getTel());
        params.put("expireTime", projectManager.getExpireTime());
        params.put("remark", projectManager.getRemark());
        params.put("enable", "a");
        params.put("deleted", VALUE_N);
        params.put("entId", "51f17f6ddbae11e68c4d001e67c7ec3a");
        params.put("entName", "瑞金麟集团");

        Map<String, String> map = new HashMap<String, String>();
        if (validProjectName(projectManager.getPrjName()) == 1) {
            map.put("result", FAILED);
            map.put("msg", "项目名称已存在");
        } else {
            projectManagerService.insertProject(params);
            map.put("result", SUCCESS);
            map.put("prjId", prjId);
        }

        return map;
    }

    /**
     * 验证项目名称
     *
     * @return valid:true or false
     * @throws Exception
     */
    private int validProjectName(String prjName) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjName", prjName);

        Map<String, Boolean> map = new HashMap<String, Boolean>();
        int existsPrj = projectManagerService.getProjectInfoByName(params);
        return existsPrj;
    }

    /**
     * 根据项目Id获取项目信息
     *
     * @return 项目Object
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = {"/getProject/{prj_id}"})
    public Map<String, Object> getProject(@PathVariable String prj_id) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("index", "getProjectInfo");
        params.put("prjId", prj_id);
        map = commonService.getMapInfo(1, 1, params);
        map.put("success", true);
        return map;
    }

    /**
     * 更改项目
     *
     * @return result:true or false
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/updateProject")
    public Map<String, String> updateProject(@RequestBody ProjectManager projectManager) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjId", projectManager.getPrjId());
        params.put("prjType", projectManager.getPrjType());
        params.put("prjName", projectManager.getPrjName());
        params.put("cons", projectManager.getCons());
        params.put("tel", projectManager.getTel());
        params.put("expireTime", projectManager.getExpireTime());
        params.put("remark", projectManager.getRemark());
        Map<String, String> map = new HashMap<String, String>(1);
        if (validProjectNameAndId(projectManager.getPrjName(), projectManager.getPrjId()) == 1) {

            map.put("result", "false");
            map.put("msg", "项目名称已存在");
        } else {
            int result = projectManagerService.updateProject(params);
            map.put("result", "true");
        }

        return map;
    }

    /**
     * 验证项目名称和Id
     *
     * @return int 0 or 1
     * @throws Exception
     */
    private int validProjectNameAndId(String prjName, String prjId) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjName", prjName);
        params.put("prjId", prjId);

        Map<String, Boolean> map = new HashMap<String, Boolean>();
        int existsPrj = projectManagerService.getProjectInfoByNameAndId(params);
        return existsPrj;
    }

    /**
     * 启用项目
     *
     * @return map response body
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = {"/updatePrjEnable/{prj_id}"})
    public Map<String, Boolean> updatePrjEnable(@PathVariable String prj_id) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjId", prj_id);
        params.put("enable", VALUE_Y);

        int result = projectManagerService.updatePrjEnable(params);
        Map<String, Boolean> map = new HashMap<String, Boolean>(1);
        map.put("success", true);
        return map;
    }

    /**
     * 停用项目
     *
     * @return map response body
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = {"/updatePrjDisable/{prj_id}"})
    public Map<String, Boolean> updatePrjDisable(@PathVariable String prj_id) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjId", prj_id);
        params.put("enable", VALUE_N);

        int result = projectManagerService.updatePrjDisable(params);
        if (result > 0) {
            projectManagerService.updatePrjShopDisable(params);
        }
        Map<String, Boolean> map = new HashMap<String, Boolean>(1);
        map.put("success", true);
        return map;
    }

    /**
     * 删除项目
     *
     * @return map response body
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = {"/deleteProject/{prj_id}"})
    public Map<String, Boolean> deleteProject(@PathVariable String prj_id) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjId", prj_id);
        params.put("deleted", VALUE_Y);

        int result = projectManagerService.deleteProject(params);
        if (result > 0) {
            projectManagerService.deleteProjectShop(params);
        }

        Map<String, Boolean> map = new HashMap<String, Boolean>(1);
        map.put("success", true);
        return map;
    }

    /**
     * 验证项目店铺
     *
     * @return map response body
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/validProjectShop/{prj_id}")
    public Map<String, String> validProjectShop(@PathVariable String prj_id) throws Exception {
        ApolloMap<String, Object> params = new ApolloMap<String, Object>();
        params.put("prjId", prj_id);

        int result = projectManagerService.getEnableShop(params);

        Map<String, String> map = new HashMap<String, String>(1);
        if (result == 1) {
            map.put("success", "false");
        } else {
            map.put("success", "true");
        }
        return map;
    }
    
    /**
     * 获取所有“启用”且“未删除”的项目
     *
     * @return returnMap
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getSelectProjectsList", method = RequestMethod.GET)
    public Map<String, Object> getSelectProjectsList(String entId) throws Exception {
    	Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            ProjectVO param = new ProjectVO();
            // 项目是启用状态且没有被逻辑删除
            param.setEntId(entId);
            param.setEnable(VALUE_Y);
            param.setDeleted(VALUE_N);
            List <ProjectVO> list = projectManagerService.getSelectProjectsList(param);
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RETURN_DATA, list);
        } catch (Exception ex) {
            ex.printStackTrace();
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }
    
    /**
     * 获取项目名称
     *
     * @return returnMap
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getProjectName", method = RequestMethod.GET)
    public Map<String, Object> getProjectName() throws Exception {
    	Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
        	ProjectVO param = new ProjectVO();

        	CurrentUser currentUser = WebContextFactory.getWebContext().getCurrentUser();
        	currentUser.setProjectIdList(null);
        	List<String> idList = currentUser.getProjectIdList();
//        	idList.add("03CDC4C7E55244D484727782450265D1");
//        	idList.add("01F034521CCB4FCA909C0B4D6DE1297F");
//        	idList.add("0435E542D60A4F62801DC318A7120FC9");
        	List <ProjectVO> list =null;
        	if(null != idList && idList.size() > 0){
        		list = projectManagerService.getProjectName(idList);
        	}
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RETURN_DATA, list);
        } catch (Exception ex) {
            ex.printStackTrace();
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }
}
