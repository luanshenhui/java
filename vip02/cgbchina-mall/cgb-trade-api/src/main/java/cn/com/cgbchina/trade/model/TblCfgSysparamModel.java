package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblCfgSysparamModel implements Serializable {

    @Getter
    @Setter
    private String paramId;//参数代码
    @Getter
    @Setter
    private String paramNm;//参数名称
    @Getter
    @Setter
    private String paramDesc;//参数描述
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码yg：广发jf：积分
    @Getter
    @Setter
    private String maintainFlag;//允许业务维护
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}