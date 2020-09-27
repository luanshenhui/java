package cn.rkylin.core.controller;

import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.mapping.ResultMap;
import org.apache.ibatis.mapping.ResultMapping;
import org.apache.ibatis.session.Configuration;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.formula.functions.T;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

import cn.rkylin.apollo.common.util.BeanToMapUtil;
import cn.rkylin.apollo.common.util.CheckUtil;
import cn.rkylin.apollo.common.util.ExportExcelFileUtil;
import cn.rkylin.apollo.common.util.ExportExcelSheet;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.ApolloUtil;
import cn.rkylin.core.SessionFactory;
import cn.rkylin.core.controller.vo.FormSelectVO;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.core.utils.LogUtils;
import cn.rkylin.oms.common.context.WebContextFactory;
import cn.rkylin.oms.common.export.IExport;

@Controller
@RequestMapping("/core")
public class ApolloController extends AbstractController implements InitializingBean {
	protected static final String RECORDS_TOTAL = "recordsTotal";
	protected static final String RECORDS_FILTERED = "recordsFiltered";
	protected static final String RETURN_DATA = "data";
	protected static final String JSON_MSG = "msg";
	protected static final String JSON_RESULT = "result";
	protected static final String FAILED = "failed";
	protected static final String SUCCESS = "success";
	protected static final String VALUE_NO = "n";
	protected static final String VALUE_YES = "y";
	protected static final int LEFT_ADD_SEPARATOR = 0;
	protected static final int RIGHT_ADD_SEPARATOR = 1;
	protected static final int ROUND_ADD_SEPARATOR = 3;

	private static Logger logger = Logger.getLogger(LogUtils.LOG_BOSS);

	@Autowired
	private SessionFactory sessionFactory;

	@Autowired
	private ApolloService commonService;
	// 提供导出功能的服务
	private IExport exportService;

	/**
	 * 查询index数据(默认不支持分页)
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping("/getData")
	@ResponseBody
	public List getData(HttpServletRequest request) throws Exception {
		String uuid = (String) request.getAttribute("uuid");
		LogUtils.info(logger, uuid, "【进入CommonController的getData方法中】");
		Map<String, Object> params = this.getParamMap(request);
		LogUtils.info(logger, uuid, "【请求入参】：", "inputParam", params);
		List list = commonService.findForList(params);
		LogUtils.info(logger, uuid, "【出参】：", "outputParam", list);
		/*
		 * //异常跳转 String s = null; s.charAt(1);
		 */
		return list;
	}

	/**
	 * 查询分业数据 (pageSize,pageNo.index 必传)
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping("/getPage")
	@ResponseBody
	public Map getPage(@RequestParam(required = false, defaultValue = "1") int page,
			@RequestParam(required = false, defaultValue = "20") int rows, HttpServletRequest request)
			throws Exception {
		Map<String, Object> params = this.getParamMap(request);
		return commonService.findByPage(page, rows, params);
	}

	public String getKeyName(Map<String, Object> params, String key) {
		String keyName = "";
		if (null != params.get("downFields") && !"".equals(params.get("downFields"))) {
			String downFields = params.get("downFields") + "";
			String[] downFieldsList = downFields.split("\\|");
			for (int i = 0; i < downFieldsList.length; i++) {
				String tempStr = downFieldsList[i];
				String[] tempStrList = tempStr.split("\\:");
				if (null != tempStrList && tempStrList.length > 0) {
					if (key.equals(tempStrList[0])) {
						keyName = tempStrList[1];
						break;
					} else {
						keyName = tempStrList[0];
					}
				}
			}
		}
		return keyName;
	}

	/**
	 * 根据模块statement拼装该模块的order by子句内容（未仔细测试）
	 * 
	 * @param request
	 *            前台的请求对象。
	 * @param sqlMapperNamespace
	 *            该sqlmap的命名空间
	 * @param sqlMapperStatement
	 *            sqlmapper文件中的statement。（任意指定一个有的即可）
	 * @param replaceFieldsMap
	 *            由于展示需要，前台的字段名与数据库字段名的转换关系。
	 * @return 排序语句
	 * @throws Exception
	 */
	protected String getOrderString(String sqlMapperNamespace, String sqlMapperStatement,
			Map<String, String> replaceFieldsMap) throws Exception {
		return getOrderString(sqlMapperNamespace, sqlMapperStatement,
				replaceFieldsMap, "BaseResultMap");
	}

	/**
	 * 根据模块statement拼装该模块的order by子句内容（未仔细测试）
	 * 
	 * @param request
	 *            前台的请求对象。
	 * @param sqlMapperNamespace
	 *            该sqlmap的命名空间
	 * @param sqlMapperStatement
	 *            sqlmapper文件中的statement。（任意指定一个有的即可）
	 * @param replaceFieldsMap
	 *            由于展示需要，前台的字段名与数据库字段名的转换关系。
	 * @return 排序语句
	 * @throws Exception
	 */
	protected String getOrderString(String sqlMapperNamespace, String sqlMapperStatement,
			Map<String, String> replaceFieldsMap, String mapName) throws Exception {
		StringBuffer returnValue = new StringBuffer();
		boolean orderFlag = true;

		HttpServletRequest request = WebContextFactory.getWebContext().getRequest();
		for (int i = 0; orderFlag; i++) {
			// 排序的列号
			String order = request.getParameter("order[" + i + "][column]");
			// 排序的顺序asc or desc
			String orderDir = request.getParameter("order[" + i + "][dir]");
			// 排序的列名
			String orderColumn = request.getParameter("columns[" + order + "][data]");

			if (StringUtils.isEmpty(order) || StringUtils.isEmpty(orderDir) || StringUtils.isEmpty(orderColumn)) {
				orderFlag = false;
			} else {
				// 处理转义字段
				if (replaceFieldsMap != null && replaceFieldsMap.size() > 0) {
					for (String replaceItem : replaceFieldsMap.keySet()) {
						if (orderColumn.equals(replaceItem)) {
							orderColumn = replaceFieldsMap.get(orderColumn);
						}
					}
				}

				Configuration conf = sessionFactory.getSessionFactory(ApolloUtil.CONN_MAP.get(sqlMapperStatement))
						.getConfiguration();
				// 取得Configuration ,获取到对应的resultMap
				ResultMap map = conf.getResultMap(sqlMapperNamespace + "."+mapName);
				List<ResultMapping> mapping = map.getResultMappings();
				for (ResultMapping mp : mapping) {
					if (mp.getProperty().equals(orderColumn)) {
						returnValue.append(mp.getColumn() + " " + orderDir + ",");
						break;
					}
				}
			}
		}
		int lastComma = returnValue.toString().lastIndexOf(",");
		if (lastComma < 0) {
			return "";
		} else {
			return returnValue.toString().substring(0, lastComma);
		}
	}
	
	protected IExport getExportService() {
		return exportService;
	}

	protected void setExportService(IExport exportService) {
		this.exportService = exportService;
	}

	/**
	 * 具体controller根据情况重写此方法
	 */
	@Override
	public void afterPropertiesSet() throws Exception {
	}

	/**
	 * 对画面form的项目进行check
	 * 
	 * @param formSelectVO
	 * @return
	 */
	private boolean checkFormJson(FormSelectVO formSelectVO) {
		boolean result = true;
		// 如果是没有值得场合，就不作为检索条件，不需要做check
		if (formSelectVO == null || StringUtils.isBlank(formSelectVO.getValue())) {
			return true;
		}
		if ("in".equals(formSelectVO.getOperator()) || "notin".equals(formSelectVO.getOperator())) {
			String[] temp = formSelectVO.getValue().split(",");
			if (temp != null && temp.length > 0) {
				for (int i = 0; i < temp.length; i++) {
					if ("dateTime".equals(formSelectVO.getType())) {
						if (StringUtils.isNotBlank(temp[i]) && !CheckUtil.isValidDate(temp[i])) {
							result = false;
							break;
						}
					} else if ("int".equals(formSelectVO.getType())) {
						if (StringUtils.isNotBlank(temp[i]) && !CheckUtil.isInteger(temp[i])) {
							result = false;
							break;
						}
					} else if ("float".equals(formSelectVO.getType())) {
						if (StringUtils.isNotBlank(temp[i]) && !CheckUtil.isFloat(temp[i])) {
							result = false;
							break;
						}
					} else {
						result= true;
					}
				}
			} else {
				return true;
			}
		} else {
			if ("dateTime".equals(formSelectVO.getType())) {
				result = CheckUtil.isValidDate(formSelectVO.getValue());
			} else if ("int".equals(formSelectVO.getType())) {
				result = CheckUtil.isInteger(formSelectVO.getValue());
			} else if ("float".equals(formSelectVO.getType())) {
				result = CheckUtil.isFloat(formSelectVO.getValue());
			} else {
				result= true;
			}
		}
		return result;
	}

	/**
	 * 验证需要导出的条件
	 * 
	 * @param quickSearch
	 *            快速查询条件
	 * @param colName
	 *            需要导出的项目名称
	 * @param colValue
	 *            需要导出的项目的字段名称
	 * @return 返回值JSON格式字符串
	 */
	@ResponseBody
	@RequestMapping(value = "/exportCheck")
	public Map<String, Object> exportCheck(String colName, String colValue, String formJson) throws Exception {
		Map<String, Object> returnJSON = new HashMap<String, Object>();
		List<FormSelectVO> returnList = new ArrayList<FormSelectVO>();
		try {
			colName = URLDecoder.decode(colName, "UTF-8");
			colValue = URLDecoder.decode(colValue, "UTF-8");
			String[] colNameArry = colName.split(",");
			String[] colValueArry = colValue.split(",");
			if (exportService == null) {
				returnJSON.put(JSON_RESULT, FAILED);
				returnJSON.put(JSON_MSG, "系统错误");
			} else if (StringUtils.isBlank(colName) || StringUtils.isBlank(colValue)) {
				returnJSON.put(JSON_RESULT, FAILED);
				returnJSON.put(JSON_MSG, "请选择导出项目");
			} else if (colNameArry.length != colValueArry.length) {
				returnJSON.put(JSON_RESULT, FAILED);
				returnJSON.put(JSON_MSG, "选择导出项目有误");
			} else {
				// 高级检索条件的类型check
				formJson = URLDecoder.decode(formJson, "UTF-8");
				if (StringUtils.isNotBlank(formJson)) {
					List<FormSelectVO> list = new ArrayList<FormSelectVO>();
					list = JSONObject.parseArray(formJson, FormSelectVO.class);
					if (list != null && list.size() > 0) {
						for (int i = 0; i < list.size(); i++) {
							FormSelectVO formSelectVO = (FormSelectVO) list.get(i);
							if (StringUtils.isNotBlank(formSelectVO.getValue())
									|| (("in".equals(formSelectVO.getOperator1())
											|| "notin".equals(formSelectVO.getOperator1()))
											&& StringUtils.isNotBlank(formSelectVO.getValue().replace(",", "")))) {
								if (!checkFormJson(formSelectVO)) {
									returnJSON.put(JSON_RESULT, FAILED);
									returnJSON.put(JSON_MSG,
											formSelectVO.getName() + "项目提交的值（" + formSelectVO.getValue() + "）有问题");
								} else {
									// 去掉空值的数据，重新生成json给真正的检索用
									returnList.add(formSelectVO);
								}
							}
						}
					}
				}

				// 上述check都没有错误的场合
				if (returnJSON.get(JSON_RESULT)==null) {
					returnJSON.put(JSON_RESULT, SUCCESS);
					returnJSON.put("formJson",
							JSONObject.toJSONString(returnList, SerializerFeature.WriteMapNullValue));
				}
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			returnJSON.put(JSON_RESULT, FAILED);
			returnJSON.put(JSON_MSG, ex.getMessage());
		}
		return returnJSON;
	}

	/**
	 * 导出店铺ajax
	 * 
	 * @param quickSearch
	 *            快速查询条件
	 * @param colName
	 *            需要导出的项目名称
	 * @param colValue
	 *            需要导出的项目的字段名称
	 * @param response
	 *            导出文件的时候返回文件流用
	 * @return 返回值JSON格式字符串
	 */
	@ResponseBody
	@RequestMapping(value = "/export")
	public String exportExcel(String quickSearch, String colName, String colValue, String exportStatement,
			String formJson, @RequestParam(required = false)String fileName)
			throws Exception {
		try {
			ApolloMap<String, Object> params = new ApolloMap<String, Object>();
			params.put(ApolloUtil.INDEX_PARAM, exportStatement);
			quickSearch = URLDecoder.decode(quickSearch, "UTF-8");

			colName = URLDecoder.decode(colName, "UTF-8");
			colValue = URLDecoder.decode(colValue, "UTF-8");
			String[] colNameArry = colName.split(",");
			String[] colValueArry = colValue.split(",");

			if (StringUtils.isBlank(fileName)) {
				fileName = "Export";
			} else {
				fileName = URLDecoder.decode(fileName, "UTF-8");
			}

			if (StringUtils.isBlank(colName) || StringUtils.isBlank(colValue)) {
				return null;
			}

			if (colNameArry.length != colValueArry.length) {
				return null;
			}

			// 高级检索条件的类型check
			formJson = URLDecoder.decode(formJson, "UTF-8");
			if (StringUtils.isNotBlank(formJson)) {
				List<FormSelectVO> list = new ArrayList<FormSelectVO>();
				list = JSONObject.parseArray(formJson, FormSelectVO.class);
				if (list != null && list.size() > 0) {
					for (int i = 0; i < list.size(); i++) {
						FormSelectVO formSelectVO = (FormSelectVO) list.get(i);
						if (!checkFormJson(formSelectVO)) {
							return null;
						}
					}
				}
			}

			// 获取数据
			Map<String, String> select = new HashMap<String, String>();
			select.put("value", quickSearch);
			select.put("selectWhere", getSearchCondition(formJson));
			List<T> resultList = exportService.execExport(exportStatement, select);

			Workbook xs = new HSSFWorkbook();

			if (colNameArry != null && colNameArry.length > 0 && colValueArry != null && colValueArry.length > 0) {

				// 设置sheet内容
				ExportExcelSheet exportExcelSheet = new ExportExcelSheet();
				// 如果是VO的话需要转黄成为MAP形式 结果集set
				exportExcelSheet.setListRow(new BeanToMapUtil().convertListBean2ListMap(resultList));
				// 导出项目单元格的属性设置
				exportExcelSheet.setListTitle(colName, colValue);
				// 设置要导出的sheet
				Map<String, ExportExcelSheet> exportExcelMap = new HashMap<String, ExportExcelSheet>();
				// sheet页名称，以及对应的sheet内容
				exportExcelMap.put("sheet", exportExcelSheet);

				xs = ExportExcelFileUtil.exportData(exportExcelMap, fileName + ".xls");
			}
			HttpServletResponse response = WebContextFactory.getWebContext().getResponse();
			OutputStream out = response.getOutputStream();
			String mimetype = "application/x-msdownload";
			response.setContentType(mimetype);
			String inlineType = "attachment"; // 是否内联附件
			response.setHeader("Content-Disposition", inlineType + ";filename=\"" + new String(fileName.getBytes(),"iso-8859-1") + ".xls" + "\"");
			xs.write(out);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/**
	 * 根据前台传递的高级检索的json对象动态生成SQL的检索条件语句
	 * 
	 * @param formJson
	 * @return
	 */
	private String getSearchCondition(String formJson) {
		StringBuilder sql = new StringBuilder();
		if (StringUtils.isNotBlank(formJson)) {
			List<FormSelectVO> list = JSONObject.parseArray(formJson, FormSelectVO.class);
			if (list != null && list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					FormSelectVO formSelectVO = (FormSelectVO) list.get(i);
					// 如果是没有值得场合，就不作为检索条件
					if (formSelectVO != null && StringUtils.isNotBlank(formSelectVO.getValue())) {
						// in/not in的场合特殊处理
						if ("in".equals(formSelectVO.getOperator()) || "notin".equals(formSelectVO.getOperator())) {
							// 拼接and or
							sql.append(
									addSeparator(addSeparator(formSelectVO.getOperator1(), " (", RIGHT_ADD_SEPARATOR),
											" ", LEFT_ADD_SEPARATOR));
							sql.append(getFieldOperator(formSelectVO.getOperator(), formSelectVO.getValue(),
									formSelectVO.getType(), formSelectVO.getField()));
							sql.append(")");
						} else {
							// 拼接and or
							sql.append(addSeparator(formSelectVO.getOperator1(), " ", LEFT_ADD_SEPARATOR));
							// 拼接字段
							sql.append(addSeparator(formSelectVO.getField(), " ", LEFT_ADD_SEPARATOR));
							// 拼接字段运算符
							sql.append(addSeparator(getFieldOperator(formSelectVO.getOperator(),
									formSelectVO.getValue(), formSelectVO.getType()), " ", LEFT_ADD_SEPARATOR));
						}
					}
				}
			}
		}
		return sql.toString();
	}

	/**
	 * 拼接字段运算符
	 * 
	 * @param operator
	 *            字段运算符
	 * @param value
	 *            字段的值
	 * @param type
	 *            字段值的数据类型
	 * @param colum
	 *            字段名称，in/not in转换成为 or/and的时候用
	 * @return
	 */
	private String getFieldOperator(String operator, String value, String type, String colum) {
		StringBuilder temp = new StringBuilder();
		String[] arryValue = value.split(",");

		if ("in".equals(operator)) { // in
			for (int i = 0; i < arryValue.length; i++) {
				if (i > 0) {
					temp.append(" or ");
				}
				temp.append(addSeparator(colum, "=", RIGHT_ADD_SEPARATOR));
				if ("int".equals(type) || "float".equals(type)) {
					temp.append(arryValue[i]);
				} else {
					temp.append(addSeparator(arryValue[i], "'", ROUND_ADD_SEPARATOR));
				}
			}
		} else if ("notin".equals(operator)) { // not in
			for (int i = 0; i < arryValue.length; i++) {
				if (i > 0) {
					temp.append("and");
				}
				temp.append(addSeparator(colum, "<>", RIGHT_ADD_SEPARATOR));
				if ("int".equals(type) || "float".equals(type)) {
					temp.append(arryValue[i]);
				} else {
					temp.append(addSeparator(arryValue[i], "'", ROUND_ADD_SEPARATOR));
				}
			}
		}

		return temp.toString();
	}

	/**
	 * 拼接字段运算符
	 * 
	 * @param operator
	 *            字段运算符
	 * @param value
	 *            字段的值
	 * @param type
	 *            字段值的数据类型
	 * @return
	 */
	private String getFieldOperator(String operator, String value, String type) {
		StringBuilder temp = new StringBuilder();

		if ("eq".equals(operator)) { // 等于
			if ("int".equals(type) || "float".equals(type)) {
				temp.append(addSeparator(value, " =", LEFT_ADD_SEPARATOR));
			} else {
				temp.append(addSeparator(addSeparator(value, "'", ROUND_ADD_SEPARATOR), " =", LEFT_ADD_SEPARATOR));
			}
		} else if ("neq".equals(operator)) { // 不等于
			if ("int".equals(type) || "float".equals(type)) {
				temp.append(addSeparator(value, " <>", LEFT_ADD_SEPARATOR));
			} else {
				temp.append(addSeparator(addSeparator(value, "'", ROUND_ADD_SEPARATOR), " <>", LEFT_ADD_SEPARATOR));
			}
		} else if ("gt".equals(operator)) { // 大于
			if ("int".equals(type) || "float".equals(type)) {
				temp.append(addSeparator(value, " >", LEFT_ADD_SEPARATOR));
			} else {
				temp.append(addSeparator(addSeparator(value, "'", ROUND_ADD_SEPARATOR), " >", LEFT_ADD_SEPARATOR));
			}
		} else if ("gte".equals(operator)) { // 大于等于
			if ("int".equals(type) || "float".equals(type)) {
				temp.append(addSeparator(value, " >=", LEFT_ADD_SEPARATOR));
			} else {
				temp.append(addSeparator(addSeparator(value, "'", ROUND_ADD_SEPARATOR), " >=", LEFT_ADD_SEPARATOR));
			}
		} else if ("lt".equals(operator)) { // 小于
			if ("int".equals(type) || "float".equals(type)) {
				temp.append(addSeparator(value, " <", LEFT_ADD_SEPARATOR));
			} else {
				temp.append(addSeparator(addSeparator(value, "'", ROUND_ADD_SEPARATOR), " <", LEFT_ADD_SEPARATOR));
			}
		} else if ("lte".equals(operator)) { // 小于等于
			if ("int".equals(type) || "float".equals(type)) {
				temp.append(addSeparator(value, " <=", LEFT_ADD_SEPARATOR));
			} else {
				temp.append(addSeparator(addSeparator(value, "'", ROUND_ADD_SEPARATOR), " <=", LEFT_ADD_SEPARATOR));
			}
		} else if ("llike".equals(operator)) { // like'%xxxx'
			temp.append(addSeparator(addSeparator(value, " like'%", LEFT_ADD_SEPARATOR), "'", RIGHT_ADD_SEPARATOR));
		} else if ("rlike".equals(operator)) { // like'xxxx%'
			temp.append(addSeparator(addSeparator(value, " like'", LEFT_ADD_SEPARATOR), "%'", RIGHT_ADD_SEPARATOR));
		} else if ("like".equals(operator)) { // like'%xxxx%'
			temp.append(addSeparator(addSeparator(value, " like'%", LEFT_ADD_SEPARATOR), "%'", RIGHT_ADD_SEPARATOR));
		} else {

		}

		return temp.toString();
	}

	/**
	 * 
	 * @param value
	 *            原始字符串
	 * @param separator
	 *            分隔符
	 * @param type
	 *            分隔方式 0：左分隔 1：右分隔 2：左右分隔
	 * @return
	 */
	private String addSeparator(String value, String separator, int type) {
		StringBuilder temp = new StringBuilder();
		if (StringUtils.isBlank(value)) {
			return "";
		}

		switch (type) {
		// 左分隔
		case LEFT_ADD_SEPARATOR:
			temp.append(separator);
			temp.append(value);
			break;
		// 右分隔
		case RIGHT_ADD_SEPARATOR:
			temp.append(value);
			temp.append(separator);
			break;
		// 全分隔
		case ROUND_ADD_SEPARATOR:
			temp.append(separator);
			temp.append(value);
			temp.append(separator);
			break;
		default:
			break;
		}

		return temp.toString();
	}
}
