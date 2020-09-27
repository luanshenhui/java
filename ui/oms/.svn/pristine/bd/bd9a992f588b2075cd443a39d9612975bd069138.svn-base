package cn.rkylin.oms.ectrade.domain;

import cn.rkylin.oms.common.base.BaseEntity;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;


/**
 * 订单实体，对应oms_ec_trade表
 * @author zhangheng
 * @version 1.0
 * @created 14-2月-2017 09:11:15
 */
public class EcTrade extends BaseEntity {

    /**
     * 序列化id
     */
    private static final long serialVersionUID = -6244928930575835452L;

    /**
     * 项目ID
     */
    private String prjId;
    /**
     * 项目名字
     */
    private String prjName;
    /**
     * 店铺ID
     */
    private String shopId;
    /**
     * 店铺名字
     */
    private String shopName;
    /**
     * 订单Id
     */
    private String ecTradeId;
    /**
     *订单编码
     */
    private String ecTradeCode;
    /**
     *店铺账号
     */
    private String shopAccount;
    /**
     *店铺类型
     */
    private String shopType;
    /**
     *订单状态
     EB_WAIT_BUYER_PAY(等待买家付款) EB_WAIT_SELLER_SEND(等待卖家发货,即:买家已付款) EB_TRADE_PARTIALLY_SEND(交易部分发货) EB_TRADE_ALL_SEND(交易全部发货) EB_TRADE_FINISHED(交易成功) EB_TRADE_CANCELED(交易取消)
     */
    private String ecTradeStatus;
    /**
     *顾客编码
     */
    private String ecCustCode;
    /**
     *顾客名称
     */
    private String ecCustName;
    /**
     *订单类型
     Initial value: default 'fixed'
     fixed(一口价) cod(货到付款)
     */
    private String tradeType;
    /**
     *收货人
     */
    private String cons;
    /**
     *电话
     */
    private String consTel;
    /**
     *手机
     */
    private String consMobile;
    /**
     *收货地址
     */
    private String consAddr;
    /**
     *邮编
     */
    private String consPostCode;
    /**
     *区域编码
     */
    private String areaCoding;
    /**
     *重量
     */
    private BigDecimal totWeight;
    /**
     *订单金额
     */
    private BigDecimal tradeMoney;
    /**
     *支付金额
     */
    private BigDecimal paidFee;
    /**
     *支付金额
     */
    private BigDecimal lgstFee;
    /**
     *折扣金额
     */
    private BigDecimal tradeDisc;
    /**
     *服务费
     */
    private BigDecimal servFee;
    /**
     *平台积分金额
     */
    private BigDecimal pointMoney;
    /**
     *券金额
     */
    private BigDecimal ticketMoney;
    /**
     *付款时间
     */
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date paidTime;
    /**
     *关闭时间
     */
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date endTime;
    /**
     *买家备注
     */
    private String custRemark;
    /**
     *卖家备注
     */
    private String salesRemark;
    /**
     *备注
     */
    private String remark;
    /**
     * 拍单时间
     */
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date orderTime;
    /**
     * trade的父节点ID
     */
    private String parentTradeId;
	/**
	 * 分单状态
	 */
    private String splitStatus;
    
    public String getSplitStatus() {
		return splitStatus;
	}

	public void setSplitStatus(String splitStatus) {
		this.splitStatus = splitStatus;
	}

	public Date getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(Date orderTime) {
		this.orderTime = orderTime;
	}

	public String getParentTradeId() {
		return parentTradeId;
	}

	public void setParentTradeId(String parentTradeId) {
		this.parentTradeId = parentTradeId;
	}

	public String getInvoice() {
        return invoice;
    }

    public void setInvoice(String invoice) {
        this.invoice = invoice;
    }
    /**
     *发票
     Initial value: default 'n'
     */
    private String invoice;
    /**
     *发票抬头
     */
    private String invoiceTitle;
    /**
     *支付宝交易号
     */
    private String alipayOrderNo;
    /**
     *创建时间
     */
    private Date createTime;
    /**
     *更新时间
     */
    private Date updateTime;

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
    /**
     *删除标记
     */
    private String deleted;

    public String getEcTradeId() {
        return ecTradeId;
    }

    public void setEcTradeId(String ecTradeId) {
        this.ecTradeId = ecTradeId == null ? null : ecTradeId.trim();
    }

    public String getEcTradeCode() {
        return ecTradeCode;
    }

    public void setEcTradeCode(String ecTradeCode) {
        this.ecTradeCode = ecTradeCode == null ? null : ecTradeCode.trim();
    }

    public String getShopAccount() {
        return shopAccount;
    }

    public void setShopAccount(String shopAccount) {
        this.shopAccount = shopAccount == null ? null : shopAccount.trim();
    }

    public String getShopType() {
        return shopType;
    }

    public void setShopType(String shopType) {
        this.shopType = shopType == null ? null : shopType.trim();
    }

    public String getEcTradeStatus() {
        return ecTradeStatus;
    }

    public void setEcTradeStatus(String ecTradeStatus) {
        this.ecTradeStatus = ecTradeStatus == null ? null : ecTradeStatus.trim();
    }

    public String getEcCustCode() {
        return ecCustCode;
    }

    public void setEcCustCode(String ecCustCode) {
        this.ecCustCode = ecCustCode == null ? null : ecCustCode.trim();
    }

    public String getEcCustName() {
        return ecCustName;
    }

    public void setEcCustName(String ecCustName) {
        this.ecCustName = ecCustName == null ? null : ecCustName.trim();
    }

    public String getTradeType() {
        return tradeType;
    }

    public void setTradeType(String tradeType) {
        this.tradeType = tradeType == null ? null : tradeType.trim();
    }

    public String getCons() {
        return cons;
    }

    public void setCons(String cons) {
        this.cons = cons == null ? null : cons.trim();
    }

    public String getConsTel() {
        return consTel;
    }

    public void setConsTel(String consTel) {
        this.consTel = consTel == null ? null : consTel.trim();
    }

    public String getConsMobile() {
        return consMobile;
    }

    public void setConsMobile(String consMobile) {
        this.consMobile = consMobile == null ? null : consMobile.trim();
    }

    public String getConsAddr() {
        return consAddr;
    }

    public void setConsAddr(String consAddr) {
        this.consAddr = consAddr == null ? null : consAddr.trim();
    }

    public String getConsPostCode() {
        return consPostCode;
    }

    public void setConsPostCode(String consPostCode) {
        this.consPostCode = consPostCode == null ? null : consPostCode.trim();
    }

    public String getAreaCoding() {
        return areaCoding;
    }

    public void setAreaCoding(String areaCoding) {
        this.areaCoding = areaCoding == null ? null : areaCoding.trim();
    }

    public BigDecimal getTotWeight() {
        return totWeight;
    }

    public void setTotWeight(BigDecimal totWeight) {
        this.totWeight = totWeight;
    }

    public BigDecimal getTradeMoney() {
        return tradeMoney;
    }

    public void setTradeMoney(BigDecimal tradeMoney) {
        this.tradeMoney = tradeMoney;
    }

    public BigDecimal getPaidFee() {
        return paidFee;
    }

    public void setPaidFee(BigDecimal paidFee) {
        this.paidFee = paidFee;
    }

    public BigDecimal getLgstFee() {
        return lgstFee;
    }

    public void setLgstFee(BigDecimal lgstFee) {
        this.lgstFee = lgstFee;
    }

    public BigDecimal getTradeDisc() {
        return tradeDisc;
    }

    public void setTradeDisc(BigDecimal tradeDisc) {
        this.tradeDisc = tradeDisc;
    }

    public BigDecimal getServFee() {
        return servFee;
    }

    public void setServFee(BigDecimal servFee) {
        this.servFee = servFee;
    }

    public BigDecimal getPointMoney() {
        return pointMoney;
    }

    public void setPointMoney(BigDecimal pointMoney) {
        this.pointMoney = pointMoney;
    }

    public BigDecimal getTicketMoney() {
        return ticketMoney;
    }

    public void setTicketMoney(BigDecimal ticketMoney) {
        this.ticketMoney = ticketMoney;
    }

    public Date getPaidTime() {
        return paidTime;
    }

    public void setPaidTime(Date paidTime) {
        this.paidTime = paidTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getCustRemark() {
        return custRemark;
    }

    public void setCustRemark(String custRemark) {
        this.custRemark = custRemark == null ? null : custRemark.trim();
    }

    public String getSalesRemark() {
        return salesRemark;
    }

    public void setSalesRemark(String salesRemark) {
        this.salesRemark = salesRemark == null ? null : salesRemark.trim();
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }


    public String getInvoiceTitle() {
        return invoiceTitle;
    }

    public void setInvoiceTitle(String invoiceTitle) {
        this.invoiceTitle = invoiceTitle == null ? null : invoiceTitle.trim();
    }

    public String getAlipayOrderNo() {
        return alipayOrderNo;
    }

    public void setAlipayOrderNo(String alipayOrderNo) {
        this.alipayOrderNo = alipayOrderNo == null ? null : alipayOrderNo.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

	public String getPrjId() {
		return prjId;
	}

	public void setPrjId(String prjId) {
		this.prjId = prjId;
	}

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName;
	}

	public String getShopId() {
		return shopId;
	}

	public void setShopId(String shopId) {
		this.shopId = shopId;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}


}