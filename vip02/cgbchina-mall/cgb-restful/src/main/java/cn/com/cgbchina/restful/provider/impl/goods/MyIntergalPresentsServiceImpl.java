package cn.com.cgbchina.restful.provider.impl.goods;

import cn.com.cgbchina.item.model.IntegrationGiftModel;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresents;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsQuery;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsReturn;
import cn.com.cgbchina.rest.provider.service.goods.MyIntergalPresentsService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;


//适合我的积分礼品查询接口实现
@Service
@Slf4j
public class MyIntergalPresentsServiceImpl implements MyIntergalPresentsService {
	private static final int REGIONID_DEFAULT = -1;
	@Resource
	RestItemService restItemService;
	@Value("#{app.mallGiftUrl}")
	private String mallGiftUrl;

	@Override
	public MyIntergalPresentsReturn query(MyIntergalPresentsQuery myIntergalPresentsQuery) {
		// 定义返回值
		MyIntergalPresentsReturn resultData = new MyIntergalPresentsReturn();
		// 调用方标识:如CC:01 IVR:02 bps:11 个人网银:12
		String origin = myIntergalPresentsQuery.getOrigin();
		// 商城类型标识,如分期商城:01 积分商城02
		String mallType = myIntergalPresentsQuery.getMallType();
		// 积分值，积分类型必须为普通积分
		String bonus = myIntergalPresentsQuery.getBonus();
		// 积分值转化为long型
		long bonusL = new Long(bonus).longValue();
		// 根据积分值查询积分区间ID 如果没有返回-1
		Response<Integer> result = restItemService.getRegionFromBonus(bonusL);// 得到积分值对应的区间，如果没有，返回-1
		// 判断是否查询成功
		if (result.isSuccess()) {
			Integer regionId = result.getResult();
			if (regionId == REGIONID_DEFAULT) {// 如果是-1，找不到对应区间
				log.info("没有查找到相应区间");
				// 原代码是将区间ID设置为999999 继续执行
				regionId = 999999;
			}
			// 继续处理
			// 根据区间id regionId 查出礼品信息
			Response<List<IntegrationGiftModel>> data = restItemService.getItemGiftListByRegionId(regionId);
			if (data.isSuccess()) {
				List<IntegrationGiftModel> list = data.getResult();
				if (list != null && list.size() >= 0) {
					List<MyIntergalPresents> resultList = new ArrayList<MyIntergalPresents>();
					for (IntegrationGiftModel integrationGiftModel : list) {
						if(integrationGiftModel.getJpBonus() == null){
							continue;
						}
						MyIntergalPresents myIntergalPresent = new MyIntergalPresents();
						myIntergalPresent.setGoodsId(integrationGiftModel.getItemCode());
						myIntergalPresent.setGoodsNm(integrationGiftModel.getName());
						myIntergalPresent.setGoodsUrl(integrationGiftModel.getGoodsUrl());
						myIntergalPresent.setGoodsXid(integrationGiftModel.getXid());
						myIntergalPresent.setJpBonus(String.valueOf(integrationGiftModel.getJpBonus()));
						myIntergalPresent.setPictureUrl(integrationGiftModel.getPictureUrl());
						myIntergalPresent.setGoodsUrl(MessageFormat.format(mallGiftUrl, integrationGiftModel.getGoodsCode(),integrationGiftModel.getItemCode()));// 详细页面url
						myIntergalPresent.setVendorFnm(integrationGiftModel.getVendorFnm());
						// 放入list
						resultList.add(myIntergalPresent);
					}
					// 设置返回参数
					resultData.setMyIntergalPresentses(resultList);
					// 设置returnCode
					resultData.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				}
			} else {
				log.error("【MyIntergalPresentsServiceImpl.query】根据区间ID查询积分商品信息发生异常");
				resultData.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
				resultData.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
			}
		} else {
			// 失败则返回信息
			resultData.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			resultData.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
			return resultData;
		}

		return resultData;
	}

}
