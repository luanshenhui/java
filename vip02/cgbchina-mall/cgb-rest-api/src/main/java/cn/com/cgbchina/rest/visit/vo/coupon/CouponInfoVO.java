package cn.com.cgbchina.rest.visit.vo.coupon;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

/**
 * Comment:
 * Created by 11150321050126 on 2016/4/30.
 */
public class CouponInfoVO {
	@NotNull
    private String projectNO;
	@NotNull
    private String sProjectNO;
	@NotNull
    private String privilegeId;
	@NotNull
    private String privilegeName;
	@NotNull
    private BigDecimal privilegeMoney;
	@NotNull
    private BigDecimal liquidateRatio;
	@NotNull
    private String useActivatiState;
	@NotNull
    private String pastDueState;
	@NotNull
    private BigDecimal limitMoney;
	@NotNull
    private String beginDate;
	@NotNull
    private String endDate;
	@NotNull
    private String regulation;

    public String getProjectNO() {
        return projectNO;
    }

    public void setProjectNO(String projectNO) {
        this.projectNO = projectNO;
    }

    public String getSProjectNO() {
        return sProjectNO;
    }

    public void setSProjectNO(String sProjectNO) {
        this.sProjectNO = sProjectNO;
    }

    public String getPrivilegeId() {
        return privilegeId;
    }

    public void setPrivilegeId(String privilegeId) {
        this.privilegeId = privilegeId;
    }

    public String getPrivilegeName() {
        return privilegeName;
    }

    public void setPrivilegeName(String privilegeName) {
        this.privilegeName = privilegeName;
    }

    public BigDecimal getPrivilegeMoney() {
        return privilegeMoney;
    }

    public void setPrivilegeMoney(BigDecimal privilegeMoney) {
        this.privilegeMoney = privilegeMoney;
    }

    public BigDecimal getLiquidateRatio() {
        return liquidateRatio;
    }

    public void setLiquidateRatio(BigDecimal liquidateRatio) {
        this.liquidateRatio = liquidateRatio;
    }

    public String getUseActivatiState() {
        return useActivatiState;
    }

    public void setUseActivatiState(String useActivatiState) {
        this.useActivatiState = useActivatiState;
    }

    public String getPastDueState() {
        return pastDueState;
    }

    public void setPastDueState(String pastDueState) {
        this.pastDueState = pastDueState;
    }

    public BigDecimal getLimitMoney() {
        return limitMoney;
    }

    public void setLimitMoney(BigDecimal limitMoney) {
        this.limitMoney = limitMoney;
    }

    public String getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(String beginDate) {
        this.beginDate = beginDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getRegulation() {
        return regulation;
    }

    public void setRegulation(String regulation) {
        this.regulation = regulation;
    }
}
