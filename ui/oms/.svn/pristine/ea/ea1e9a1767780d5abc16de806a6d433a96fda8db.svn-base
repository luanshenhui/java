package cn.rkylin.oms.push.controller;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CachePut;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;

import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.oms.ectrade.service.IEcTradeService;
import cn.rkylin.oms.ectrade.vo.EcTradeVO;
import cn.rkylin.oms.order.domain.EcTrade;
import cn.rkylin.oms.push.adapter.PushAdapter;
import cn.rkylin.oms.push.adapter.PushAdapterFactory;
import cn.rkylin.oms.system.shop.domain.Shop;
import cn.rkylin.oms.system.shop.service.IShopService;
import cn.rkylin.oms.system.shop.vo.ShopVO;

@Controller
@RequestMapping("/push")
public class PushTradeController  extends ApolloController {
	private static final Log logger = LogFactory.getLog(PushTradeController.class);
	@Resource(name = "redisTemplate")
	private RedisTemplate<Serializable, Serializable> redisTemplate;
	/**
     * 店铺服务层
     */
    @Autowired
    private IShopService shopService;
    @Autowired
	private IEcTradeService ecTradeService;
    
    /**
     * 数据推送到平台
     * @param json
     * @return
     * @throws Exception
     */
	@ResponseBody
	@RequestMapping(value = "/pushData")
	public Map<String, Object> pushData(@RequestParam(required = false, defaultValue = "")String json) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try{
			//如果json是空返回错误
			if (StringUtils.isBlank(json)){
				returnMap.put("success", "n");
				returnMap.put("msg", "json是空");
				return returnMap;
			}

			//json转换成为map
			Map<String,String> map = JSON.parseObject(json, Map.class);
			if (map == null){
				returnMap.put("success", "n");
				returnMap.put("msg", "json是空");
				return returnMap;
			}
			
			String tid = map.get("tid");
			//tid交易号如果没有的场合
			if (StringUtils.isBlank(tid)){ 
				returnMap.put("success", "n");
				returnMap.put("msg", "交易数据不存在");
				return returnMap;
			}
			if (!StringUtils.isNumeric(tid)){
				returnMap.put("success", "n");
				returnMap.put("msg", "交易编号不正确");
				return returnMap;
			}
			
			//根据tid取得ectrade的主键
			List<String> listEctrade = getEcTrade(tid);
			if (listEctrade==null || listEctrade.size() <= 0){
				returnMap.put("success", "n");
				returnMap.put("msg", "交易数据不存在");
				return returnMap;
			}
			
			//取得原始单据的shopID
			String shopId = getShopIdByTrade(listEctrade);
			
			//取得shop对象
			if (StringUtils.isBlank(shopId)){
				returnMap.put("success", "n");
				returnMap.put("msg", "交易数据店铺不存在");
				return returnMap;
			}
			
			Shop shop = getShop(shopId);
			if (shop == null){
				returnMap.put("success", "n");
				returnMap.put("msg", "交易数据店铺不存在");
				return returnMap;
			}
			
			PushAdapter pushAdapter = PushAdapterFactory.getPushAdapter(map,shop);
			if (pushAdapter==null){
				returnMap.put("success", "n");
				returnMap.put("msg", "推送失败");
				return returnMap;
			}
			returnMap = pushAdapter.pushData(shop,map);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			returnMap.put("success", "n");
			returnMap.put("msg", "e.getMessage()");
		}
		return returnMap;
	}
	
	private String getShopIdByTrade(List<String> listEctradeId){
		String shopId = "";
		try{
			for (int i = 0 ; i < listEctradeId.size() ; i++){
				EcTradeVO ecTradeVO  = ecTradeService.getEcTradeById(listEctradeId.get(i));	
				if (ecTradeVO.getEcTradeId().equals(ecTradeVO.getParentTradeId())){
					shopId = ecTradeVO.getShopId();
					break;
				}
			}	
		} catch(Exception e){
			logger.error(e.getMessage());
		}
		return shopId;
	}
	
	/**
	 * 根据shopId取得shop对象
	 * @param shopid
	 * @return
	 */
	@CachePut(value="shop", key="T(String).valueOf('shop:').concat(#shopid)")
	private Shop getShop(String shopid){
		Shop shop=null;
		try {
			//从redis中获取数据
			ValueOperations<Serializable, Serializable> valueops = redisTemplate.opsForValue();
			
			if (StringUtils.isNotBlank(shopid)){
				shop = (Shop)valueops.get("shop:".concat(shopid));
			}
			if (shop==null){
				ShopVO shopVO = StringUtils.isNotBlank(shopid)?shopService.getShopById(shopid):null;
				BeanUtils.copyProperties(shopVO, shop);
			}
		} catch(Exception e){
			logger.error(e.getMessage());
			shop = null;
		}
		return shop;
	}
	
	/**
	 * 根据tid取得Ectrade对象
	 * @param tid
	 * @return
	 */
	@CachePut(value="EcTrade", key="T(String).valueOf('ecTrade:').concat(#tid)")
	private List<String> getEcTrade(String tid){
		List<String> listEctrade = null;
		try {
			//从redis中获取数据
			ValueOperations<Serializable, Serializable> valueops = redisTemplate.opsForValue();
			
			//从redis中取得订单信息
			listEctrade = (List<String>)valueops.get("tid:".concat(tid));
			//如果redis中没找到就从数据库中取得
			if (listEctrade==null || listEctrade.size()<=0){
				EcTradeVO parameter = new EcTradeVO();
				EcTradeVO ecTradeVO = null;
				parameter.setEcTradeCode(tid);
				List<EcTradeVO> list  = ecTradeService.findByTid(parameter);
				if (list!=null){
					for (int i = 0 ; i < list.size() ; i++){
						ecTradeVO = list.get(i);
						listEctrade.add(ecTradeVO.getEcTradeId());
					}
				}
			}
		} catch(Exception e){
			logger.error(e.getMessage());
			listEctrade = null;
		}
		return listEctrade;
	}
	
}
