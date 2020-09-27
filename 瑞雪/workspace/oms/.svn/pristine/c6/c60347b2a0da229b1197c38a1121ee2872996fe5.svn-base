package cn.rkylin.oms.system.shop.vo;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.system.shop.domain.Shop;

/**
 * 店铺值对象，用于满足前台展示、系统间交互的需要
 * 
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:15
 */
public class ShopVO extends Shop {
	/**
	 * 序列化id
	 */
	private static final long serialVersionUID = 1197685576331449588L;
	
	/*
	 * 列表操作按钮定义
	 */
	private static final String OPERATION_BTN_EDIT = "<button onclick=\"operationEdit(this)\" shopid=\"%s\" type=\"button\" class=\"btn btn-info btn-xs\"><i class=\"fa fa-edit\"></i>&nbsp;修改</button>";
	private static final String OPERATION_BTN_EDIT_DISABLED = "<button style=\"cursor:default\" disabled shopid=\"%s\" type=\"button\" class=\"btn btn-disable btn-xs\"><i class=\"fa fa-edit\"></i>&nbsp;修改</button>";
	
	private static final String OPERATION_BTN_ENABLE = "<button onclick=\"operationEnable(this)\" shopid=\"%s\" type=\"button\" class=\"btn btn-success btn-xs\"><i class=\"fa fa-check\"></i>&nbsp;启用</button>";
	// 未验证，不能启用
	private static final String OPERATION_BTN_ENABLE_NOT_VALIDATE = "<button style=\"cursor:dfault\" disabled shopid=\"%s\" type=\"button\" class=\"btn btn-disable btn-xs\"><i class=\"fa fa-check\"></i>&nbsp;启用</button>";
	private static final String OPERATION_BTN_ENABLE_DISABLED = "<button onclick=\"operationEnable(this)\" shopid=\"%s\" type=\"button\" class=\"btn btn-warning btn-xs\"><i class=\"fa fa-ban\"></i>&nbsp;停用</button>";
	
	private static final String OPERATION_BTN_DELETE = "<button onclick=\"operationDelete(this)\" shopid=\"%s\" type=\"button\" class=\"btn btn-danger btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;删除</button>";
	private static final String OPERATION_BTN_DELETE_DISABLED = "<button style=\"cursor:dfault\" disabled shopid=\"%s\" type=\"button\" class=\"btn btn-disable btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;删除</button>";

	/**
	 * 状态定义
	 */
	private static final String STATUS_YES = "<span>%s</span>";
	private static final String STATUS_NO = "<span style=\"color:red\">%s</span>";
	private static final String STATUS_CHK = "<input id=\"chkItem\" name=\"chkItem\" type=\"checkbox\" shopId=\"%s\" /></input>";

	/**
	 * 项目名称
	 */
	private String prjName;
	/**
	 * 项目类型
	 */
	private String prjType;
	/**
	 * 启用状态
	 */
	private String status;
	/**
	 * 有效状态
	 */
	private String validateStatus;
	/**
	 * 操作
	 */
	private String operation;
	/**
	 * orderBy子句
	 */
	private String orderBy;
	/**
	 * 搜索条件
	 */
	private String searchCondition;
	/**
	 * 父店铺名称
	 */
	private String parentshopname;
	
	 /**
     * checkbox
     */
    private String chk;

    private List unitList;
    private String entId;
    private String prjId;

	public String getParentshopname() {
		return parentshopname;
	}

	public void setParentshopname(String parentshopname) {
		this.parentshopname = parentshopname;
	}

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName;
	}

	public String getPrjType() {
		return prjType;
	}

	public void setPrjType(String prjType) {
		this.prjType = prjType;
	}

	/**
	 * 构造函数
	 */
	public ShopVO() {

	}

	public void finalize() throws Throwable {
		super.finalize();
	}

	public String getStatus() {
		return this.status;
	}

	/**
	 * 设置列表上的状态列label
	 * @param status
	 */
	public void setStatus(String status) {
		StringBuffer statusButton = new StringBuffer();
		if (this.getEnable().equalsIgnoreCase("y")) {
			statusButton.append(String.format(STATUS_YES, "是"));
		} else {
			statusButton.append(String.format(STATUS_NO, "否"));
		}
		this.status = statusButton.toString();
	}

	public String getValidateStatus() {
		return validateStatus;
	}

	public void setValidateStatus(String validateStatus) {
		StringBuffer validateStatusButton = new StringBuffer();
		if (this.getValidate().equalsIgnoreCase("y")) {
			validateStatusButton.append(String.format(STATUS_YES, "是"));
		} else {
			validateStatusButton.append(String.format(STATUS_NO, "否"));
		}
		this.validateStatus = validateStatusButton.toString();
	}

	public String getOperation() {
		return this.operation;
	}

	/**
	 * 设置操作列上的按钮
	 * @param operation
	 */
	public void setOperation(String operation) {
		StringBuffer opButton = new StringBuffer();
		if (StringUtils.isNotEmpty(getShopId())) {
			if (this.getEnable().equalsIgnoreCase("y")) {
				opButton.append(String.format(OPERATION_BTN_EDIT, getShopId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_ENABLE_DISABLED, getShopId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DELETE_DISABLED, getShopId()));
			} else {
				opButton.append(String.format(OPERATION_BTN_EDIT, getShopId()));
				opButton.append("&nbsp;");
				// 验证通过才可以启用，否则不能启用。
				if (this.getValidate().equalsIgnoreCase("y")) {
					opButton.append(String.format(OPERATION_BTN_ENABLE, getShopId()));
				} else {
					opButton.append(String.format(OPERATION_BTN_ENABLE_NOT_VALIDATE, getShopId()));
				}
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DELETE, getShopId()));
			}
		}
		this.operation = opButton.toString();
	}

	public String getOrderBy() {
		// 此字段需要防止sql注入
		return orderBy == null ? null : orderBy.replaceAll(".*([';]+|(--)+).*", " ");
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

    public String getChk() {
        return this.chk;
    }

    public void setChk(String chk) {
        this.chk = String.format(STATUS_CHK, this.getShopId()).toString();
    }

    public List getUnitList() {
        return unitList;
    }

    public void setUnitList(List unitList) {
        this.unitList = unitList;
    }

	public String getEntId() {
		return entId;
	}

	public void setEntId(String entId) {
		this.entId = entId;
	}

	public String getPrjId() {
		return prjId;
	}

	public void setPrjId(String prjId) {
		this.prjId = prjId;
	}
    
    
}