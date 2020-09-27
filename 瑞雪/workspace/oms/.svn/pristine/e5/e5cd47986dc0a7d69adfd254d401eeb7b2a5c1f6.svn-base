package cn.rkylin.oms.system.log.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;

import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.oms.system.appClient.dao.AppClientDAOImpl;
import cn.rkylin.oms.system.appClient.domain.AppClient;
import cn.rkylin.oms.system.appClient.vo.AppClientVo;
import cn.rkylin.oms.system.log.domain.LogDomain;
import cn.rkylin.oms.system.log.service.ILogService;
import cn.rkylin.oms.system.log.vo.LogDomainVo;
import cn.rkylin.oms.system.user.vo.UserVO;

@Controller
@RequestMapping("/log")
public class LogController extends ApolloController{
	private static final Log logger = LogFactory.getLog(LogController.class);
	
	@Autowired
	private ILogService logService;
	
	/**
	 * 日志表格数据
	 * 
	 * @param quickSearch
	 * @param start
	 * @param length
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/logList", method = RequestMethod.GET)
	public Map<String, Object> getSplitRuleItemList(String quickSearch,String formJson,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length) throws Exception {
		// 用于返回值的json对象
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			// 处理分页
			if (length == -1) {
				length = Integer.MAX_VALUE;
			}
			int page = start / length + 1;
			// 处理快速查询条件
			LogDomainVo param = new LogDomainVo();
			if (StringUtils.isNotEmpty(quickSearch)) {
				param.setSearchCondition(URLDecoder.decode(quickSearch, "UTF-8"));
			}else if(StringUtils.isNotEmpty(formJson)){
				  // 高级查询检索条件
                formJson = URLDecoder.decode(formJson, "UTF-8");
                LogDomain param1 = JSONObject.parseObject(formJson, LogDomain.class);
                if (param1 != null) {
                    if (StringUtils.isNotEmpty(param1.getBizId())) {
                        param.setBizId(param1.getBizId());
                    }
                    if (StringUtils.isNotEmpty(param1.getTag())) {
                        param.setTag(param1.getTag());
                    }
                    if (StringUtils.isNotEmpty(param1.getUser())) {
                        param.setUser(param1.getUser());
                    }
                    if (StringUtils.isNotEmpty(param1.getOperation())) {
                        param.setOperation(param1.getOperation());
                    }
                    if (StringUtils.isNotEmpty(param1.getSourceType())) {
                    	param.setSourceType(param1.getSourceType());
                    }
                    if (StringUtils.isNotEmpty(param1.getLogType())) {
                    	param.setLogType(param1.getLogType());
                    }
                }
			}
			// 处理转义的字段
			Map<String, String> replaceFieldsMap = new HashMap<String, String>();
			// replaceFieldsMap.put("status", "enable");
			// 排序语句生成
//			String orderStatement = getOrderString("", "selectLogListPage", replaceFieldsMap);/////////////////////
//			if (StringUtils.isNotEmpty(orderStatement)) {
//				param.setOrderBy(orderStatement);
//			}
			// 获取分页数据
			PageInfo<LogDomainVo> list = logService.findByWhere(page, length, param);
			// 设置返回结果内容
			returnMap.put(JSON_RESULT, SUCCESS);
			returnMap.put(RECORDS_FILTERED, list.getTotal());
			returnMap.put(RECORDS_TOTAL, list.getTotal());
			returnMap.put(RETURN_DATA, list.getList());
		} catch (Exception ex) {
			logger.error(ex);
			returnMap.put(JSON_RESULT, FAILED);
			returnMap.put(JSON_MSG, ex.getMessage());
		}
		// 生成返回结果json串，null内容也需要返回
		return returnMap;
	}
	
	/**
	 * 删除方法
	 * @param  arr 主键数组
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/deleteLog", method = RequestMethod.POST)
	public String deleteLog(String [] arr) {
		try {
			logService.deleteLog(arr);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
			return FAILED;
		}
		return SUCCESS;
	}
	
	/**
	 * 获取详情
	 * @param 实体主键
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getLogDetail", method = RequestMethod.GET)
	public Map<String, Object> getAppClientDetail(String id) {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			LogDomain log = new LogDomain();
			log.setBizId(id);
			log = logService.getLogDetail(log);
			returnMap.put(JSON_RESULT, SUCCESS);
			returnMap.put(RETURN_DATA, log);
			return returnMap;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
			returnMap.put(JSON_RESULT, FAILED);
			returnMap.put(JSON_MSG, e.getMessage());
		}
		return returnMap;
	}

}
