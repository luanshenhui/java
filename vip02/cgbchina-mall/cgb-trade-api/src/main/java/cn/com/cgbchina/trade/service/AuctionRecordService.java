package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.AuctionRecordModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by 张成 on 16-4-26.
 */
public interface AuctionRecordService {
	/**
	 * 根据活动ID、场次ID、单品CODE 查询拍卖纪录
	 * 
	 * @return Map 两个list
	 */
	public Response<List<AuctionRecordModel>> findByParam(String promId, String periodId, String itemCode);

	/**
	 * 根据活动ID、场次ID、单品CODE 查询拍卖纪录
	 *
	 * @return Map 两个list
	 */
	public Response<AuctionRecordModel> findById(String id);

	/**
	 * 根据拍卖id集合查询拍卖记录
	 *
	 * @return 拍卖集合
	 */
	public Response<List<AuctionRecordModel>> findByIds(List<String> ids);

	/**
	 * 新增拍卖纪录
	 *
	 * @return
	 */
	public Response<Long> insert(AuctionRecordModel auctionRecordModel);

	/**
	 * 按user检索拍卖纪录
	 * @param user
	 * @return
	 */
	public Response<List<AuctionRecordModel>> findByCustId(@Param("User") User user);

	/**
	 * 更新拍卖记录表
	 * @param auctionRecordModel
	 * @return
	 */
	public Response<Integer> updatePayFlag(AuctionRecordModel auctionRecordModel);

	/**
	 * 更新拍卖记录表
	 * @param auctionRecordModel
	 * @return
	 */
	public Response<Integer> updateByIdAndBackLock(AuctionRecordModel auctionRecordModel);

	/**
	 * 新增或更新拍卖纪录
	 *add by zhangshiqiang
	 * @return
	 */
	public Response<Long> insertOrUpdate(AuctionRecordModel auctionRecordModel,User user);


	/**
	 * 更新拍卖资格表
	 * @param auctionRecordModel
	 * @return
	 */
	public Response<Integer> updatePayFlagForOrder(AuctionRecordModel auctionRecordModel);
}
