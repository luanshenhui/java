package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

public class EsphtmInfModel implements Serializable {

    private static final long serialVersionUID = -1095549322306049776L;
    @Getter
    @Setter
    private String actId;//静态页面代码
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码yg：广发jf：积分
    @Getter
    @Setter
    private String browsePath;//浏览路径
    @Getter
    @Setter
    private String pageId;//页面代码
    @Getter
    @Setter
    private String actName;//页面名称
    @Getter
    @Setter
    private String actFilename;//文件名称
    @Getter
    @Setter
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private java.util.Date startTime;//上线时间
    @Getter
    @Setter
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private java.util.Date endTime;//下线时间
    @Getter
    @Setter
    private String remark;//活动描述
    @Getter
    @Setter
    private String subKeyCd1;// 
    @Getter
    @Setter
    private String subKeyCd2;// 
    @Getter
    @Setter
    private String subKeyCd3;// 
    @Getter
    @Setter
    private String miscTx;// 
    @Getter
    @Setter
    private String lastUpdTxnId;// 
    @Getter
    @Setter
    private String vendorId;//合作商编码
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
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
    @Getter
    @Setter
    private String pageType;//页面类型(【00 大首页 01 过渡页 02专区首页 03 预留页】 04APP预留页  05商城预留页)
    @Getter
    @Setter
    private String publishStatus;//发布状态 00 已发布  01 等待发布  02等待审核  03 发布失败  21发布中  40审核拒绝
}