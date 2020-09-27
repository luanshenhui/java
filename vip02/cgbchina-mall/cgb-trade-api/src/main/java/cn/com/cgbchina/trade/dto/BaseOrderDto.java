package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by lvzd on 2016/9/28.
 */
@Setter
@Getter
public class BaseOrderDto implements Serializable{
    private static final long serialVersionUID = -54520433264642729L;
    private String returnCode;
    private String returnDes;
}
