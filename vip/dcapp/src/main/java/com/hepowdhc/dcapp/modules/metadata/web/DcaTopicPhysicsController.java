/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.web;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.thinkgem.jeesite.common.mapper.JsonMapper;
import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Maps;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysics;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysicsFields;
import com.hepowdhc.dcapp.modules.metadata.service.DcaTopicPhysicsService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 物理表管理Controller
 * 
 * @author HuNan
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaTopicPhysics")
public class DcaTopicPhysicsController extends BaseController {

	@Autowired
	private DcaTopicPhysicsService dcaTopicPhysicsService;

	private DcaTopicPhysics tableList = new DcaTopicPhysics();

	private List<DcaTopicPhysicsFields> columnList = new ArrayList<>();

	@ModelAttribute
	public DcaTopicPhysics get(@RequestParam(required = false) String tableName) {

		DcaTopicPhysics entity = null;

		if (StringUtils.isNotBlank(tableName)) {
			entity = dcaTopicPhysicsService.get(tableName);
		}
		if (entity == null) {
			entity = new DcaTopicPhysics();
			entity.getCurrentFiled().initDefaultInfo();
		}

		return entity;
	}

	/**
	 * list查询页面
	 * 
	 * @param dcaTopicPhysics 查询参数
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaTopicPhysics dcaTopicPhysics, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		Page<DcaTopicPhysics> page = dcaTopicPhysicsService.findPage(new Page<DcaTopicPhysics>(request, response),
				dcaTopicPhysics);
		model.addAttribute("page", page);

		return "modules/dca/dcaTopicPhysicsList";
	}

	/**
	 * 新建、编辑画面
	 * 
	 * @param model model对象
	 * @return 新建、编辑画面 画面路径
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:view")
	@RequestMapping(value = "form")
	public String form(Model model) {

		model.addAttribute("dcaTopicPhysics", tableList);
		return "modules/dca/dcaTopicPhysicsForm";
	}

	/**
	 * detail页面 调用getDetail方法，得到物理表字段详情信息，返回到detail页面
	 * 
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "showDetail")
	public String showDetail(DcaTopicPhysics dcaTopicPhysics, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		Page<DcaTopicPhysics> page = dcaTopicPhysicsService.getDetail(new Page<DcaTopicPhysics>(request, response),
				dcaTopicPhysics);
		model.addAttribute("page", page);

		return "modules/dca/dcaTopicPhysicsDetails";
	}

	/**
	 * 物理表的新建
	 * 
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "tableAdd")
	public String tableAdd(Model model) {

		tableList = new DcaTopicPhysics();
		columnList = new ArrayList<>();

		// 新建的场合,oldTable设置为空,来区分新建和编辑(空:新建,非空:编辑)
		tableList.setOldTableName("");
		DcaTopicPhysicsFields dcaTopicPhysicsFields = new DcaTopicPhysicsFields();
		dcaTopicPhysicsFields.setIsNull(Constant.RADIO_YES);
		dcaTopicPhysicsFields.setColumnKey(Constant.RADIO_NO);
		dcaTopicPhysicsFields.setIsOnly(Constant.RADIO_NO);

		// 清空字段输入项内容
		tableList.setCurrentFiled(dcaTopicPhysicsFields);

		model.addAttribute("dcaTopicPhysics", tableList);

		return "modules/dca/dcaTopicPhysicsForm";
	}

	/**
	 * 物理表的编辑
	 * 
	 * @param dcaTopicPhysics 物理表对象
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "tableEdit")
	public String tableEdit(DcaTopicPhysics dcaTopicPhysics, HttpServletRequest request, Model model) {

		// 清空全局变量
		tableList = new DcaTopicPhysics();
		columnList = new ArrayList<>();

		// 获取编辑表的表名
		String tableName = request.getParameter("id");

		// 获取编辑表的表注释
		String tableComment = request.getParameter("tableComment");

		if (StringUtils.isNotEmpty(tableName)) {

			// 物理表字段属性信息取得
			List<DcaTopicPhysicsFields> tableData = dcaTopicPhysicsService.getTableData(dcaTopicPhysics);

			if (CollectionUtils.isNotEmpty(tableData)) {

				for (DcaTopicPhysicsFields item : tableData) {

					// 字段属性list设置
					columnList.add(changeToShow(item));

				}

				DcaTopicPhysicsFields dcaTopicPhysicsFields = new DcaTopicPhysicsFields();
				dcaTopicPhysicsFields.setIsNull(Constant.RADIO_YES);
				dcaTopicPhysicsFields.setColumnKey(Constant.RADIO_NO);
				dcaTopicPhysicsFields.setIsOnly(Constant.RADIO_NO);

				// 清空字段输入项内容
				tableList.setCurrentFiled(dcaTopicPhysicsFields);

				// 物理表英文名设置
				tableList.setTableName(tableName);

				// 编辑表对象设置(判断是否为编辑:非空为编辑的场合)
				tableList.setOldTableName(tableName);

				// 物理表中文名设置
				tableList.setTableComment(tableComment);

				// 物理表字段信息设置
				tableList.setColumnList(columnList);

			}
		}

		model.addAttribute("dcaTopicPhysics", tableList);

		return "modules/dca/dcaTopicPhysicsForm";
	}

	/**
	 * 物理表的保存
	 * 
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "tableSave")
	public String tableSave(DcaTopicPhysics dcaTopicPhysics, RedirectAttributes redirectAttributes, Model model) {

		if (StringUtils.isNotEmpty(dcaTopicPhysics.getTableName())) {
			tableList.setTableName(dcaTopicPhysics.getTableName());
		}

		tableList.setTableComment(dcaTopicPhysics.getTableComment());

		// 物理表校验(表名格式，字段属性信息合法性)
		Map<String, Object> checkError = checkData();

		boolean failFlag = false;

		// 错误信息
		String errorMsg = "";

		// 物理表校验-存在非法格式的场合
		if (checkError != null && checkError.size() > 0) {

			failFlag = true;

			// 错误信息获取
			errorMsg = checkError.get(Constant.ERROR_MSG).toString();
		} else {

			// 执行sql，创建物理表
			Map<String, Object> sqlError = createTable();

			// sql执行异常处理的信息
			if (sqlError != null && sqlError.size() > 0) {

				failFlag = true;

				// 错误信息获取
				errorMsg = sqlError.get(Constant.ERROR_MSG).toString();

			}
		}

		// 保存失败的场合
		if (failFlag) {
			addMessage(redirectAttributes, errorMsg);
			for (DcaTopicPhysicsFields item : tableList.getColumnList()) {
				changeToShow(item);
			}
			model.addAttribute("dcaTopicPhysics", tableList);

			return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicPhysics/form?repage";
		}

		addMessage(redirectAttributes, "物理表保存成功！");

		tableList = new DcaTopicPhysics();
		columnList = new ArrayList<>();

		return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicPhysics/list?repage";
	}

	/**
	 * 物理表的字段保存处理
	 * 
	 * @param dcaTopicPhysics 物理表
	 * @return dcaTopicPhysics
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "columnAdd")
	public String columnAdd(DcaTopicPhysics dcaTopicPhysics, RedirectAttributes redirectAttributes, Model model) {

		// 主键list
		List<String> primaryKeyList = new ArrayList<>();

		// 唯一约束list
		List<String> uniqueList = new ArrayList<>();

		// 输入项目校验
		Map<String, Object> errorList = checkColumnData(dcaTopicPhysics.getCurrentFiled(), primaryKeyList, uniqueList);

		// false：存在非法项目（不添加）、字段编辑（字段行覆盖），true：添加新字段行
		boolean flag = true;

		// 存在非法格式的场合
		if (errorList.size() > 0) {

			addMessage(redirectAttributes, errorList.get(Constant.ERROR_MSG).toString());
			flag = false;
		} else {

			for (int i = 0; i < columnList.size(); i++) {

				DcaTopicPhysicsFields topicPhysicsField = dcaTopicPhysics.getCurrentFiled();

				// 编辑的场合-确认相同字段
				if (columnList.get(i).getColumnName().equals(topicPhysicsField.getColumnName())) {

					flag = false;

					// 进行覆盖处理
					columnList.set(i, topicPhysicsField);
				}
			}
		}

		// 新建的场合
		if (flag) {

			columnList.add(dcaTopicPhysics.getCurrentFiled());

			DcaTopicPhysicsFields dcaTopicPhysicsFields = new DcaTopicPhysicsFields();
			dcaTopicPhysicsFields.setIsNull(Constant.RADIO_YES);
			dcaTopicPhysicsFields.setColumnKey(Constant.RADIO_NO);
			dcaTopicPhysicsFields.setIsOnly(Constant.RADIO_NO);

			// 清空字段输入项内容
			tableList.setCurrentFiled(dcaTopicPhysicsFields);
		}

		// 物理表英文名
		if (StringUtils.isNotEmpty(dcaTopicPhysics.getTableName())) {
			tableList.setTableName(dcaTopicPhysics.getTableName());
		}

		// 物理表中文名
		tableList.setTableComment(dcaTopicPhysics.getTableComment());

		// 物理表的所有字段信息（table展示用）
		tableList.setColumnList(columnList);
		model.addAttribute("dcaTopicPhysics", tableList);

		return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicPhysics/form?repage";
	}

	/**
	 * 物理表的字段编辑处理
	 * 
	 * @return dcaTopicPhysics
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "columnEdit")
	public String columnEdit(HttpServletRequest request, RedirectAttributes redirectAttributes, Model model) {

		// 物理表字段英文名
		String columnName = request.getParameter("columnName");

		// 遍历找到对应list，取得的字段信息返回到DcaTopicPhysicsFields中
		if (StringUtils.isNotEmpty(columnName)) {

			if (CollectionUtils.isNotEmpty(columnList)) {

				for (int i = 0; i < columnList.size(); i++) {

					if (columnName.equals(columnList.get(i).getColumnName())) {

						// 编辑信息设置（影射到字段定义区域）
						tableList.setCurrentFiled(columnList.get(i));

						tableList.setColumnList(columnList);
						model.addAttribute("dcaTopicPhysics", tableList);

						return "modules/dca/dcaTopicPhysicsForm";
					}
				}
			}
		} else {

			tableList.setColumnList(columnList);
			model.addAttribute("dcaTopicPhysics", tableList);
			addMessage(redirectAttributes, "修改失败！");
		}
		return "modules/dca/dcaTopicPhysicsForm";
	}

	/**
	 * 物理表的字段删除处理
	 * 
	 * @return dcaTopicPhysics
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "columnDelete")
	public String columnDelete(HttpServletRequest request, RedirectAttributes redirectAttributes, Model model) {

		// 物理表字段英文名
		String columnName = request.getParameter("columnName").trim();

		// 字段英文名非空的场合，删除对应的字段信息
		if (StringUtils.isNotEmpty(columnName)) {

			if (CollectionUtils.isNotEmpty(columnList)) {

				for (int i = 0; i < columnList.size(); i++) {

					// 判断唯一标示（字段英文名），确定删除字段位置
					if (columnName.equals(columnList.get(i).getColumnName())) {

						columnList.remove(i);
						tableList.setColumnList(columnList);
						DcaTopicPhysicsFields dcaTopicPhysicsFields = new DcaTopicPhysicsFields();
						dcaTopicPhysicsFields.setIsNull(Constant.RADIO_YES);
						dcaTopicPhysicsFields.setColumnKey(Constant.RADIO_NO);
						dcaTopicPhysicsFields.setIsOnly(Constant.RADIO_NO);

						// 清空字段输入项内容
						tableList.setCurrentFiled(dcaTopicPhysicsFields);
						model.addAttribute("dcaTopicPhysics", tableList);
						addMessage(redirectAttributes, "删除成功！");
					}
				}
			}

		} else {

			tableList.setColumnList(columnList);
			model.addAttribute("dcaTopicPhysics", tableList);
			addMessage(redirectAttributes, "删除失败！");
		}

		return "modules/dca/dcaTopicPhysicsForm";
	}

	/**
	 * 验证物理表的属性是否合法
	 * 
	 * @return error 错误信息
	 */
	public Map<String, Object> checkData() {

		Map<String, Object> error = Maps.newHashMap();

		// 校验表信息
		Map<String, Object> errorTable = checkTableData();

		if (errorTable != null && errorTable.size() > 0) {

			// 错误信息取得
			error.put(Constant.ERROR_MSG, errorTable.get(Constant.ERROR_MSG));
		}

		// 主键list
		List<String> primaryKeyList = new ArrayList<>();
		// 唯一约束list
		List<String> uniqueList = new ArrayList<>();

		// 校验字段信息
		for (DcaTopicPhysicsFields item : tableList.getColumnList()) {

			Map<String, Object> errorColumn = checkColumnData(item, primaryKeyList, uniqueList);

			if (errorColumn != null && errorColumn.size() > 0) {

				// 错误信息取得
				error.put(Constant.ERROR_MSG, errorColumn.get(Constant.ERROR_MSG));
				return error;
			}

		}

		if (CollectionUtils.isEmpty(primaryKeyList)) {

			// 错误信息取得
			error.put(Constant.ERROR_MSG, "创建失败:物理表至少存在一个主键");
			return error;
		}

		if (CollectionUtils.isNotEmpty(uniqueList) && uniqueList.size() > 32) {

			// 错误信息取得
			error.put(Constant.ERROR_MSG, "创建失败:物理表唯一约束最好为32个  ");
			return error;
		}

		return error;
	}

	/**
	 * 数据库链接配置
	 * 
	 * @return 连接
	 */
	public static Connection getConnection() {
		Connection con = null;
		try {

			// 加载驱动
			Class.forName(Global.getConfig("jdbc.driver"));
			java.sql.DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
			String url = Global.getConfig("jdbc.url");
			String user = Global.getConfig("jdbc.username");// 数据库用户名
			String password = Global.getConfig("jdbc.password");// 数据库密码
			con = java.sql.DriverManager.getConnection(url, user, password);
		} catch (ClassNotFoundException e) {

			e.printStackTrace();
		} catch (SQLException e) {

			e.printStackTrace();
		}
		return con;
	}

	/**
	 * 判断字段名称在表中是否存在
	 * 
	 * @return 校验结果
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "checkColumnName")
	@ResponseBody
	public String getColumnNameByCon(HttpServletRequest request) {

		String columnName = request.getParameter("name");
		String existFlag = Constant.STRING_FALSE;

		for (DcaTopicPhysicsFields item : columnList) {

			if (item.getColumnName().equals(columnName)) {

				existFlag = Constant.STRING_TRUE;
				break;
			}
		}

		return existFlag;
	}

	/**
	 * 判断新建表名在数据库中表名是否存在
	 * 
	 * @return existFlag
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:edit")
	@RequestMapping(value = "checkTableName")
	@ResponseBody
	public String checkTableName(HttpServletRequest request) {
		Map<String,Object> resultMap = new HashMap<>();

		String tableName = request.getParameter("name");

		String existFlag = Constant.STRING_FALSE;
		if (StringUtils.isNotEmpty(tableName)) {
			Connection con = getConnection();
			try {
				Statement smt = con.createStatement();
				String countSql = "SELECT COUNT(1) dataCount FROM " + tableName;
				ResultSet resultSet = smt.executeQuery(countSql);
				long dataCount = 0;
				if (resultSet.next()) {
					dataCount = resultSet.getLong("dataCount");
				}
				//判断物理表中是否存在数据
				if(dataCount == 0){
					//物理表中不存在数据
					resultMap.put("hasData",Constant.STRING_FALSE);
				} else {
					//物理表中存在数据
					resultMap.put("hasData",Constant.STRING_TRUE);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			// 编辑的场合
			if (tableName.equals(tableList.getOldTableName())) {
				resultMap.put("existFlag",existFlag);
				return JsonMapper.nonDefaultMapper().toJson(resultMap);
				// 新建的场合
			} else {

				DcaTopicPhysics res = dcaTopicPhysicsService.get(tableName);

				// 判断物理表是否存在
				if (res != null && StringUtils.isNotEmpty(res.getTableName())) {

					// 物理表存在
					existFlag = Constant.STRING_TRUE;
				}
			}
		}
		resultMap.put("existFlag",existFlag);
		return JsonMapper.nonDefaultMapper().toJson(resultMap);
	}

	/**
	 * 物理表名称验证
	 * 
	 * @return mapHash 错误信息
	 */
	public Map<String, Object> checkTableData() {

		Map<String, Object> mapHash = Maps.newHashMap();

		// 物理表英文名
		String tableName = tableList.getTableName();

		// 物理表中文名
		String tableComment = tableList.getTableComment();

		// 物理表英文名验证
		if (StringUtils.isNotEmpty(tableName.trim())) {

			// 校验表名是否是DCA_PHY_开头
			if (!tableName.toUpperCase().startsWith(Constant.TABLE_START)) {

				mapHash.put(Constant.ERROR_MSG, "创建失败:物理表英文名必须以'DCA_PHY_'开头！");
				return mapHash;
			}

			// 判断长度(不能超过25个字符)
			if (tableName.length() > 25) {

				mapHash.put(Constant.ERROR_MSG, "创建失败:物理表英文名长度不能超过25位！");
				return mapHash;
			}

			// 校验表名是否只含有字母和下划线
			Pattern pt = Pattern.compile("[0-9A-Za-z_]*");
			Matcher mt = pt.matcher(tableName);
			if (!mt.matches()) {

				mapHash.put(Constant.ERROR_MSG, "创建失败:物理表英文名必须只允许字母、数字、下划线！");
				return mapHash;
			}

		} else {

			mapHash.put(Constant.ERROR_MSG, "创建失败:物理表英文名不能为空！");
			return mapHash;
		}

		// 物理表中文名验证
		if (StringUtils.isNotEmpty(tableComment.trim())) {

			// 判断长度(不能超过25个字符)
			if (tableComment.length() > 25) {

				mapHash.put(Constant.ERROR_MSG, "创建失败:物理表(中文名)长度最大25个字符！");
				return mapHash;
			}
		}

		return mapHash;
	}

	/**
	 * 创建新表
	 * 
	 * @return 错误信息map
	 */
	public Map<String, Object> createTable() {

		Map<String, Object> mapHash = Maps.newHashMap();

		Connection con = getConnection();

		// 创建表的sql语句
		StringBuilder createSql = new StringBuilder();

		createSql.append("CREATE TABLE ");
		createSql.append(tableList.getTableName());
		createSql.append(" (");

		// 创建表的注释的sql语句
		StringBuilder commentStr = new StringBuilder();
		// 字段注释list
		List<String> commentList = new ArrayList<>();
		// 表的默认值list
		List<String> columnDefaults = new ArrayList<>();

		// 创建表注释的sql语句
		commentStr.append("COMMENT ON TABLE ");
		commentStr.append(tableList.getTableName());
		commentStr.append(" IS ");
		commentStr.append("'");
		commentStr.append(tableList.getTableComment());
		commentStr.append("' ");
		commentList.add(commentStr.toString());

		// 表的主键对象
		StringBuilder keys = new StringBuilder();

		// 表的唯一约束对象
		StringBuilder uniques = new StringBuilder();

		// 默认项目(删除标记、建人、创建时间、更新人、更新时间、备注)
		List<String> defaultColumns = new ArrayList<>();
		defaultColumns.add(Constant.ORACLE_DEL_FLG);
		defaultColumns.add(Constant.ORACLE_CREATE_PERSON);
		defaultColumns.add(Constant.ORACLE_CREATE_DATE);
		defaultColumns.add(Constant.ORACLE_UPDATE_PERSON);
		defaultColumns.add(Constant.ORACLE_UPDATE_DATE);
		defaultColumns.add(Constant.ORACLE_REMARK);

		// 循环拼接字段的sql语句
		for (int i = 0; i < tableList.getColumnList().size(); i++) {

			// 字段属性值转译
			DcaTopicPhysicsFields item = getFieldFormat(tableList.getColumnList().get(i));

			// 默认项目不处理
			if (!defaultColumns.contains(item.getColumnName())) {

				// 单个字段属性拼接（字段名称 + 字段类型（长度）+ 是否为空 ）
				StringBuilder columnSql = new StringBuilder();

				// 单个字段comment拼接
				StringBuilder columnComment = new StringBuilder();

				// 单个字段默认值拼接
				StringBuilder columnDefault = new StringBuilder();

				// 字段名称
				columnSql.append(item.getColumnName());
				columnSql.append(" ");

				// 字段类型（长度）（number类型：1，nchar类型：2，nvarchar2类型：3，date类型：4，nclob类型：5）
				if (Constant.ORACLE_NUMBER_KEY.equals(item.getColumnType())) {

					// 字段类型
					columnSql.append(Constant.ORACLE_NUMBER);
					columnSql.append("(");
					// 字段长度
					columnSql.append(item.getDataLength());
					columnSql.append(",");
					// 小数点位数为空，默认设置长度为0
					if (StringUtils.isNotEmpty(item.getDecimalDigits())) {
						columnSql.append(item.getDecimalDigits());
					} else {
						columnSql.append(0);
					}

					columnSql.append(")");

				} else if (Constant.ORACLE_NCHAR_KEY.equals(item.getColumnType())) {

					// 字段类型
					columnSql.append(Constant.ORACLE_NCHAR);
					columnSql.append("(");
					// 字段长度
					columnSql.append(item.getDataLength());
					columnSql.append(")");

				} else if (Constant.ORACLE_NVARCHAR2_KEY.equals(item.getColumnType())) {

					// 字段类型
					columnSql.append(Constant.ORACLE_NVARCHAR2);
					columnSql.append("(");
					// 字段长度
					columnSql.append(item.getDataLength());
					columnSql.append(")");

				} else if (Constant.ORACLE_DATE_KEY.equals(item.getColumnType())) {
					// 字段类型
					columnSql.append(Constant.ORACLE_DATE);
				} else {
					// 字段类型
					columnSql.append(Constant.ORACLE_NCLOB);
				}

				// 是否为空
				if (Constant.NO.equals(item.getIsNull()) || Constant.PRIMARY_KEY.equals(item.getColumnKey())) {
					columnSql.append(" NOT NULL");
				}

				// 主键对象收集
				if (Constant.PRIMARY_KEY.equals(item.getColumnKey())) {
					keys.append(item.getColumnName());
					keys.append(",");

				}

				// 唯一约束对象收集
				if (Constant.UNIQUE.equals(item.getIsOnly())) {
					uniques.append(item.getColumnName());
					uniques.append(",");

				}

				columnSql.append(", ");

				// 字段注释sql语句据拼接（COMMENT ON COLUMN 表名.字段名 is "注释内容"）
				columnComment.append("COMMENT ON COLUMN ");
				columnComment.append(tableList.getTableName());
				columnComment.append(".");
				columnComment.append(item.getColumnName());
				columnComment.append(" IS ");
				columnComment.append("'");
				columnComment.append(item.getColumnComment());
				columnComment.append("' ");

				// 字段注释sql语句据拼接（ alter table TEST modify xxxx default xxxx;）
				if (StringUtils.isNotEmpty(item.getColDefault())) {

					columnDefault.append("ALTER TABLE ");
					columnDefault.append(tableList.getTableName());
					columnDefault.append(" MODIFY ");
					columnDefault.append(item.getColumnName());
					columnDefault.append(" DEFAULT ");
					columnDefault.append("'");
					columnDefault.append(item.getColDefault().replace("'", ""));
					columnDefault.append("' ");

					columnDefaults.add(columnDefault.toString());
				}

				// 把当前创建字段的sql语句拼接到"创建表的sql语句（createSql）"上
				createSql.append(columnSql.toString());
				// 把当前创建字段注释的sql语句拼接到"创建表注释的sql语句（createSql）"上
				commentList.add(columnComment.toString());
			}

		}

		// 默认项目添加(删除标记,创建人，创建时间，更新人，更新时间，备注)
		createSql.append(" DEL_FLAG NVARCHAR2(2),");
		createSql.append(" CREATE_PERSON NVARCHAR2(64),");
		createSql.append(" CREATE_TIME DATE,");
		createSql.append(" UPDATE_PERSON NVARCHAR2(64),");
		createSql.append(" UPDATE_TIME DATE,");
		createSql.append(" REMARK NVARCHAR2(200),");

		// 单个字段comment拼接
		for (String defaultItem : defaultColumns) {

			StringBuilder defaultComment = new StringBuilder();
			defaultComment.append("COMMENT ON COLUMN ");
			defaultComment.append(tableList.getTableName());
			defaultComment.append(".");
			defaultComment.append(defaultItem);
			defaultComment.append(" IS ");
			defaultComment.append("'");

			if (defaultItem.equals(Constant.ORACLE_CREATE_PERSON)) {
				defaultComment.append("创建人");
			} else if (defaultItem.equals(Constant.ORACLE_UPDATE_PERSON)) {
				defaultComment.append("更新者");
			} else if (defaultItem.equals(Constant.ORACLE_CREATE_DATE)) {
				defaultComment.append("创建时间");
			} else if (defaultItem.equals(Constant.ORACLE_UPDATE_DATE)) {
				defaultComment.append("更新时间");
			} else if (defaultItem.equals(Constant.ORACLE_REMARK)) {
				defaultComment.append("备注");
			} else {
				defaultComment.append("删除标记");
			}

			defaultComment.append("' ");
			commentList.add(defaultComment.toString());
		}

		// 创建主键sql语句拼接
		createSql.append(" CONSTRAINT PK_");
		createSql.append(tableList.getTableName());
		createSql.append(" PRIMARY KEY (");
		createSql.append(keys.toString().substring(0, keys.toString().length() - 1));
		createSql.append(")");
		createSql.append(" )");

		try {
			Statement smt = con.createStatement();

			DcaTopicPhysics res = dcaTopicPhysicsService.get(tableList.getTableName());

			// 判断物理表是否存在
			if (res != null && StringUtils.isNotEmpty(res.getTableName())) {

				// 删除同名的表
				smt.executeUpdate("DROP TABLE " + res.getTableName());
			}

			// 创建物理表
			smt.executeUpdate(createSql.toString());

			// 添加表注释、字段注释
			for (String commentSQL : commentList) {

				smt.executeUpdate(commentSQL);
			}

			// 默认值设置
			for (String item : columnDefaults) {

				smt.executeUpdate(item);
			}

			if (StringUtils.isNotEmpty(uniques)) {

				String strUniques = "ALTER TABLE " + tableList.getTableName() + " add constraint "
						+ tableList.getTableName() + "_u1 " + "unique ("
						+ uniques.toString().substring(0, uniques.toString().length() - 1) + ")";

				// 添加唯一约束 uniques
				smt.executeUpdate(strUniques);
			}

		} catch (SQLException se) {
			String message = se.toString().replace("java.sql.SQLSyntaxErrorException", "创建失败:SQL异常");
			mapHash.put(Constant.ERROR_MSG, message.replace("\n", "!"));
			se.printStackTrace();
		}

		return mapHash;
	}

	/**
	 * 物理表字段信息校验
	 * 
	 * @param item 字段信息
	 * @return 错误信息
	 */
	public Map<String, Object> checkColumnData(DcaTopicPhysicsFields item, List<String> primaryKeyList,
			List<String> uniqueList) {

		Map<String, Object> map = Maps.newHashMap();

		// 判断字段(英文名)的长度(不能超过20个字符)
		if (StringUtils.isEmpty(item.getColumnName()) || item.getColumnName().length() > 20) {

			map.put(Constant.ERROR_MSG, "创建失败:字段(英文名)不能为空且长度最大20个字符！");
			return map;
		}

		// 判断字段(中文名)的长度(不能超过10个字符)
		if (StringUtils.isEmpty(item.getColumnComment()) || item.getColumnComment().length() > 10) {

			map.put(Constant.ERROR_MSG, "创建失败:字段(英文名)长度最大10个字符！");
			return map;
		}

		// 数据类型map
		Map<String, Object> typeHash = Maps.newHashMap();

		// oracle的数据类型取得
		List<DcaTopicPhysics> list = dcaTopicPhysicsService.getTypeCheck(Constant.ORACLE_DATA_TYPE);

		// 字典表数据类型的数据获取
		if (CollectionUtils.isEmpty(list)) {

			map.put(Constant.ERROR_MSG, "创建失败:字典表数据类型异常！");
			return map;

		} else {
			for (DcaTopicPhysics type : list) {

				typeHash.put(type.getDbType(), type.getTypeValue());

			}
		}

		String type = typeHash.get(item.getColumnType()).toString();

		// 判断数据类型
		if (StringUtils.isNotEmpty(type)) {

			// number类型
			if (Constant.ORACLE_NUMBER.equals(type)) {

				// 校验设定数据长度
				if (StringUtils.isNotEmpty(item.getDecimalDigits())) {

					// 字符长度
					int length = Integer.parseInt(item.getDataLength());

					// 小数点位数
					int digitsLength = Integer.parseInt(item.getDecimalDigits());

					if (!(length > 0 && length <= 13 && digitsLength <= 4 && length > digitsLength)) {

						map.put(Constant.ERROR_MSG, "创建失败:NUBMER类型的位数最大13，小数位最大4，且小数位数不能大于位数！");
						return map;
					}

					// NUMBER类型的默认值合法性校验
					if (StringUtils.isNotEmpty(item.getColDefault())) {

						// number类型的数据：number(m,0)和number(m,n)的默认值校验
						if (Integer.parseInt(item.getDecimalDigits()) == 0) {
							/* change start by geshuo 20161230: 修改类型判断 【测试缺陷 #21870】-------------- */
							// if ((Object) item.getColDefault() instanceof Integer) {
							if (isInteger(item.getColDefault())) { // 是整数
								/* change end by geshuo 20161230: 修改类型判断 【测试缺陷 #21870】-------------- */
								// 判断默认值的长度和字段的长度
								if (item.getColDefault().length() > Integer.parseInt(item.getDataLength())) {
									map.put(Constant.ERROR_MSG, "创建失败:默认值输入必须符合字段的数据类型和长度！");
									return map;
								}

							} else {
								map.put(Constant.ERROR_MSG, "创建失败:默认值输入必须符合字段的数据类型和长度！");
								return map;
							}

						} else {

							String[] date = item.getColDefault().split("\\.");

							if (date.length > 2) {

								map.put(Constant.ERROR_MSG, "创建失败:默认值输入必须符合字段的数据类型和长度！");
								return map;
							} else {

								// 默认值长度
								int defaultLength = date[0].length();
								if (date.length == 2) {
									defaultLength = date[0].length() + date[1].length();
								}

								// 默认值字符长度超长
								if (defaultLength > Integer.parseInt(item.getDataLength())) {

									map.put(Constant.ERROR_MSG, "创建失败:默认值字符长度超长");
									return map;
								} else {

									// 整数位超长
									if (date[0].length() > (length - digitsLength)) {

										map.put(Constant.ERROR_MSG, "创建失败:数值类型的整数位长度超长！");
										return map;
									} else {

										if (date.length == 2) {
											// 小数位超长
											if (date[1].length() > (length - digitsLength)) {

												map.put(Constant.ERROR_MSG, "创建失败:数值类型的小数位长度超长！");
												return map;
											}
										}
									}
								}
							}
						}
					}
				}
			} else if (Constant.ORACLE_NCHAR.equals(type) || Constant.ORACLE_NVARCHAR2.equals(type)) {

				if (StringUtils.isEmpty(item.getDataLength()) || Integer.parseInt(item.getDataLength()) > 2000) {

					map.put(Constant.ERROR_MSG, "创建失败:字段类型(VARCHAR2或NVARCHAR)值不能为空且不大于2000字符");
					return map;
				} else {

					// 默认值合法性
					if (StringUtils.isNotEmpty(item.getColDefault())
							&& !Constant.STRING_NULL.equals(item.getColDefault())) {

						if (item.getColDefault().length() > Integer.parseInt(item.getDataLength())) {
							map.put(Constant.ERROR_MSG, "创建失败:默认值输入必须符合字段的数据类型和长度！");
							return map;
						}
					}
				}
			}

		} else {
			map.put(Constant.ERROR_MSG, "创建失败:字段的数据类型不能为空！");
			return map;
		}

		// 是否为主键
		if (Constant.RADIO_YES.equals(item.getColumnKey())) {

			primaryKeyList.add(item.getColumnKey());
		}

		// 是否为唯一约束
		if (Constant.RADIO_YES.equals(item.getIsOnly())) {

			uniqueList.add(item.getIsOnly());
		}

		return map;
	}

	/**
	 * 判断字符串是否是整数
	 */
	public static boolean isInteger(String value) {
		try {
			Integer.parseInt(value);
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	/**
	 * 格式转换(用于存储)
	 * 
	 */
	public DcaTopicPhysicsFields getFieldFormat(DcaTopicPhysicsFields item) {

		// 字段名称大写转换
		if (StringUtils.isNotEmpty(item.getColumnName())) {

			item.setColumnName(item.getColumnName().toUpperCase());
		}

		// 唯一约束转换（u：是，"":否 ）
		if (Constant.RADIO_YES.equals(item.getIsOnly())) {

			item.setIsOnly(Constant.UNIQUE);
		} else {

			item.setIsOnly(Constant.BLANK);
		}
		// 非空转换（1：是，0:否 ）
		if (Constant.RADIO_YES.equals(item.getIsNull())) {

			item.setIsNull(Constant.YES);
		} else {

			item.setIsNull(Constant.NO);
		}
		// 主键转换（1：是，0:否 ）
		if (Constant.RADIO_YES.equals(item.getColumnKey())) {

			item.setColumnKey(Constant.PRIMARY_KEY);
		} else {

			item.setColumnKey(Constant.BLANK);
		}

		// 默认值
		if (StringUtils.isNotEmpty(item.getColDefault())) {

			if (item.getColDefault().equals(Constant.STRING_NULL)) {
				item.setColDefault("");
			}
		}

		return item;
	}

	/**
	 * 格式转换(用于显示)
	 * 
	 */
	public DcaTopicPhysicsFields changeToShow(DcaTopicPhysicsFields item) {

		// 唯一约束转换（u：是，"":否 ）
		if (Constant.UNIQUE.equals(item.getIsOnly())) {

			item.setIsOnly(Constant.RADIO_YES);
		} else {

			item.setIsOnly(Constant.RADIO_NO);
		}
		// 是否可空（y：是，"":否 ）
		if (Constant.YES.equals(item.getIsNull())) {

			item.setIsNull(Constant.RADIO_YES);
		} else {

			item.setIsNull(Constant.RADIO_NO);
		}
		// 是否主键（p：是，"":否 ）
		if (Constant.PRIMARY_KEY.equals(item.getColumnKey())) {

			item.setColumnKey(Constant.RADIO_YES);
		} else {

			item.setColumnKey(Constant.RADIO_NO);
		}

		// 数据类型转换（number类型：1，nchar类型：2，nvarchar2类型：3，date类型：4，nclob类型：5）
		if (Constant.ORACLE_NUMBER.equals(item.getColumnType())) {

			item.setColumnType(Constant.ORACLE_NUMBER_KEY);
		} else if (Constant.ORACLE_NCHAR.equals(item.getColumnType())) {

			item.setColumnType(Constant.ORACLE_NCHAR_KEY);
		} else if (Constant.ORACLE_NVARCHAR2.equals(item.getColumnType())) {

			item.setColumnType(Constant.ORACLE_NVARCHAR2_KEY);
		} else if (Constant.ORACLE_DATE.equals(item.getColumnType())) {

			item.setColumnType(Constant.ORACLE_DATE_KEY);
		} else if (Constant.ORACLE_NCLOB.equals(item.getColumnType())) {

			item.setColumnType(Constant.ORACLE_NCLOB_KEY);
		}

		// 默认值(值为空,台获取不到对象)
		if (StringUtils.isEmpty(item.getColDefault())) {

			item.setColDefault(Constant.STRING_NULL);
		} else {
			item.setColDefault(item.getColDefault().replace("'", ""));
		}

		// 字段comment(值为空,台获取不到对象)
		if (StringUtils.isEmpty(item.getColumnComment())) {

			item.setColumnComment(Constant.STRING_NULL);
		}

		return item;
	}
}