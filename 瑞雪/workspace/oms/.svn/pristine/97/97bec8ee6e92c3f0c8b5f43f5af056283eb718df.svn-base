package cn.rkylin.oms.system.project.vo;


import java.util.List;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.system.project.domain.ProjectManager;

/**
 * 项目VO
 */
public class ProjectVO extends ProjectManager {

	private static final String OPERATION_BTN_EDIT = "<button onclick=\"operationEdit(this)\" prjId=\"%s\" type=\"button\" class=\"btn btn-info btn-xs\"><i class=\"fa fa-edit\"></i>&nbsp;修改</button>";
	private static final String OPERATION_BTN_ENABLE = "<button onclick=\"operationEnable(this)\" prjId=\"%s\" type=\"button\" class=\"btn btn-success btn-xs\"><i class=\"fa fa-check\"></i>&nbsp;启用</button>";
	private static final String OPERATION_BTN_DISABLED = "<button onclick=\"operationDisable(this)\" prjId=\"%s\" type=\"button\" class=\"btn btn-warning btn-xs\"><i class=\"fa fa-ban\"></i>&nbsp;停用</button>";
	private static final String OPERATION_BTN_DELETE = "<button onclick=\"operationDelete(this)\" prjId=\"%s\" type=\"button\" class=\"btn btn-danger btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;删除</button>";
	private static final String OPERATION_BTN_DELETE_DISABLED = "<button style=\"cursor:dfault\" disabled shopid=\"%s\" type=\"button\" class=\"btn btn-disable btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;删除</button>";
	/**
	 * 状态定义
	 */
	private static final String STATUS_YES = "<span>%s</span>";
	private static final String STATUS_NO = "<span style=\"color:red\">%s</span>";
	private static final String STATUS_CHK = "<input id=\"chkItem\" name=\"chkItem\" type=\"checkbox\" proId=\"%s\" /></input>";
	private String operation;

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	private String orderBy;
	
	private List unitList;

	public String getOperation() {
		return operation;
	}
	
	 /**
     * checkbox
     */
    private String chk;

	public void setOperation(String operation) {
		StringBuffer opButton = new StringBuffer();
		if (StringUtils.isNotEmpty(getPrjId())) {
			if (this.getEnable().equalsIgnoreCase("a")) {
				opButton.append(String.format(OPERATION_BTN_EDIT, getPrjId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_ENABLE, getPrjId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DELETE, getPrjId()));
			} else if (this.getEnable().equalsIgnoreCase("y")) {
				opButton.append(String.format(OPERATION_BTN_EDIT, getPrjId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DISABLED, getPrjId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DELETE_DISABLED, getPrjId()));
			}
			else {
				opButton.append(String.format(OPERATION_BTN_EDIT, getPrjId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_ENABLE, getPrjId()));
				opButton.append("&nbsp;");
				opButton.append(String.format(OPERATION_BTN_DELETE, getPrjId()));
			}
		}
		this.operation = opButton.toString();
	}

	public String getEnableStatus() {
		return enableStatus;
	}

	public void setEnableStatus(String enableStatus) {
		StringBuffer enableButton = new StringBuffer();
		if (this.getEnable().equalsIgnoreCase("a")) {
			enableButton.append(String.format(STATUS_YES, "登记"));
		}
		else if (this.getEnable().equalsIgnoreCase("y")) {
			enableButton.append(String.format(STATUS_YES, "启用"));
		}
		else {
			enableButton.append(String.format(STATUS_NO, "停用"));
		}
		this.enableStatus = enableButton.toString();
	}

    private String enableStatus;

    public String getChk() {
        return this.chk;
    }

    public void setChk(String chk) {
        this.chk = String.format(STATUS_CHK, this.getPrjId()).toString();
    }

    public List getUnitList() {
        return unitList;
    }

    public void setUnitList(List unitList) {
        this.unitList = unitList;
    }
    
    
}