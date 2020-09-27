package cn.rkylin.oms.system.dictionary.vo;

import java.net.URLEncoder;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.system.dictionary.domain.OMS_DICT;
import net.sf.jsqlparser.statement.replace.Replace;

public class DictVO extends OMS_DICT {
	
	/**
	* 序列
	*/
	private static final long serialVersionUID = 7261100665980740680L;
	
	/**
	* orderBy子句
	*/
	private String orderBy;
	
	/**
	* 搜索条件
	*/
	private String searchCondition;
	/**
	 * 操作
	 */
	private String operation;
	

	/**
	 * 修改前参数名称
	 */
	private String dicUpdateCode;

	/*
	 * 列表操作按钮定义
	 */
	private static final String OPERATION_BTN_EDIT = "<button onclick=\"operationEdit(\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',this)\" dictionaryID=\"%s\" type=\"button\" class=\"btn btn-info btn-xs\"><i class=\"fa fa-edit\"></i>&nbsp;修改</button>";
	
	
	public String getOperation() {
		return operation;
	}
	private static final String OPERATION_BTN_DELETE = "<button onclick=\"operationDelete(this)\" dictionaryID=\"%s\" type=\"button\" class=\"btn btn-danger btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;删除</button>";

	
	

	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	public String getSearchCondition() {
		return searchCondition;
	}
	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}
	
	public String getDicUpdateCode() {
		return dicUpdateCode;
	}
	public void setDicUpdateCode(String dicUpdateCode) {
		this.dicUpdateCode = dicUpdateCode;
	}
	/**
	 * 设置操作列上的按钮
	 * @param operation
	 */
	public void setOperation(String operation) {
		StringBuffer opButton = new StringBuffer();
		if (StringUtils.isNotEmpty(getDictId())) {
				opButton.append(String.format(OPERATION_BTN_EDIT, getDictId(),getDictValueType(),getDictValue().replaceAll("\"", "▓"),getDictName(),getDictCode(),getRemark(),getDictType(), getDictId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DELETE, getDictId()));
				opButton.append("&nbsp;");
		}
		this.operation = opButton.toString();
	}
	
	
}
