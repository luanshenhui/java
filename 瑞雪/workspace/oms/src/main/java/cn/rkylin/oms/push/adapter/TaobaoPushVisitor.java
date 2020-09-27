package cn.rkylin.oms.push.adapter;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.LogisticsConsignResendRequest;
import com.taobao.api.request.LogisticsDummySendRequest;
import com.taobao.api.request.LogisticsOfflineSendRequest;
import com.taobao.api.request.LogisticsOnlineSendRequest;
import com.taobao.api.request.TradeMemoAddRequest;
import com.taobao.api.request.TradeMemoUpdateRequest;
import com.taobao.api.response.LogisticsConsignResendResponse;
import com.taobao.api.response.LogisticsDummySendResponse;
import com.taobao.api.response.LogisticsOfflineSendResponse;
import com.taobao.api.response.LogisticsOnlineSendResponse;
import com.taobao.api.response.TradeMemoAddResponse;
import com.taobao.api.response.TradeMemoUpdateResponse;

import cn.rkylin.oms.push.domain.PushTypeEnum;
import cn.rkylin.oms.system.shop.domain.Shop;

@Service("taobaoPushVisitor")
public class TaobaoPushVisitor extends PushVisitor {
	
	@Override
	public Map<String, Object> pushData(Shop shop, Map<String, String> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			String pushType = map.get("pushType");
			PushTypeEnum type = PushTypeEnum.valueOf(pushType);
			switch (type){
			case PUSHTRADEMEMOADD:
				result = this.pushTradeMemoAdd(shop , Long.valueOf(map.get("tid")),map.get("memo"),Long.valueOf(map.get("flag")));
				break;
			case PUSHTRADEMEMO:
				result = this.pushTradeMemo(shop , Long.valueOf(map.get("tid")),map.get("memo"),Long.valueOf(map.get("flag")));
				break;
			case PUSHTRADEONLINESEND:
				result = this.pushTradeOnlineSend(shop, Long.valueOf(map.get("tid")), map.get("out_sid"), map.get("company_code"));
				break;
			case PUSHTRADEONLINESEND_SPLIT:
				result = this.pushTradeOnlineSend_Split(shop, Long.valueOf(map.get("tid")), map.get("out_sid"), map.get("company_code"), map.get("sub_tid"));
				break;
			case PUSHTRADEOFFLINESEND:
				result = this.pushTradeOfflineSend(shop, Long.valueOf(map.get("tid")), map.get("out_sid"), map.get("company_code"));
				break;
			case PUSHTRADEOFFLINESEND_SPLIT:
				result = this.pushTradeOfflineSend_Split(shop, Long.valueOf(map.get("tid")), map.get("out_sid"), map.get("company_code"), map.get("sub_tid"));
				break;
			case PUSHTRADECONSIGNRESEND:
				result = this.pushTradeConsignResend(shop, Long.valueOf(map.get("tid")), map.get("out_sid"), map.get("company_code"));
				break;
			case PUSHTRADEDUMMYSEND:
				result = this.pushTradeDummySend(shop, Long.valueOf(map.get("tid")));
				break;
			}	
		} catch(Exception e) {
			result.put("success", "n");
			result.put("msg", e.getMessage());
		}
		
		return result;
	}
	
	/**
	 * 对一笔交易添加备注
	 * @param tid 交易编号
	 * @param memo 备注
	 * @param flag 交易备注旗帜，可选值为：0(灰色), 1(红色), 2(黄色), 3(绿色), 4(蓝色), 5(粉红色)，默认值为0
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeMemoAdd(Shop shop ,Long tid, String memo, Long flag) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			TradeMemoAddRequest req = new TradeMemoAddRequest();
			req.setTid(tid);
			req.setMemo(memo);
			req.setFlag(flag);
			TradeMemoAddResponse rsp = client.execute(req, shop.getSessionKey());
			//操作错误，返回错误结果
           if (!rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	/**
	 * 修改一笔交易备注
	 * @param tid 交易编号
	 * @param memo 备注
	 * @param flag 交易备注旗帜，可选值为：0(灰色), 1(红色), 2(黄色), 3(绿色), 4(蓝色), 5(粉红色)，默认值为0
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeMemo(Shop shop, Long tid, String memo, Long flag) throws Exception {
       Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			TradeMemoUpdateRequest req = new TradeMemoUpdateRequest();
			req.setTid(tid);
			req.setMemo(memo);
			req.setFlag(flag);
			TradeMemoUpdateResponse rsp = client.execute(req, shop.getSessionKey());
			
			//操作错误，返回错误结果
           if (!rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }

		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
	}
	
	/**
	 * 在线订单发货处理（支持货到付款）
	 * @param tid 交易号
	 * @param out_sid 运单号.具体一个物流公司的真实运单号码
	 * @param company_code 物流公司代码.如"POST"就代表中国邮政,"ZJS"就代表宅急送
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeOnlineSend(Shop shop, Long tid, String out_sid, String company_code) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			LogisticsOnlineSendRequest req = new LogisticsOnlineSendRequest();
			req.setTid(tid);
           req.setCompanyCode(company_code);
           if (StringUtils.isNotBlank(out_sid)) {
           	req.setOutSid(out_sid);
           }
           LogisticsOnlineSendResponse rsp = client.execute(req, shop.getSessionKey());
           if (rsp.getShipping() == null || !rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
           
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	/**
	 * 在线订单发货处理（支持货到付款）
	 * @param tid 交易号
	 * @param out_sid 运单号.具体一个物流公司的真实运单号码
	 * @param company_code 物流公司代码.如"POST"就代表中国邮政,"ZJS"就代表宅急送
	 * @param sub_tid
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeOnlineSend_Split(Shop shop, Long tid, String out_sid, String company_code, String sub_tid) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			LogisticsOnlineSendRequest req = new LogisticsOnlineSendRequest();
			req.setTid(tid);
           req.setCompanyCode(company_code);
           if (StringUtils.isNotBlank(out_sid)) {
           	req.setOutSid(out_sid);
           }
           req.setIsSplit(1L);
           String subtids = "";
           if (sub_tid!=null){
        	   String[] temp = sub_tid.split(","); 
	           	for(int i = 0 ; i < temp.length ; i++){
	           		if (i==0){
	           			subtids = temp[i];
	           		} else {
	           			subtids = subtids + "," + temp[i];
	           		}
	           		
	           	}
           }
           req.setSubTid(subtids);
           LogisticsOnlineSendResponse rsp = client.execute(req, shop.getSessionKey());
           if (rsp.getShipping() == null || !rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
			
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	/**
	 * 自己联系物流（线下物流）发货
	 * @param tid 交易号
	 * @param out_sid 运单号.具体一个物流公司的真实运单号码
	 * @param company_code 物流公司代码.如"POST"就代表中国邮政,"ZJS"就代表宅急送
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeOfflineSend(Shop shop, Long tid, String out_sid, String company_code) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			LogisticsOfflineSendRequest req = new LogisticsOfflineSendRequest();
			req.setTid(tid);
           req.setCompanyCode(company_code);
           req.setOutSid(out_sid);
           LogisticsOfflineSendResponse rsp = client.execute(req, shop.getSessionKey());
           if (rsp.getShipping() == null || !rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	/**
	 * 自己联系物流（线下物流）发货
	 * @param tid 交易号
	 * @param out_sid 运单号.具体一个物流公司的真实运单号码
	 * @param company_code 物流公司代码.如"POST"就代表中国邮政,"ZJS"就代表宅急送
	 * @param sub_tid
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeOfflineSend_Split(Shop shop, Long tid, String out_sid, String company_code, String sub_tid) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			LogisticsOfflineSendRequest req = new LogisticsOfflineSendRequest();
			req.setTid(tid);
           req.setCompanyCode(company_code);
           req.setOutSid(out_sid);
           String subtids = "";
           if (sub_tid!=null){
        	   String[] temp = sub_tid.split(","); 
	           	for(int i = 0 ; i < temp.length ; i++){
	           		if (i==0){
	           			subtids = temp[i];
	           		} else {
	           			subtids = subtids + "," + temp[i];
	           		}
	           		
	           	}
           }
           req.setIsSplit(1L);
           LogisticsOfflineSendResponse rsp = client.execute(req, shop.getSessionKey());
           if (rsp.getShipping() == null || !rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	/**
	 * 自己联系物流（线下物流）发货
	 * @param tid 交易号
	 * @param out_sid 运单号.具体一个物流公司的真实运单号码
	 * @param company_code 物流公司代码.如"POST"就代表中国邮政,"ZJS"就代表宅急送
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeConsignResend(Shop shop, Long tid, String out_sid, String company_code) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			LogisticsConsignResendRequest req = new LogisticsConsignResendRequest();
			req.setTid(tid);
           req.setCompanyCode(company_code);
           req.setOutSid(out_sid);
           LogisticsConsignResendResponse rsp = client.execute(req, shop.getSessionKey());
           if (rsp.getShipping() == null || !rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	/**
	 * 无需物流（虚拟）发货处理
	 * @param tid 交易号
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pushTradeDummySend(Shop shop, Long tid) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
       String strError = "";
		try{
			TaobaoClient client = new DefaultTaobaoClient(shop.getApiUrl(), shop.getAppKey(), shop.getAppSecret());
			LogisticsDummySendRequest req = new LogisticsDummySendRequest();
			req.setTid(tid);
			LogisticsDummySendResponse rsp = client.execute(req, shop.getSessionKey());
			if (rsp.getShipping() == null || !rsp.isSuccess())
           {
               if (StringUtils.isNotBlank(rsp.getSubMsg()))
               {
                   strError = rsp.getSubMsg();
               }
               else
               {
                   strError = rsp.getMsg();
               }
               returnMap.put("success", "n");
               returnMap.put("msg", strError);
           }
           else
           {
           	returnMap.put("success", "y");
               returnMap.put("msg", "");
           }
			
		} catch(Exception e){
			e.printStackTrace();
			returnMap.put("success", "n");
           returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}

}
