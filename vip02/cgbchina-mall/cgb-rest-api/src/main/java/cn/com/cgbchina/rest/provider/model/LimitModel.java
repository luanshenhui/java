package cn.com.cgbchina.rest.provider.model;

import lombok.Getter;
import lombok.Setter;

/**
 * Comment:
 * Created by 11150321050126 on 2016/12/21.
 */
@Setter
@Getter
public class LimitModel {
    /**
     * 限流系统英文名
     */
    private String key;
    /**
     * 当前数量
     */
    private Long num;
    /**
     * 限流系统名
     */
    private String name;
}
