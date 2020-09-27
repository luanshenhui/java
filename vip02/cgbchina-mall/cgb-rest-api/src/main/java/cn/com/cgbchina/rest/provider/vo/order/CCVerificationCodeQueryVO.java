package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL121	CC重发验证码
 * @author lizy
 *         2016/4/28.
 */
public class CCVerificationCodeQueryVO  extends BaseQueryEntityVO implements Serializable {
    private static final long serialVersionUID = 6982318514767347417L;
    @NotNull
    private	String	origin	;
    @NotNull
    private	String	mallType	;
    @NotNull
    @XMLNodeName(value="orderno")
    private	String	orderNo	;
    @NotNull 
    @XMLNodeName(value="suborderno")
    private	String	subOrderNo	;
    @NotNull
    private	String   mobile;

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getMallType() {
        return mallType;
    }

    public void setMallType(String mallType) {
        this.mallType = mallType;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getSubOrderNo() {
        return subOrderNo;
    }

    public void setSubOrderNo(String subOrderNo) {
        this.subOrderNo = subOrderNo;
    }
}
