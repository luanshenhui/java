package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import jodd.util.URLDecoder;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAdd;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAddReturn;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteAddVO;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;

/**
 * MAL301 添加收藏商品(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL301")
@Slf4j
public class StageMallFavoriteAddProvideServiceImpl implements  SoapProvideService <StageMallFavoriteAddVO,StageMallFavoriteAddReturnVO>{
	@Resource
	UserFavoriteService userFavoriteService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;

	@Override
	public StageMallFavoriteAddReturnVO process(SoapModel<StageMallFavoriteAddVO> model, StageMallFavoriteAddVO content) {
		StageMallFavoriteAdd stageMallFavoriteAdd = BeanUtils.copy(content, StageMallFavoriteAdd.class);
//		StageMallFavoriteAddReturn stageMallFavoriteAddReturn = stageMallFavoriteAddService.add(stageMallFavoriteAdd);
		StageMallFavoriteAddReturn stageMallFavoriteAddReturn = new StageMallFavoriteAddReturn();
		String cust_id = stageMallFavoriteAdd.getCustId();				//客户号
		String goods_id = stageMallFavoriteAdd.getGoodsId();			//商品编号
		String do_date = stageMallFavoriteAdd.getDoDate();				//添加日期
		String do_time = stageMallFavoriteAdd.getDoTime();				//添加时间
		String favorite_desc = "";
		favorite_desc = stageMallFavoriteAdd.getFavoriteDesc();	//添加详细信息
		String origin =  stageMallFavoriteAdd.getOrigin();				//发起方
		MemberGoodsFavoriteModel memberGoodsFavoriteModel = new MemberGoodsFavoriteModel();
		try {
			//APP渠道 中文需要用UTF-8转码
			if(Contants.PROMOTION_SOURCE_ID_09.equals(origin) && !Strings.isNullOrEmpty(favorite_desc)){
                favorite_desc = URLDecoder.decode(favorite_desc, "UTF8");
            }
			//需要判断包含中文的字段长度
			if(favorite_desc != null && favorite_desc.getBytes().length > 200){
				stageMallFavoriteAddReturn.setReturnCode("000008");
				stageMallFavoriteAddReturn.setReturnDes("报文参数错误:favorite_desc长度必须小于等于200");
				StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
						StageMallFavoriteAddReturnVO.class);
				return stageMallFavoriteAddReturnVO;
			}
			Response<ItemModel> itemModelResponse = itemService.findByCodeAll(goods_id);
			ItemModel itemModel = null;
			if(itemModelResponse.isSuccess()){
				itemModel = itemModelResponse.getResult();
			}

			if(itemModel == null){
				stageMallFavoriteAddReturn.setReturnCode("000010");
				stageMallFavoriteAddReturn.setReturnDes("商品信息错误");
				StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
						StageMallFavoriteAddReturnVO.class);
				return stageMallFavoriteAddReturnVO;
			}

			Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
			GoodsModel goodsModel = null;
			if(goodsModelResponse.isSuccess()){
				goodsModel = goodsModelResponse.getResult();
			}
			if(goodsModel == null){//商品信息不存在
				stageMallFavoriteAddReturn.setReturnCode("000010");
				stageMallFavoriteAddReturn.setReturnDes("商品信息错误");
				StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
						StageMallFavoriteAddReturnVO.class);
				return stageMallFavoriteAddReturnVO;
            }

			if(Contants.PROMOTION_SOURCE_ID_09.equals(origin)){//APP渠道
				if(!"02".equals(goodsModel.getChannelApp())){//APP状态不在上架状态
					stageMallFavoriteAddReturn.setReturnCode("000036");
					stageMallFavoriteAddReturn.setReturnDes("商品不在上架状态");
					StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
							StageMallFavoriteAddReturnVO.class);
					return stageMallFavoriteAddReturnVO;
				}
			}else{//手机渠道
				if (!"02".equals(goodsModel.getChannelPhone())){//手机状态不在上架状态
					stageMallFavoriteAddReturn.setReturnCode("000036");
					stageMallFavoriteAddReturn.setReturnDes("商品不在上架状态");
					StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
							StageMallFavoriteAddReturnVO.class);
					return stageMallFavoriteAddReturnVO;
				}
			}

			memberGoodsFavoriteModel.setCustId(cust_id);
			memberGoodsFavoriteModel.setItemCode(goods_id);
			memberGoodsFavoriteModel.setGoodsCode(goodsModel.getCode());
			memberGoodsFavoriteModel.setPrice(itemModel.getPrice()); // 实际价格
			memberGoodsFavoriteModel.setCreateOper(cust_id); // 创建人
			memberGoodsFavoriteModel.setCreateTime(new Date()); // 创建时间
			memberGoodsFavoriteModel.setDelFlag(0); // 逻辑删除标记 0：未删除 1：已删除
			memberGoodsFavoriteModel.setVendorId(goodsModel.getVendorId()); // 供应商id

			//是否已经收藏（1:收藏 0:未收藏）
			Response<String> checkResult = userFavoriteService.checkFavorite(memberGoodsFavoriteModel.getItemCode(), memberGoodsFavoriteModel.getCustId());
			if (checkResult.isSuccess()){
				if(!"0".equals(checkResult.getResult())) {
                    stageMallFavoriteAddReturn.setReturnCode("000043");
                    stageMallFavoriteAddReturn.setReturnDes("商品ID为："+goods_id+"的商品已经存在用户的商品收藏列表中。");
				}else{
                    userFavoriteService.insertPhoneFavorite(memberGoodsFavoriteModel);
					stageMallFavoriteAddReturn.setReturnCode("000000");
					stageMallFavoriteAddReturn.setReturnDes("收藏成功");
                }
			}
		} catch (Exception e) {
            stageMallFavoriteAddReturn.setReturnCode("000009");
            stageMallFavoriteAddReturn.setReturnDes("保存收藏信息出错");
        }

		StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
				StageMallFavoriteAddReturnVO.class);
		return stageMallFavoriteAddReturnVO;
	}

}
