package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class EspAreaInfModel implements Serializable {

    private static final long serialVersionUID = -5374060613002119308L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码YG：广发JF：积分
    @Getter
    @Setter
    private String areaId;//专区代码
    @Getter
    @Setter
    private String areaName;//专区名称
    @Getter
    @Setter
    private String areaType;//
    @Getter
    @Setter
    private String focusImage;//选中图片文件
    @Getter
    @Setter
    private String unfocusImage;//未选中图片文件
    @Getter
    @Setter
    private Integer areaSeq;//顺序
    @Getter
    @Setter
    private String integralType;//积分类型
    @Getter
    @Setter
    private String goodsType;//礼(商)品类型
    @Getter
    @Setter
    private String formatId;//卡板代号
    @Getter
    @Setter
    private String areaDesc;//备注
    @Getter
    @Setter
    private String curStatus;//当前状态(0101：未启用,0102：已启用)
    @Getter
    @Setter
    private String publishStatus;//发布状态(00：已发布,01：等待审核,21：等待发布)
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
    @Getter
    @Setter
    private String createOper;//创建者
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改者
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}