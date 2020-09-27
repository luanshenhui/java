package cn.rkylin.apollo.system.service.impl;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;

import cn.rkylin.apollo.common.util.HttpUtil;
import cn.rkylin.apollo.common.util.PropertiesUtils;
import cn.rkylin.apollo.system.domain.RoleInfo;
import cn.rkylin.apollo.system.service.ISystemRoleService;
import cn.rkylin.apollo.system.web.util.SystemApiUtil;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName:
 * SystemRoleServiceImpl.java
 * 
 * @Description: 系统用户角色相关功能业务类
 * @author zhangXinyuan
 * @Date 2016-7-12 下午 16:22
 * @version 1.00
 */

@Service("systemRoleService")
public class SystemRoleServiceImpl implements ISystemRoleService {
	private Log log = LogFactory.getLog(SystemRoleServiceImpl.class);
	private static final String serverPath = PropertiesUtils.getVal("sysServiceAddress");

	@Override
	public String searchRole(RoleInfo role) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_ROLE_URL;
		StringBuffer params = new StringBuffer("");
		String roleJson = null;
		try {
			if (StringUtils.isNotBlank(role.getId())) {
				params.append("&roleId=").append(role.getId()); // 为all，查询全部
			}
			if (StringUtils.isNotBlank(role.getRolename())) {
				params.append("&roleName=").append(role.getRolename());
			}
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			// String jsonStr = HttpUtils.sendByGet(url, params.toString());
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), role.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultRoleJson = jsonObject.getJSONObject("result");
				roleJson = resultRoleJson.toString();
			}
		} catch (Exception e) {
			log.error("查询角色信息异常", e);
		}
		return roleJson;
	}

	@Override
	public Map<String, Object> addRole(RoleInfo role) throws Exception {
		String url = serverPath + SystemApiUtil.ADD_MODIFY_ROLE_URL;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		StringBuffer params = new StringBuffer("");
		String roleName = null;
		String remark = null;
		try {
			if (StringUtils.isNotEmpty(role.getId())) {
				params.append("&roleId=").append(role.getId()); // 为空表示修改
			}
			if (StringUtils.isNotEmpty(role.getRolename())) {
				roleName = URLEncoder.encode(role.getRolename().toString(), "utf-8");
			}
			if (StringUtils.isNotEmpty(role.getRemark())) {
				remark = URLEncoder.encode(role.getRemark().toString(), "utf-8");
				params.append("&remark=").append(remark);
			}
			params.append("&roleName=").append(roleName);
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), role.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				resultMap.put("success", true);
			} else if ("-201".equals(resulStatus)) {
				resultMap.put("success", false);
				resultMap.put("message", jsonObject.getString("message"));
			} else {
				resultMap.put("success", false);
				resultMap.put("message", "保存失败！");
			}
		} catch (Exception e) {
			log.error("增加或修改角色信息异常", e);
		}
		return resultMap;
	}

	@Override
	public boolean delRole(RoleInfo role) throws Exception {
		String url = serverPath + SystemApiUtil.DEL_ROLE_URL;
		StringBuffer params = new StringBuffer("");
		boolean success = false;
		try {
			params.append("&roleId=").append(role.getId());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), role.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				success = true;
			}
		} catch (Exception e) {
			log.error("删除角色信息异常", e);
		}
		return success;
	}

}
