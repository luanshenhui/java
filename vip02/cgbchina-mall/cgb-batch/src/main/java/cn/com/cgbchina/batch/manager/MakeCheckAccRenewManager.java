package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.MakeCheckAccRenewDao;
import cn.com.cgbchina.batch.model.CCCheckAccOrderModel;
import cn.com.cgbchina.batch.model.OrderMainModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.batch.model.TblMakecheckjobHistoryModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.CheckAccFileUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.FTSUtil;
import cn.com.cgbchina.common.utils.StringUtils;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by w2001316 on 2016/7/29.
 */
@Component
@Slf4j
public class MakeCheckAccRenewManager {

    @Resource
    private MakeCheckAccRenewDao makeCheckAccRenewDao;
    @Autowired
    private MakeCheckAccRenewSubManager makeCheckAccRenewSubManager;
    @Value("#{app.ftsTaskid}")
    private String ftsTaskIdStr;
    @Value("#{app.ftsIp}")
    private String ftsIpStr;
    @Value("#{app.ftsPort}")
    private String ftsPortStr;
    @Value("#{app.ftsTimeout}")
    private String ftsTimeOutStr;
    @Value("#{app.checkAccTxtJf}")
    private String filePathTmp;
    @Value("#{app.checkAccTxtJfTarget}")
    private String targetFilePathTmp;
    @Value("#{app.checkAccTxtJfTxt}")
    private String fileNameTmp;
    @Value("#{app.checkAccTxtJfTxtEnd}")
    private String endFileNameTmp;
    @Value("#{app.mode}")
    private String mode;

    public void makeCheckAccRenewWithTxn() {
        log.info("MakeCheckAccRenewService makeCheckAccRenewWithTxn start");
        try {
            String isShouDong = makeCheckAccRenewDao.getisShouDong();
            log.info("是否手动标志:" + isShouDong);
            if ("1".equals(isShouDong)) { //如果是自动处理
                List<String> days = makeCheckAccRenewDao.getMakeAccErrDays();
                log.info("大小是：" + days.size());
                if (days.isEmpty()) return;

                int ftsPortInt = -1;
                int ftsTimeOutInt = -1;
                log.info("ftpIpStr:" + ftsIpStr + ",ftpPortStr:" + ftsPortStr + ",ftpTimeOutStr:" + ftsTimeOutStr);
                if (null == ftsTaskIdStr || 0 == ftsTaskIdStr.length() || null == ftsIpStr || 0 == ftsIpStr.length() || null == ftsPortStr || 0 == ftsPortStr.length() || null == ftsTimeOutStr || 0 == ftsTimeOutStr.length()) {
                    log.error("fts配置有误.");
                    return;
                }
                try {
                    ftsPortInt = Integer.parseInt(ftsPortStr);
                    ftsTimeOutInt = Integer.parseInt(ftsTimeOutStr);
                } catch (Exception e) {
                    log.error("fts端口转换出错:{}", Throwables.getStackTraceAsString(e));
                }
                //构造fts传输对象
                FTSUtil ftsUtil = new FTSUtil(ftsIpStr, ftsPortInt, ftsTimeOutInt, mode);
                CheckAccFileUtil checkAccFileUtil = new CheckAccFileUtil();

                for (String day : days) {
                    log.info("重跑批监控,天数：{}",day);
                    BufferedWriter bwJfdj = null;
                    BufferedWriter bwJfdjEnd = null;
                    try {
        				// 返回昨天日期对象
        				Date preDate = DateHelper.string2Date(day, DateHelper.YYYYMMDD);
                        String filePath = filePathTmp;
                        String targetFilePath = targetFilePathTmp;
                        //文件路径
                        log.info("配置文件路径filePath:" + filePath + ",targetFilePath:" + targetFilePath);
                        filePath = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN, Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, filePath, null);
                        targetFilePath = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN, Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, targetFilePath, null);
                        log.info("转换后的路径filePath:" + filePath + ",targetFilePath:" + targetFilePath);
                        File file = new File(filePath);
                        if (!file.exists()) {//文件目录不存在，创建目录
                            //创建目录并赋予777权限
                            if (!checkAccFileUtil.createDirectory(filePath)) {
                                log.error("文件夹创建失败：" + filePath);
                                throw new Exception("文件夹创建失败：" + filePath);
                            }
                            log.info("文件夹创建成功：" + filePath);
                        }
                        //目标文件名，目标结束文件名
                        String fileName = fileNameTmp;
                        String endFileName = endFileNameTmp;
                        log.info("fileName:" + fileName + ",endFileName:" + endFileName);
                        //先转换出结束文件名，再转换出目标文件名
                        //记录文件
                        fileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN, Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, fileName, null);
                        fileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_JF_DATE_PATTERN, Contants.CHECK_ACC_JF_DATE_PATTERN_REPLACE, fileName, preDate);
                        //结束文件
                        endFileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN, Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, endFileName, null);
                        endFileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_JF_DATE_PATTERN, Contants.CHECK_ACC_JF_DATE_PATTERN_REPLACE, endFileName, preDate);

                        String fullFileName = filePath + fileName;//对账文件完整路径
                        String fullEndFileName = filePath + endFileName;//对账文件结束文件完整路径
                        //对账文件filewrite
                        FileWriter fwJfdj = new FileWriter(fullFileName);
                        bwJfdj = new BufferedWriter(fwJfdj);
                        String payResultTime = makeCheckAccRenewDao.getdbtime();
                        //查出昨天的然后生成对账文件
                        // 处理大订单订单(积分商城)
                        int sumOrder = makeCheckAccRenewDao.getSumCheckAccOrderMain(day, payResultTime);// 获取总数
                        log.info("重跑批监控：积分商城正交易订单数：{}",sumOrder);
                        for (int i = 0; i < sumOrder; i = i + 1000) {
                            List<OrderMainModel> orders = makeCheckAccRenewDao.getCheckAccOrderMain(i, 1000, day, payResultTime);// 获取5条小订单信息
                            for (OrderMainModel orderMainModel : orders) {
                                String createDate = DateHelper.getyyyyMMdd(orderMainModel.getCreateTime());
                                String serialNo = StringUtils.trim(orderMainModel.getSerialNo());
                                String ordermainId = StringUtils.trim(orderMainModel.getOrdermainId());
                                String ismerge = StringUtils.trim(orderMainModel.getIsmerge());
                                String integraltypeId = StringUtils.trim(orderMainModel.getIntegraltypeId());
                                String defraytype = StringUtils.trim(orderMainModel.getDefraytype());
                                String totalPrice = StringUtils.trim(String.valueOf(orderMainModel.getTotalPrice()));
                                String totalBonus = StringUtils.trim(String.valueOf(orderMainModel.getTotalBonus()));
                                String cardno = StringUtils.trim(orderMainModel.getCardno());
                                String createTime = DateHelper.getHHmmss(orderMainModel.getCreateTime());
                                String sourceId = StringUtils.trim(orderMainModel.getSourceId());
                                String tradeCode = null;// 交易码
                                if ("0".equals(ismerge)) {// 是合并支付
                                    tradeCode = "bms103";
                                } else {// 不是合并支付
                                    tradeCode = "bms102";
                                }
                                String sourceNm = "";
                                sourceNm = sourceIdChangeToChannel(sourceId);
                                String line = sourceNm + "|" + createDate + "|" + createTime + "|" + serialNo + "|"
                                        + tradeCode + "|" + cardno + "||" + integraltypeId + "||CNY|||" + totalBonus + "||" + "02" + "|" + ordermainId;;
                                bwJfdj.write(line);
                                bwJfdj.newLine();
                            }

                        }

                        // 处理子订单(cc渠道)
                        sumOrder = makeCheckAccRenewDao.getSumCCCheckAccOrder(day, payResultTime);// 总数
                        log.info("重跑批监控：cc积分商城正交易子订单数：{}",sumOrder);
                        log.info("CC渠道总数：" + sumOrder);
                        for (int i = 0; i < sumOrder; i = i + 1000) {
                            List<CCCheckAccOrderModel> orders = makeCheckAccRenewDao.getCCCheckAccOrder(i, 1000, day, payResultTime);// 获取5条小订单信息
                            for (CCCheckAccOrderModel ccCheckAccOrderModel : orders) {
                                String ordermainId = StringUtils.trim(ccCheckAccOrderModel.getOrdermainId());
                                String cardNo = StringUtils.trim(ccCheckAccOrderModel.getCardNo());
                                String txnDate = DateHelper.getyyyyMMdd(ccCheckAccOrderModel.getCreateTime());
                                String serialNo = StringUtils.trim(ccCheckAccOrderModel.getSerialNo());
                                String defrayType = StringUtils.trim(ccCheckAccOrderModel.getDefrayType());
                                String amount = StringUtils.trim(String.valueOf(ccCheckAccOrderModel.getAmount()));
                                String bonusType = StringUtils.trim(ccCheckAccOrderModel.getBonusType());
                                String bonusValue = StringUtils.trim(String.valueOf(ccCheckAccOrderModel.getBonusValue()));
                                String bonusTxnCode = StringUtils.trim(ccCheckAccOrderModel.getBonusTxnCode());
                                String ismerge = StringUtils.trim(ccCheckAccOrderModel.getIsmerge());
                                String createTime = DateHelper.getHHmmss(ccCheckAccOrderModel.getCreateTime());
                                String tradeCode = null;
                                if ("0".equals(ismerge)) {// 是合并支付
                                    tradeCode = "bms103";
                                } else {// 不是合并支付
                                    tradeCode = "bms102";
                                }
                                String line = "CCAG|" + txnDate + "|" + createTime + "|" + serialNo + "|"
                                        + tradeCode + "|" + cardNo + "||" + bonusType + "||CNY|||" + bonusValue + "||" + "02" + "|" + ordermainId;;
                                bwJfdj.write(line);
                                bwJfdj.newLine();
                            }
                        }

                        //处理退货以及撤销订单
                        List<String> orderCancelList = makeCheckAccRenewDao.getSumTblOrderCancel(day);
                        log.info("重跑批监控：积分商城退货撤销订单数：{}",orderCancelList.size());
                        for (String orderId : orderCancelList) {
                            log.info("orderId：" + orderId);
                            List<OrderMainModel> lst = makeCheckAccRenewDao.getTblOrderCancelList(StringUtils.trim(orderId));
                            for (OrderMainModel orderMainModel : lst) {
                                String cardNo = orderMainModel.getCardno();
                                String ordermainId = StringUtils.trim(orderMainModel.getOrdermainId());
                                String createDate = DateHelper.getyyyyMMdd(orderMainModel.getCreateTime());
                                String createTime = DateHelper.getHHmmss(orderMainModel.getCreateTime());
                                String serialNo = orderMainModel.getSerialNo();
                                Long bonusValue = orderMainModel.getBonusTotalvalue();
                                String bonusType = orderMainModel.getBonusType();
                                String sourceId = orderMainModel.getSourceId();
                                String tradeCode = "bms203";
                                // --部分退积分判断 hwh add 福袋部分退积分
                                Long bonusValueRe = makeCheckAccRenewDao.getRefundIntegralByBonus(orderId);
                                if (bonusValueRe != null) {
                                    bonusValue = bonusValueRe;
                                }

                                //"00"代表商城渠道 "01"、"02"代表积分渠道,"03"代表手机渠道
                                String sourceNm = sourceIdChangeToChannel(sourceId);
                                String line = sourceNm + "|" + createDate + "|" + createTime + "|" + serialNo + "|"
                                        + tradeCode + "|||" + bonusType + "||CNY|||" + bonusValue.toString() + "||" + "02" + "|" + ordermainId;;
                                // 根据订单的卡号，调用试运行公共类CgbUtils.java的isPractiseRun方法获取试运行标志
                                bwJfdj.write(line);
                                bwJfdj.newLine();
                            }
                        }
                        Long id1 = null;//正交易当天最大的自增ID
                        Long id2 = null;//负交易当天最大的自增ID
                        //处理广发商城积分支付（正交易）
                        List<OrderSubModel> oList = makeCheckAccRenewDao.getTblOrderPointList2(day);
                        log.info("处理广发商城积分支付正交易数量:"+ oList.size()+"时间："+day);
                        int index = 0;
                        for (OrderSubModel orderSubModel : oList) {
                            String serialNo = StringUtils.dealNull(orderSubModel.getOrderIdHost());
                            String createDate = StringUtils.dealNull(DateHelper.getyyyyMMdd(orderSubModel.getCreateTime()));
                            String createTime = StringUtils.dealNull(DateHelper.getHHmmss(orderSubModel.getCreateTime()));
                            String cardNo = StringUtils.dealNull(orderSubModel.getCardno());
                            String integraltypeId = StringUtils.dealNull(orderSubModel.getIntegraltypeId());
                            String bonusTotalvalue = String.valueOf(orderSubModel.getBonusTotalvalue());
                            String sourceId = StringUtils.dealNull(orderSubModel.getSourceId());
                            String curStatusId = StringUtils.dealNull(orderSubModel.getCurStatusId());
                            String terminalId = "";
                            String orderId = "";
                            if ("JF".equals(orderSubModel.getOrdertypeId())) {
                                terminalId = "02";
                                orderId = orderSubModel.getOrdermainId();
                            } else if ("YG".equals(orderSubModel.getOrdertypeId()) || "FQ".equals(orderSubModel.getOrdertypeId())) {
                                terminalId = "01";
                                orderId = orderSubModel.getOrderId();
                            }
                            if (index++ == 0) {
                                id1 = orderSubModel.getId();
                            }
                            String sourceNm = sourceIdChangeToChannel(sourceId);
                            String tradeCode = "";
                            String line = "";
                            tradeCode = "bms103";
                            line = sourceNm + "|" + createDate + "|" + createTime + "|" + serialNo + "|"
                                    + tradeCode + "|" + cardNo + "||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||" + terminalId + "|" + orderId;;
                            bwJfdj.write(line);
                            bwJfdj.newLine();
                        }
                        //处理广发/积分商城积分支付（负交易）
                        List<OrderSubModel> oList1 = makeCheckAccRenewDao.getTblOrderPointList3(day);
                        log.info("处理广发商城积分支付负交易数量:" + oList1.size() + "时间：" + day);
                        index = 0;
                        for (OrderSubModel orderSubModel : oList1) {
                            String serialNo = "";
                            String orderTypeId = StringUtils.dealNull(orderSubModel.getOrdertypeId());
                            String terminalId = "";
                            String orderId = "";
                            //积分商城的订单流水号取大订单表中的SERIAL_NO,广发商城的积分对账流水号，取小订单表中的ORDER_ID_HOST
                            if ("JF".equals(orderTypeId)) {
                                serialNo = StringUtils.dealNull(orderSubModel.getSerialNo());
                                terminalId = "02";
                                orderId = orderSubModel.getOrdermainId();
                            } else if ("YG".equals(orderTypeId) || "FQ".equals(orderTypeId)) {
                                serialNo = StringUtils.dealNull(orderSubModel.getOrderIdHost());
                                terminalId = "01";
                                orderId = orderSubModel.getOrderId();
                            }
                            String createDate = StringUtils.dealNull(DateHelper.getyyyyMMdd(orderSubModel.getCreateTime()));
                            String createTime = StringUtils.dealNull(DateHelper.getHHmmss(orderSubModel.getCreateTime()));
                            String cardNo = StringUtils.dealNull(orderSubModel.getCardno());
                            String integraltypeId = StringUtils.dealNull(orderSubModel.getIntegraltypeId());
                            String bonusTotalvalue = String.valueOf(orderSubModel.getBonusTotalvalue());
                            String sourceId = StringUtils.dealNull(orderSubModel.getSourceId());
                            String curStatusId = StringUtils.dealNull(orderSubModel.getCurStatusId());
                            if (index++ == 0) {
                                id2 = orderSubModel.getId();
                            }
                            String sourceNm = sourceIdChangeToChannel(sourceId);
                            String tradeCode = "";
                            String line = "";
                            String ocDoDate = StringUtils.dealNull(orderSubModel.getDoDate()); //积分撤销实际日期时间
                            String ocDOTime = StringUtils.dealNull(orderSubModel.getDoTime());
                            String jfRefundSerialno = StringUtils.dealNull(orderSubModel.getJfRefundSerialno()); //积分撤销流水
                            //暂时只有分期订单bps失败，会主动撤销 （ordercheck状态0307支付失败）
                            if ("FQ".equals(orderTypeId) && Contants.ORDER_STATUS_CODE_ERROR_ORDERS.equals(curStatusId)) {
                                tradeCode = "bms202";//nsct009主动撤销
                                //对于历史的数据，积分撤销流水为空
                                if (null == jfRefundSerialno || 0 == jfRefundSerialno.trim().length()) {
                                    continue;
                                }
                                /** 渠道类型（渠道类型码）、日期、流水号、交易码、卡号、积分类型、消费类型、币种（CNY）、
                                 * 交易总金额(商城可为空)、积分支付金额(商城可为空)、积分交易额、商户编号(商城可为空)、终端号(商城可为空)
                                 */
                                line = sourceNm + "|" + ocDoDate + "|" + ocDOTime + "|" + jfRefundSerialno + "|"
                                        + tradeCode + "|" + cardNo + "||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||" + terminalId + "|" + orderId;;
                            } else {
                                tradeCode = "bms203";
                                line = sourceNm + "|" + createDate + "|" + createTime + "|" + serialNo + "|"
                                        + tradeCode + "|||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||" + terminalId + "|" + orderId;;
                            }
                            /** 修改:对于FQ支付失败订单，白天发起主动积分撤销，晚上对账bms202 end */
                            bwJfdj.write(line);
                            bwJfdj.newLine();
                        }
                        bwJfdj.flush();
                        bwJfdj.close();
                        bwJfdj = null;
                        FileWriter fwJfdjEnd = new FileWriter(fullEndFileName);
                        bwJfdjEnd = new BufferedWriter(fwJfdjEnd);
                        bwJfdjEnd.flush();
                        bwJfdjEnd.close();
                        bwJfdjEnd = null;
                        File jfdjFile = new File(fullFileName);
                        File jfdjEndFile = new File(fullEndFileName);
                        if (jfdjFile.exists() && 0 != jfdjFile.length() && jfdjEndFile.exists()) {
                            try {
                                Runtime.getRuntime().exec(" chmod 777 " + fullFileName);
                            } catch (Exception rightEx) {
                                log.error("chmod 777 " + fullFileName + "," + rightEx.getMessage(), rightEx);
                                throw new Exception("修改对账文件权限失败.");
                            }
                            try {
                                Runtime.getRuntime().exec(" chmod 777 " + fullEndFileName);
                            } catch (Exception rightEx) {
                                log.error("chmod 777 " + fullEndFileName + "," + rightEx.getMessage(), rightEx);
                                throw new Exception("修改对账文件权限失败.");
                            }
                            List tempFileNameList = new ArrayList();
                            tempFileNameList.add(fileName);
                            tempFileNameList.add(endFileName);
                            log.info("fts传输id:" + ftsTaskIdStr + ",filePath:" + filePath + ",targetFilePath:" + targetFilePath + ",tempFileNameList:" + tempFileNameList);
                            boolean ftsFlag = false;
                            try {//调用 fts传输文件
                                ftsFlag = ftsUtil.UploadFilesToFts(ftsTaskIdStr, filePath, targetFilePath, tempFileNameList);
                            } catch (Exception e) {
                                log.error("调用fts失败:" + e.getMessage(), e);
                            }
                            makeCheckAccRenewSubManager.accRenewDaoCreate(ftsFlag, day, payResultTime, id1, id2);
                        }else {
                            log.info("重跑批监控：生成的该积分文件为空文件");
                        }
                    } catch (Exception e) {
                        log.error(e.getMessage(), e);
                        TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
                        tblMakecheckjobHistory.setOpe("System");
                        tblMakecheckjobHistory.setOpedate(DateHelper.getyyyyMMdd());
                        tblMakecheckjobHistory.setOpetime(DateHelper.getHHmmss());
                        tblMakecheckjobHistory.setIp("");
                        tblMakecheckjobHistory.setDate(DateHelper.string2Date(day, DateHelper.YYYYMMDD));
                        tblMakecheckjobHistory.setResult("1");
                        tblMakecheckjobHistory.setResultdesc("失败");
                        tblMakecheckjobHistory.setDesc("");
                        tblMakecheckjobHistory.setIsshoudong("自动");
                        tblMakecheckjobHistory.setIsrenew("补跑");
                        try {
                            makeCheckAccRenewSubManager.insertTblMakecheckjobHistory(tblMakecheckjobHistory);
                        } catch (Exception e1) {
                            log.error(e1.getMessage(), e1);
                        }//插入历史
                    } finally {
                        if (bwJfdjEnd != null) {
                            try {
                                bwJfdjEnd.flush();
                                bwJfdjEnd.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                        bwJfdjEnd = null;
                        if (bwJfdj != null) {
                            try {
                                bwJfdj.flush();
                                bwJfdj.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                        bwJfdj = null;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            log.error(e.getMessage(), e);
        }
    }

    /**
     * 上送积分系统渠道标志转换
     *
     * @param sourceId
     * @return
     */
    private String sourceIdChangeToChannel(String sourceId) {
        if (Contants.SOURCE_ID_MALL.equals(sourceId)) {
            return Contants.SOURCE_ID_MALL_TYPY;
        }
        if (Contants.SOURCE_ID_CC.equals(sourceId)) {
            return Contants.SOURCE_ID_CC_TYPY;
        }
        if (Contants.SOURCE_ID_IVR.equals(sourceId)) {
            return Contants.SOURCE_ID_IVR_TYPY;
        }
        if (Contants.SOURCE_ID_CELL.equals(sourceId)) {
            return Contants.SOURCE_ID_CELL_TYPY;
        }
        if (Contants.SOURCE_ID_MESSAGE.equals(sourceId)) {
            return Contants.SOURCE_ID_MESSAGE_TYPY;
        }
        if (Contants.SOURCE_ID_WX_BANK.equals(sourceId) || Contants.SOURCE_ID_WX_CARD.equals(sourceId)) {
            return Contants.SOURCE_ID_WX_TYPY;
        }
        if (Contants.SOURCE_ID_APP.equals(sourceId)) {
            return Contants.SOURCE_ID_APP_TYPY;
        }
        return Contants.SOURCE_ID_MALL_TYPY;
    }
}
