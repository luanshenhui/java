package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by w2001316 on 2016/7/25.
 */
public class MakecheckjobErrorDto implements Serializable {

    private static final long serialVersionUID = -7659606368036684709L;

    /**
     * 日期
     */
    @Getter
    @Setter
    private String createDate;
    /**
     * 手动标识
     */
    @Getter@Setter
    private String isshoudong;
}
