package cn.com.cgbchina.item.service.points;

import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

import cn.com.cgbchina.item.dto.GiftItemDto;
import cn.com.cgbchina.item.dto.GoodsDescribeDto;
import com.spirit.user.User;

/**
 * Created by zhanglin on 2016/8/10.
 */
public interface PointsGiftService {

	/**
	 * 积分商城获得最优的价格的支付方式id(积分支付场合)
	 */
	public  Response<TblGoodsPaywayModel> getPaywayIdbyItem(Boolean isBirth, String itemCode, User user, Boolean integralCash);


	/**
	 * 生日价是否为最优价格选项
	 */
	public TblGoodsPaywayModel checkBirthIsBest(String itemCode, User user);

	public String getUserLevel(User user);

}
