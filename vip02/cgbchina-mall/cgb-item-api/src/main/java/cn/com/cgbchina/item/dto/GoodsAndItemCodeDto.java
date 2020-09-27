/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/26.
 */


public class GoodsAndItemCodeDto implements Serializable{

    private static final long serialVersionUID = -189989747976524435L;
    @Getter
    @Setter
    private String goodsCode;
    @Getter
    @Setter
    private String itemCode;
}

