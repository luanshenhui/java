package cn.rkylin.oms.ectrade.vo;

import cn.rkylin.oms.ectrade.domain.EcOrder;

public class EcOrderVO extends EcOrder {

	private static final String OPERATION_BTN_DELETE = "<button onclick=\"operationCanceled(this)\" orderid=\"%s\" ecTradeId=\"%s\" updateTime=\"%s\" type=\"button\" class=\"btn btn-danger btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;废弃</button>";
	private static final String OPERATION_BTN_DELETE_DISABLED = "<button style=\"cursor:dfault\" disabled shopid=\"%s\" type=\"button\" class=\"btn btn-disable btn-xs\"><i class=\"fa fa-trash-o\"></i>&nbsp;废弃</button>";
	/**
	 * 
	 */
	private static final long serialVersionUID = -573897953250323136L;
	//异常类型
	private String exceptionType;
	//平台状态
	private String platformStatus;
	//系统状态
	private String systemStatus;
	//操作
	private String operation;
	
	public String getOperation() {
		StringBuffer opButton = new StringBuffer();
		if("已退款".equals(this.getDeleteReason())){
			opButton.append(String.format(OPERATION_BTN_DELETE, getEcOrderId(),getEcTradeId(),getUpdateTime().toString()));
		} else {
			opButton.append(OPERATION_BTN_DELETE_DISABLED);
		}
		return opButton.toString();
	}
	public void setOperation(String operation) {
		this.operation = operation;
	}
	public String getExceptionType() {
		return exceptionType;
	}
	public void setExceptionType(String exceptionType) {
		this.exceptionType = exceptionType;
	}
	public String getPlatformStatus() {
		return platformStatus;
	}
	public void setPlatformStatus(String platformStatus) {
		this.platformStatus = this.getEcOrderStatus();
	}
	public String getSystemStatus() {
		return systemStatus;
	}
	public void setSystemStatus(String systemStatus) {
		this.systemStatus = systemStatus;
	}
}
