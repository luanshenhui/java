package cn.com.cgbchina.batch.service.impl;

import cn.com.cgbchina.batch.service.BatchOrderService;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderCancelService;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-6-24.
 */
@Service
@Slf4j
public class BatchOrderServiceImpl implements BatchOrderService {
    @Resource
    private OrderCancelService orderCancelService;
    @Resource
    private GoodsService goodsService;

    public void overdueOrderProc() {
        try{
            //先往里加一个处理订单的log
            log.info("开始处理废单2.......");
            //获取当前日历
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -2);
            //计算出大于（超过）当前日历24小时的日期prevDate
            //String prevDate = DateHelper.getyyyyMMdd(cal.getTime());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String prevDate = sdf.format(cal.getTime());

            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("create_time",prevDate);
            int count=orderCancelService.getCountOverOrder(paramMap).getResult();
            //int fetchNo=100;
            String orderIdFlag="000000000000000001";
            if(count >0){
                log.info("废单数量count:"+count);
            }
//            int countFlag=0;
            while(count>0){
//                List<OrderSubModel> orderSubModelList=orderCancelService.getOverOrders(prevDate, orderIdFlag, fetchNo).getResult();
                List<OrderSubModel> orderSubModelList=orderCancelService.getOverOrders(prevDate, orderIdFlag, count).getResult();
                log.info("废单list数量"+orderSubModelList.size());
                if(orderSubModelList!=null && orderSubModelList.size()>0){
                    for(int i=0;i<orderSubModelList.size();i++){
                        String sourceId=orderSubModelList.get(i).getSourceId();
                        String ordermainId=orderSubModelList.get(i).getOrdermainId();
                        String orderId=orderSubModelList.get(i).getOrderId();
                        String ordertypeId=orderSubModelList.get(i).getOrdertypeId();
                        String ordertypeNm=orderSubModelList.get(i).getOrdertypeNm();
                        String goodsId=orderSubModelList.get(i).getGoodsId();
                        Integer goodsNum=orderSubModelList.get(i).getGoodsNum();
                        String goodsPaywayId=orderSubModelList.get(i).getGoodsPaywayId();
                        String actType=orderSubModelList.get(i).getActType();
                        String memberLevel=orderSubModelList.get(i).getMemberLevel();
                        String createOper=orderSubModelList.get(i).getCreateOper();
                        String curStatusId = null==orderSubModelList.get(i).getCurStatusId()?"":orderSubModelList.get(i).getCurStatusId().toString().trim();//hwh 20150906 修改  增加字段
                        //hwh 20150906 修改  增加curStatusId 订单状态
                        overdueOneOrderProcWithTxn(sourceId, ordermainId, orderId, ordertypeId, ordertypeNm, goodsId, goodsNum, goodsPaywayId, actType, memberLevel, createOper,curStatusId);//废一个订单
                        count--;
//                        if(i==orderSubModelList.size()-1){//如果是最后一条
//                            orderIdFlag=orderId;
//                        }
                    }
                }else{
                    break;
                }
//                if(countFlag==count){//防止死循环
//                    cenctrLogger.info("countFlag:"+countFlag+"count:"+count);
//                    break;
//                }
//                countFlag=count;
            }
            log.info("完成处理废单2.......");
        } catch (Exception e) {

            log.info("完成处理废单2失败.......");
        }


    }
    /**
     * 订单废单处理
     * @param sourceId
     * @param ordermainId
     * @param orderId
     * @param ordertypeId
     * @param ordertypeNm
     * @param goodsId
     * @param goodsNum
     * @param goodsPaywayId
     * @param actType
     * @param memberLevel
     * @param createOper
     * @param curStatusId  hwh 20150906 增加订单状态，对于处理中的订单，如果有
     */
    public void overdueOneOrderProcWithTxn(String sourceId,String ordermainId,String orderId,String ordertypeId,String ordertypeNm,String goodsId,int goodsNum,String goodsPaywayId,String actType,String memberLevel,String createOper,String curStatusId){
        log.info("开始处理废单:" + orderId);
        orderCancelService.updateOrderStatus(orderId, "0304", "已废单", "SYSTEM");//改小订单状态
        OrderCheckModel orderCheck = new OrderCheckModel();
        OrderSubModel order = orderCancelService.getTblOrder(orderId).getResult();
        /**  hwh 20150906 add  广发状态未明订单，根据订单号查询有没有插正交易，如果有，则查撤销记录 start **/
        if("FQ".equals(ordertypeId) && "0316".equals(curStatusId)
                && null!=order.getBonusTotalvalue() && order.getBonusTotalvalue()>0 ){
            List<OrderCheckModel> tempList = orderCancelService.getOrderCheckListByOrderId(orderId).getResult();
            if(null!=tempList&&tempList.size()>0){
                boolean successFlag = false,errorFlag =false;
                for (int index =0 ; index <tempList.size();index ++){
                    OrderCheckModel tempOrderCheck = tempList.get(index);
                    if(null!=tempOrderCheck){
                        String tempStatusId = tempOrderCheck.getCurStatusId();
                        //0305 处理中 0308 成功
                        if("0305".equals(tempStatusId) || "0308".equals(tempStatusId)){
                            successFlag=true;
                        }
                        //0312--已撤单 0327--退货成功 0307--支付失败 0380--拒绝签收 0381--无人签收
                        if("0312".equals(tempStatusId) || "0327".equals(tempStatusId)
                                ||"0307".equals(tempStatusId)||"0380".equals(tempStatusId)
                                ||"0381".equals(tempStatusId)){
                            errorFlag = true;
                        }
                    }

                }
                //有成功记录，没有撤销记录
                if(successFlag && !errorFlag){
                    orderCheck.setOrderId(orderId);
                    orderCheck.setCurStatusId("0312");
                    orderCheck.setCurStatusNm("已撤单");
                    orderCheck.setDoDate(DateHelper.getyyyyMMdd(order.getCreateTime()));
                    orderCheck.setDoTime(DateHelper.getHHmmss(order.getCreateTime()));
                    orderCheck.setIspoint("0");
                    orderCheck.setDelFlag(0);
                    orderCancelService.saveOrderCheck(orderCheck);
                }
            }
        }
        /**  hwh 20150906 add end **/
		/* -- 废单不送优惠劵负交易对账 -- modified by zwz at 20150114
		if(order.getVoucherNo()!=null&&!"".equals(order.getVoucherNo())){
			orderCheck.setOrderId(orderId);
			orderCheck.setCurStatusId("0304");
			orderCheck.setCurStatusNm("已废单");
			orderCheck.setDoDate(DateUtil.getyyyyMMdd());
			orderCheck.setDoTime(DateUtil.getHHmmss());
			orderCheck.setIscheck("0");
			tblOrderCheckDao.saveTblOrderCheck(orderCheck);
		}
		*/
        if("JF".equals(ordertypeId)){//如果是积分商城
            orderCancelService.updateOrderMainStatus(ordermainId, "0304", "已废单", "SYSTEM");//改大订单状态
        }
        //开放所有渠道商品库存回滚
        //if("00".equals(sourceId)||"03".equals(sourceId)||"04".equals(sourceId)){//商城页面渠道和手机渠道下的订单退回商品数量，活动人数，生日次数
        if("JF".equals(ordertypeId)){//如果是积分商城
            Long goodsNumLong = new Long(goodsNum);
            goodsService.updateGoodsJF(goodsId, goodsNumLong);//回滚商品数量
        }else{
            log.info("商品数量回滚。。。。。"+goodsNum);
            Long goodsNumLong = new Long(goodsNum);
            goodsService.updateGoodsYG(goodsId, goodsNumLong);//回滚商品数量
            if(order.getBonusTotalvalue()!=null&&order.getBonusTotalvalue().longValue()!=0){//回滚积分池
                //2015-05-13 ltl 修改废单回滚积分池回滚时间按订单创建时间为准
                //tblGoodsInfDao.dealPointPool(order.getBonusTotalvalue());
                Long bonusTotal = new Long(order.getBonusTotalvalue());
                log.info("积分回滚。。。。。。");
                goodsService.dealPointPoolForDate(bonusTotal,order.getCreateTime());
            }
        }
			/*--- 不回滚活动 --- modify by zwz at 20141212
			if("1".equals(actType)){//只回滚团购，不回滚秒杀的，，同一件商品下的所有活动信息都要更新
				tblOrderDao2.updateGoodsAct(goodsId, goodsNum,order.getCreateDate(),order.getCreateTime());
			}
			*/
//        try{
//            if("0004".equals(memberLevel)){//如果是生日价
//                int birthCount = (Integer)orderCancelService.getTblEspCustNew(createOper).getResult();
//                if(birthCount>0){
//                    if(birthCount-goodsNum>0){
//                        orderCancelService.updateTblEspCustNew(createOper, goodsNum);
//                    }else{
//                        orderCancelService.updateTblEspCustNew0(createOper);
//                    }
//                }
//            }
//        }catch(Exception e){
//            //TODO
////            cenctrLogger.error("exception", e);
//        }
        //	}
        log.info("插入订单处理历史："+orderId);
        orderCancelService.insertOrderDoDetail(orderId, "0304", "已废单", "SYSTEM");//插入履历
        log.info("完成处理废单:"+orderId);
    }
}
