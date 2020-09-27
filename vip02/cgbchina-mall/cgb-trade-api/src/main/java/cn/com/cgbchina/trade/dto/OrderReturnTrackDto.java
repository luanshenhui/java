package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderPartBackModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yuxinxin on 16-4-30.
 */
public class OrderReturnTrackDto extends OrderPartBackModel implements Serializable {
	private static final long serialVersionUID = 2662826338268432765L;
	@Getter
	@Setter
	private List<OrderReturnTrackModel> orderReturnTrackModelList;// 当前状态id0334--退货申请0327--退货成功0335--拒绝退货申请0312--已撤单

}
