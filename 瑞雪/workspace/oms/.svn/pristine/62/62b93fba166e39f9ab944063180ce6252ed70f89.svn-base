package cn.rkylin.oms.ectrade.vo;

import java.util.Date;

import cn.rkylin.oms.ectrade.domain.EcTrade;

/**
 * Created by ZH on 2017-2-8.
 */
public class EcTradeVO extends EcTrade {

    /**
     * 序列化id
     */
    private static final long serialVersionUID = -3434661584402051409L;
    
    private static final String STATUS_ECORDERSHOW = "<span class=\"fa fa-chevron-down\" ecTradeId=\"%s\"></span>";
    
    private static final String SPLIT_FLAG = "<span class='badge badge-orange'> </span>";
    private static final String PART_SEND_FLAG = "<span class='badge badge-blue'> </span>";
    private static final String EXCEPTION_FLAG = "<span class='badge badge-red'> </span>";
    /**
     * 排序
     */
    private String orderBy;
    public String getOrderBy() {
        // 此字段需要防止sql注入
        return orderBy == null ? null : orderBy.replaceAll(".*([';]+|(--)+).*", " ");
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }


    /**
     * 搜索条件
     */
    private String searchCondition;

    /**
     * 子平台订单ID
     */
    private String childEcTradeId;
    
    /**
     * 订单商品显示html
     */
    private String ecOrderShow;
    
    /**
     * 状态画面html
     */
    private String status;
    
//	未付款
	private Integer countNoPay;
//	待处理
	private Integer countWait;
//	待发货
	private Integer countWaitSend;
//	全部发货
	private Integer countSend;
//	已完成
	private Integer countOver;
//	已废弃
	private Integer countCancel;
	//异常类型
	private String exceptionType;
	//分单标识
	private String splitFlg;
	//部分发货
	private String partiallySend;
	//最小送货时间
	private Date sendTime;
	//导出用
	private String ecItemCode;
	private String ecItemName;
	private String ecSkuCode;
	private String ecSkuName;
	private String ecOrderStatus;
	private String splitShopName;
	private String erpStatus;
	private String deleteReason;
	private String shipTime;
	private String lgstName;
	private String logisticsId;
	private Integer waiteSend;
	
	public Integer getWaiteSend() {
		return waiteSend;
	}

	public void setWaiteSend(Integer waiteSend) {
		this.waiteSend = waiteSend;
	}

	public String getEcItemCode() {
		return ecItemCode;
	}

	public void setEcItemCode(String ecItemCode) {
		this.ecItemCode = ecItemCode;
	}

	public String getEcItemName() {
		return ecItemName;
	}

	public void setEcItemName(String ecItemName) {
		this.ecItemName = ecItemName;
	}

	public String getEcSkuCode() {
		return ecSkuCode;
	}

	public void setEcSkuCode(String ecSkuCode) {
		this.ecSkuCode = ecSkuCode;
	}

	public String getEcSkuName() {
		return ecSkuName;
	}

	public void setEcSkuName(String ecSkuName) {
		this.ecSkuName = ecSkuName;
	}

	public String getEcOrderStatus() {
		return ecOrderStatus;
	}

	public void setEcOrderStatus(String ecOrderStatus) {
		this.ecOrderStatus = ecOrderStatus;
	}

	public String getSplitShopName() {
		return splitShopName;
	}

	public void setSplitShopName(String splitShopName) {
		this.splitShopName = splitShopName;
	}

	public String getErpStatus() {
		return erpStatus;
	}

	public void setErpStatus(String erpStatus) {
		this.erpStatus = erpStatus;
	}

	public String getDeleteReason() {
		return deleteReason;
	}

	public void setDeleteReason(String deleteReason) {
		this.deleteReason = deleteReason;
	}

	public String getShipTime() {
		return shipTime;
	}

	public void setShipTime(String shipTime) {
		this.shipTime = shipTime;
	}

	public String getLgstName() {
		return lgstName;
	}

	public void setLgstName(String lgstName) {
		this.lgstName = lgstName;
	}

	public String getLogisticsId() {
		return logisticsId;
	}

	public void setLogisticsId(String logisticsId) {
		this.logisticsId = logisticsId;
	}

	public Date getSendTime() {
		return sendTime;
	}

	public void setSendTime(Date sendTime) {
		this.sendTime = sendTime;
	}

	public String getExceptionType() {
		if ("1".equals(exceptionType)){
			return EXCEPTION_FLAG;
		} else {
			return "";
		}
	}

	public void setExceptionType(String exceptionType) {
		this.exceptionType = exceptionType;
	}

	public String getSplitFlg() {
		if ("1".equals(splitFlg)){
			return SPLIT_FLAG;
		} else {
			return "";
		}
	}

	public void setSplitFlg(String splitFlg) {
		this.splitFlg = splitFlg;
	}

	public String getPartiallySend() {
		//如果系统发货的时候，多个商品中有没发货的情况就要显示部分发货
		Integer countNoSend = getWaiteSend(); 
		if (countNoSend!=null && countNoSend.intValue() > 0){
			return PART_SEND_FLAG;
		} else {
			return "";
		}
	}

	public void setPartiallySend(String partiallySend) {
		this.partiallySend = partiallySend;
	}

	public Integer getCountNoPay() {
		return countNoPay;
	}
	public void setCountNoPay(Integer countNoPay) {
		this.countNoPay = countNoPay;
	}
	public Integer getCountWait() {
		return countWait;
	}
	public void setCountWait(Integer countWait) {
		this.countWait = countWait;
	}
	public Integer getCountWaitSend() {
		return countWaitSend;
	}
	public void setCountWaitSend(Integer countWaitSend) {
		this.countWaitSend = countWaitSend;
	}
	public Integer getCountSend() {
		return countSend;
	}
	public void setCountSend(Integer countSend) {
		this.countSend = countSend;
	}
	public Integer getCountOver() {
		return countOver;
	}
	public void setCountOver(Integer countOver) {
		this.countOver = countOver;
	}
	public Integer getCountCancel() {
		return countCancel;
	}
	public void setCountCancel(Integer countCancel) {
		this.countCancel = countCancel;
	}
	
    public String getStatus() {
    	if ("EB_WAIT_BUYER_PAY".equals(this.getEcTradeStatus())){
    		return "等待买家付款";
    	} else if ("EB_WAIT_SELLER_SEND".equals(this.getEcTradeStatus())){
    		return "等待卖家发货";
    	} else if ("EB_TRADE_PARTIALLY_SEND".equals(this.getEcTradeStatus())){
    		return "交易部分发货";
    	} else if ("EB_TRADE_ALL_SEND".equals(this.getEcTradeStatus())){
    		return "交易全部发货";
    	} else if ("EB_TRADE_FINISHED".equals(this.getEcTradeStatus())){
    		return "交易成功";
    	} else if ("EB_TRADE_CANCELED".equals(this.getEcTradeStatus())){
    		return "交易取消";
    	} else {
    		return "";
    	}
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getEcOrderShow() {
		return ecOrderShow;
	}

	public void setEcOrderShow(String ecOrderShow) {
		this.ecOrderShow = String.format(STATUS_ECORDERSHOW, this.getEcTradeId()).toString();
	}

	public String getChildEcTradeId() {
		return childEcTradeId;
	}

	public void setChildEcTradeId(String childEcTradeId) {
		this.childEcTradeId = childEcTradeId;
	}

	public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

}
