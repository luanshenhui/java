package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class AdvertisingManageModel implements Serializable {

    private static final long serialVersionUID = -2485884637509535182L;
    @Getter
    @Setter
    private Long id;//id
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码YG：广发JF：积分
    @Getter
    @Setter
    private String vendorId;//供应商代码
    @Getter
    @Setter
    private String fullName;//供应商全称
    @Getter
    @Setter
    private String description;//广告描述
    @Getter
    @Setter
    private String link;//目标页面链接地址
    @Getter
    @Setter
    private Integer mediaType;//媒体类型(0 图片,1 视频)
    @Getter
    @Setter
    private String media;//媒体链接地址
    @Getter
    @Setter
    private String checkStatus;//审核状态 0待审核 1审核通过 2审核拒绝
    @Getter
    @Setter
    private Integer isValid;//是否有效 1 是 0 否
    @Getter
    @Setter
    private String auditLog;//审核日志
    @Getter
    @Setter
    private String auditOper;//审核人
    @Getter
    @Setter
    private java.util.Date auditDate;//最终审核日期
    @Getter
    @Setter
    private Integer createOperType;//创建人类型(0 内管,1 供应商)
    @Getter
    @Setter
    private Integer modifyOperType;//修改人类型(0 内管,1 供应商)
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