package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class GoodsBrandAdvertiseModel implements Serializable {

    private static final long serialVersionUID = -4989590729722218975L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private Long goodsBrandId;//品牌id
    @Getter
    @Setter
    private String topPic;//置顶图片
    @Getter
    @Setter
    private Integer slide1Id;//轮播广告1_ID
    @Getter
    @Setter
    private String slide1Pic;//轮播广告1_图片路径 
    @Getter
    @Setter
    private String slide1Link;//轮播广告1_目标页面链接地址
    @Getter
    @Setter
    private Integer slide2Id;//轮播广告2_ID
    @Getter
    @Setter
    private String slide2Pic;//轮播广告2_图片路径 
    @Getter
    @Setter
    private String slide2Link;//轮播广告2_目标页面链接地址
    @Getter
    @Setter
    private Integer slide3Id;//轮播广告3_ID
    @Getter
    @Setter
    private String slide3Pic;//轮播广告3_图片路径 
    @Getter
    @Setter
    private String slide3Link;//轮播广告3_目标页面链接地址
    @Getter
    @Setter
    private Integer slide4Id;//轮播广告4_ID
    @Getter
    @Setter
    private String slide4Pic;//轮播广告4_图片路径 
    @Getter
    @Setter
    private String slide4Link;//轮播广告4_目标页面链接地址
    @Getter
    @Setter
    private Integer slide5Id;//轮播广告5_ID
    @Getter
    @Setter
    private String slide5Pic;//轮播广告5_图片路径 
    @Getter
    @Setter
    private String slide5Link;//轮播广告5_目标页面链接地址
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
    @Getter
    @Setter
    private String brandCategoryId; //品牌分类类别ID

}