package cn.rkylin.apollo.controller;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.rkylin.apollo.common.util.ExportProjectUtil;
import cn.rkylin.apollo.common.util.ListUtils;
import cn.rkylin.apollo.common.util.SnoGerUtil;
import cn.rkylin.apollo.service.ProjectService;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;
import cn.rkylin.core.service.ApolloService;

/**
 * Created by Admin on 2016/6/26.
 */

@Controller
@RequestMapping("/project")
public class ProjectController extends AbstractController {
	private static final Log log = LogFactory.getLog(ProjectController.class);

    @Autowired
    public ApolloService commonService;

    @Autowired
    public ProjectService projectService;



    @RequestMapping("/manager")
    public String manager(){
        return "views/project/manager";
    }

    @RequestMapping("/findProject")
    @ResponseBody
    public Map<String, Object> queryLeave(@RequestParam(required = false, defaultValue = "1")
                          int page, @RequestParam(required = false, defaultValue = "20")
                          int rows, HttpServletRequest request) throws Exception {
        Map<String, Object> retMap = new HashMap<String, Object>();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("index","findProject");
        retMap = commonService.findByPage(page,rows,params);
        return retMap;
    }

    @RequestMapping("/insertProject")
    @ResponseBody
	public Map<String, Object> insertProject(HttpServletRequest request) {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		try {
			List<Map<String, Object>> projectList = projectService.findProjectNameByWhere(params);
			if (ListUtils.isEmpty(projectList) || projectList.size() <= 0) {
				String seq = SnoGerUtil.getMysqlProjectCodeSeq();
				 String projectCode = "xm-"+seq;
				 params.put("seq", seq);
				 projectService.updateSeqProject(params);
				 params.put("PROJECT_CODE", projectCode);
				 projectService.addProject(params);
				retMap.put("resultId", 1);
				retMap.put("resultDescription", "添加成功！");
			} else {
				retMap.put("resultId", 0);
				retMap.put("resultDescription", "项目名称已经存在！");
			}
		} catch (Exception e) {
			log.error("增加项目异常", e);
			retMap.put("resultId", 0);
			retMap.put("resultDescription", "添加失败！");
		}
		return retMap;
	}


    @RequestMapping("/modifyProject")
    @ResponseBody
	public Map<String, Object> updateProject(HttpServletRequest request) {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		String projectId = null;
		boolean updteProject = true;
			if(null != params.get("projectId")){
				projectId = String.valueOf(params.get("projectId"));
			}
		try {
			List<Map<String, Object>> projectList = projectService.findProjectNameByWhere(params);
			if (!ListUtils.isEmpty(projectList) && projectList.size() > 0) {
				if (null != projectList.get(0).get("ID")) {
					String resultProjectId = String.valueOf(projectList.get(0).get("ID"));
					if (!resultProjectId.equals(projectId)) {
						updteProject = false;
					}
				}
			}
			if (updteProject) {
				projectService.modifyProject(params);
				retMap.put("resultId", 1);
				retMap.put("resultDescription", "添加成功！");
			} else {
				retMap.put("resultId", 0);
				retMap.put("resultDescription", "项目名称已经存在！");
			}
		} catch (Exception e) {
			log.error("修改项目异常！", e);
			retMap.put("resultId", 0);
			retMap.put("resultDescription", "添加失败！");
		}
		return retMap;
	}
    
    /**
     * 下载项目数据
     * @param request
     * @param response
     */
    @RequestMapping("/exportProjectExcel")
	public void exportProjectExcel(HttpServletRequest request, HttpServletResponse response) {
		ApolloMap<String, Object> params = getParams(request);
		String downloadFileName = "项目管理";
		response.setContentType("application/vnd.ms-excel");
		try {
			if (null != params.get("projectName")) {
				String projectName = new String(String.valueOf(params.get("projectName")).getBytes("iso-8859-1"),
						"utf-8");
				params.put("projectName", projectName);
			}
			List<Map<String, Object>> projectList = projectService.findProjectByWhere(params);
			//查询字典表进行excel中类型格式化
			List<Map<String,Object>> sysDicfmList = findSysDicfmByWhere("fm_project_manage");
			HSSFWorkbook workbook = new ExportProjectUtil().projectExportExcel(projectList,sysDicfmList,downloadFileName);
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			workbook.write(output);
			byte[] bytes = output.toByteArray();
			response.setContentLength(bytes.length);
			byte[] fileNameByte = ("项目管理.xls").getBytes("GBK");
			String fileName = new String(fileNameByte, "ISO8859-1");
			response.setHeader("Content-Disposition",
					"attachment;filename=" + fileName);
			response.getOutputStream().write(bytes);
		} catch (Exception e) {
			log.error("导出项目异常！", e);
		}
	}
    
    /**
	 * 获取字典表中相关表的数据
	 * @param talbe
	 * @return
	 */
	private List<Map<String, Object>> findSysDicfmByWhere(String talbe) {
		List<Map<String, Object>> sysDicfmProjectList = null;
		ApolloMap<String, Object> params = new ApolloMap<String, Object>();
		params.put("fmProjectManage", talbe);
		try {
			sysDicfmProjectList = projectService.findSysDicFmProject(params);
		} catch (Exception e) {
			log.error("查询字典表异常！", e);
		}
		return sysDicfmProjectList;
	}

}
