/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 *
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/19
 */
public class OrderPartDto implements Serializable {

    private static final long serialVersionUID = 4541069772792770013L;
    @Setter
    @Getter
    private OrderReturnTrackDetailModel data;
    @Setter
    @Getter
    private OrderSubModel orderSubModel;
    @Setter
    @Getter
    private String doDesc;
}
