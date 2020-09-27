package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class EspAdvertiseModel implements Serializable {

    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码YG：广发JF：积分
    @Getter
    @Setter
    private String pageType;//页面类型 01：首页,02：频道,P1 :手机广告
    @Getter
    @Setter
    private String advertisePos;//广告位 01：乐购首页,10：最上方长行广告（单个）,11：中间主广告（多个）,12、主广告下方的长行广告（多个）,13、商品类别下方的广告（单个）,14、排行榜下方的广告（多个）,02：乐购频道,10：最上方长行广告（单个）,11：中间主广告（多个）,12：新品推荐下方广告（单个）,13：品牌下方的广告（多个）,14、排行榜下方的广告（多个）,01：积分首页,10：最上方长行广告（单个）,11：中间主广告（多个）,12：推荐礼品下方广告（单个）,13、商品类别下方的广告（多个）,14、排行榜下方的广告（
    @Getter
    @Setter
    private String advertiseImage;//图片上传状态
    @Getter
    @Setter
    private String advertiseHref;//链接地址
    @Getter
    @Setter
    private Integer advertiseSeq;//顺序
    @Getter
    @Setter
    private String publishStatus;//发布状态 00：已发布,01：等待审核,21：等待发布 40:发布失败
    @Getter
    @Setter
    private String advertiseDesc;//备注
    @Getter
    @Setter
    private String linkType;//链接类型
    @Getter
    @Setter
    private String isStop;//是是否启用标志 0-停止，1-启用
    @Getter
    @Setter
    private String keyword;//关键字
    @Getter
    @Setter
    private String pageId;//页面代码 页面类型=01：00,页面类型=02：频道代码
    @Getter
    @Setter
    private java.util.Date startTime;//开始时间
    @Getter
    @Setter
    private java.util.Date endTime;//结束时间
    @Getter
    @Setter
    private String orgCode;//编码
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
}