/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.FTSUtil;
import cn.com.cgbchina.trade.dao.OrderCheckDao;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblCfgSysparamDao;
import cn.com.cgbchina.trade.dao.TblMakecheckjobHistoryDao;
import cn.com.cgbchina.trade.dao.TblOrderCancelDao;
import cn.com.cgbchina.trade.dao.TblOrderCardMappingDao;
import cn.com.cgbchina.trade.dao.TblOrderExtend2Dao;
import cn.com.cgbchina.trade.dto.MakecheckjobErrorDto;
import cn.com.cgbchina.trade.manager.MakecheckjobManager;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblCfgSysparamModel;
import cn.com.cgbchina.trade.model.TblMakecheckjobHistoryModel;
import cn.com.cgbchina.trade.model.TblOrderCancelModel;
import cn.com.cgbchina.trade.model.TblOrderCardMappingModel;
import cn.com.cgbchina.trade.model.TblOrderExtend2Model;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-15.
 */
@Service
@Slf4j
public class MakecheckjobServiceImpl implements MakecheckjobService {

    @Resource
    TblMakecheckjobHistoryDao tblMakecheckjobHistoryDao;

    @Resource
    OrderMainDao orderMainDao;

    @Resource
    TblOrderCardMappingDao tblOrderCardMappingDao;

    @Resource
    TblOrderCancelDao tblOrderCancelDao;

    @Resource
    OrderSubDao orderSubDao;

    @Resource
    TblOrderExtend2Dao tblOrderExtend2Dao;

    @Resource
    OrderCheckDao orderCheckDao;

    @Resource
    TblCfgSysparamDao tblCfgSysparamDao;

    @Resource
    MakecheckjobManager makecheckjobManager;

    //fts 配置信息
    @Value("#{app.ftsTaskid}")
    private String ftsTaskIdStr;
    @Value("#{app.ftsIp}")
    private String ftsIpStr;
    @Value("#{app.ftsPort}")
    private String ftsPortStr;
    @Value("#{app.ftsTimeout}")
    private String ftsTimeOutStr;
    @Value("#{app.checkAccTxtJf}")
    String filePath;//商城对账文件路径
    @Value("#{app.checkAccTxtJfTarget}")
    String targetFilePath;//积分系统对账文件路径
    //目标文件名，目标结束文件名
    @Value("#{app.checkAccTxtJfTxt}")
    String fileName;//对账文件名称
    @Value("#{app.checkAccTxtJfTxtEnd}")
    String endFileName;//对账文件结束文件
    @Value("#{app.mode}")
    private String mode;

    /**
     * 查询对账失败
     *
     * @param pageNo
     * @param size
     * @param startOpedate
     * @param endOpedate
     * @return
     */
    @Override
    public Response<Pager<TblMakecheckjobHistoryModel>> find(@Param("pageNo") Integer pageNo,
                                                             @Param("size") Integer size, @Param("startOpedate") String startOpedate,
                                                             @Param("endOpedate") String endOpedate, @Param("user") User user) {
        // 实例化返回Response
        Response<Pager<TblMakecheckjobHistoryModel>> response = new Response<Pager<TblMakecheckjobHistoryModel>>();
        List<TblMakecheckjobHistoryModel> tblMakecheckjobHistoryModelList = Lists.newArrayList();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            // 查询条件
            paramMap.put("offset", pageInfo.getOffset());
            paramMap.put("limit", pageInfo.getLimit());
            if (StringUtils.isNotEmpty(startOpedate)) {
                paramMap.put("startOpedate", startOpedate);
            }
            if (StringUtils.isNotEmpty(endOpedate)) {
                paramMap.put("endOpedate", endOpedate);
            }

            Pager<TblMakecheckjobHistoryModel> pager = tblMakecheckjobHistoryDao.findByPageQuery(paramMap,
                    pageInfo.getOffset(), pageInfo.getLimit());
            // 查询信息存在的情况下
            if (pager.getTotal() > 0) {
                // 获取pager的每一行信息
                List<TblMakecheckjobHistoryModel> tblMakecheckjobHistoryList = pager.getData();
                for (TblMakecheckjobHistoryModel tblMakecheckjobHistoryModel : tblMakecheckjobHistoryList) {
                    if (tblMakecheckjobHistoryModel.getOpetime() != null) {
                        String time = DateHelper.date2string(tblMakecheckjobHistoryModel.getOpetime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                        String shortTime = time.substring(11, 19);
                        tblMakecheckjobHistoryModel.setOpetimeStr(shortTime);
                        tblMakecheckjobHistoryModelList.add(tblMakecheckjobHistoryModel);
                    }
                }
            }
            response.setResult(
                    new Pager<TblMakecheckjobHistoryModel>(pager.getTotal(), tblMakecheckjobHistoryModelList));
            return response;
        } catch (Exception e) {
            log.error("tblMakecheckjobHistory.query.error", Throwables.getStackTraceAsString(e));
            response.setError("tblMakecheckjobHistory.query.error");
            return response;
        }
    }

    /**
     * 查询对账失败异常
     *
     * @param pageNo
     * @param size
     * @param startOpedate
     * @param endOpedate
     * @return
     */
    @Override
    public Response<Pager<MakecheckjobErrorDto>> findError(@Param("pageNo") Integer pageNo,
                                                           @Param("size") Integer size, @Param("startOpedate") String startOpedate,
                                                           @Param("endOpedate") String endOpedate, @Param("user") User user) {
        // 实例化返回Response
        Response<Pager<MakecheckjobErrorDto>> response = new Response<Pager<MakecheckjobErrorDto>>();
        List<MakecheckjobErrorDto> makecheckjobErrorDtos = Lists.newArrayList();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            List<String> allList = Lists.newArrayList();
            TblCfgSysparamModel tblCfgSysparamModel = tblCfgSysparamDao.findById("0030");
            List<String> orderIds = orderSubDao.findJfOrderId();
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("orderIdList", orderIds);
            List<TblOrderCancelModel> orderCancelList = tblOrderCancelDao.findCancelDate(paramMap);
            List<OrderMainModel> orderMainList = orderMainDao.findCreatDate();
            List<OrderCheckModel> orderCheckList = orderCheckDao.findDoDate();
            if (orderCancelList != null && orderCancelList.size() > 0) {
                for (TblOrderCancelModel tblOrderCancelModel : orderCancelList) {
                    allList.add(DateHelper.getyyyyMMdd(tblOrderCancelModel.getCancelTime()));
                }
            }
            if (orderMainList != null && orderMainList.size() > 0) {
                for (OrderMainModel orderMainModel : orderMainList) {
                    allList.add(DateHelper.getyyyyMMdd(orderMainModel.getCreateTime()));
                }
            }
            if (orderCheckList != null && orderCheckList.size() > 0) {
                for (OrderCheckModel orderCheckModel : orderCheckList) {
                    allList.add(orderCheckModel.getDoDate());
                }
            }

            HashSet<String> set = new HashSet<String>(allList);
            List<String> removeList = Lists.newArrayList(set);
            // 查询信息存在的情况下
            if (removeList.size() > 0) {
                // 获取pager的每一行信息
                MakecheckjobErrorDto makecheckjobErrorDto = null;
                String date = "";
                int page = 0;
                if (removeList.size() < pageInfo.getOffset() + pageInfo.getLimit()) {
                    page = removeList.size();
                } else {
                    page = pageInfo.getOffset() + pageInfo.getLimit();
                }
                for (int i = pageInfo.getOffset(); i < page; i++) {
                    makecheckjobErrorDto = new MakecheckjobErrorDto();
                    date = getOKDate(String.valueOf(removeList.get(i)));
                    makecheckjobErrorDto.setCreateDate(date);
                    makecheckjobErrorDto.setIsshoudong(tblCfgSysparamModel.getParamNm());
                    // 查询条件
                    Date date1 = DateHelper.string2Date(date, DateHelper.YYYY_MM_DD);
                    Date dateStart = null;
                    Date dateEnd = null;
                    if (StringUtils.isNotEmpty(startOpedate) && StringUtils.isNotEmpty(endOpedate)) {
                        dateStart = DateHelper.string2Date(startOpedate, DateHelper.YYYY_MM_DD);
                        dateEnd = DateHelper.string2Date(endOpedate, DateHelper.YYYY_MM_DD);
                        if (dateStart.compareTo(date1) < 1 && dateEnd.compareTo(date1) > -1) {
                            makecheckjobErrorDtos.add(makecheckjobErrorDto);
                        }
                    } else if (StringUtils.isNotEmpty(startOpedate)) {
                        dateStart = DateHelper.string2Date(startOpedate, DateHelper.YYYY_MM_DD);
                        if (dateStart.compareTo(date1) < 1) {
                            makecheckjobErrorDtos.add(makecheckjobErrorDto);
                        }
                    } else if (StringUtils.isNotEmpty(endOpedate)) {
                        dateEnd = DateHelper.string2Date(endOpedate, DateHelper.YYYY_MM_DD);
                        if (dateEnd.compareTo(date1) > -1) {
                            makecheckjobErrorDtos.add(makecheckjobErrorDto);
                        }
                    } else {
                        makecheckjobErrorDtos.add(makecheckjobErrorDto);
                    }
                }
            }
            response.setResult(
                    new Pager<MakecheckjobErrorDto>((long) removeList.size(), makecheckjobErrorDtos));
            return response;
        } catch (Exception e) {
            log.error("tblMakecheckjobHistory.query.error", Throwables.getStackTraceAsString(e));
            response.setError("tblMakecheckjobHistory.query.error");
            return response;
        }
    }

    /**
     * 启动自动
     *
     * @param createDateParam
     * @return
     */
    @Override
    public Response<Integer> onShoudong(String createDateParam) {
        Response<Integer> response = new Response<Integer>();
        try {
            TblCfgSysparamModel tblCfgSysparamModel = tblCfgSysparamDao.findById("0030");
            String opertype = tblCfgSysparamModel.getOrdertypeId();
            if (!"YG".equals(opertype) && !"JF".equals(opertype) && !"FQ".equals(opertype) && !"00".equals(opertype)) {
                response.setError("业务标识有误！");
                return response;
            }
            String isShoudong = "0";
            String param_desc = "手动";
            if ("0".equals(tblCfgSysparamModel.getParamNm())) {
                isShoudong = "1";
                param_desc = "自动";
            }
            TblCfgSysparamModel tblCfgSysparamModel1 = new TblCfgSysparamModel();
            tblCfgSysparamModel1.setParamId("0030");
            tblCfgSysparamModel1.setParamNm(isShoudong);
            tblCfgSysparamModel1.setParamDesc(param_desc);
            Integer update = makecheckjobManager.update(tblCfgSysparamModel1);
            response.setResult(update);
        } catch (IllegalArgumentException e) {
            log.error(e.getMessage(), "", Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("onShoudong.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, "onShoudong.error");
        }
        return response;
    }

    /**
     * 发送
     *
     * @param createDateParam
     * @param ip
     * @return
     */
    @Override
    public Response<Integer> renew(String createDateParam, String ip) {
        Response<Integer> response = new Response<Integer>();
        User user = UserUtil.getUser();
        BufferedWriter bwJfdj = null;
        BufferedWriter bwJfdjEnd = null;
        Map<String, Object> params = null;
        Integer update = 0;
        try {
            //fts 配置信息
            int ftsPortInt = -1;
            int ftsTimeOutInt = -1;
            log.info("ftpIpStr:" + ftsIpStr + ",ftpPortStr:" + ftsPortStr + ",ftpTimeOutStr:" + ftsTimeOutStr);
            if (null == ftsTaskIdStr || 0 == ftsTaskIdStr.length() || null == ftsIpStr || 0 == ftsIpStr.length() || null == ftsPortStr || 0 == ftsPortStr.length() || null == ftsTimeOutStr || 0 == ftsTimeOutStr.length()) {
                log.error("fts.configure.error{}", "ftpIpStr:" + ftsIpStr + ",ftpPortStr:" + ftsPortStr + ",ftpTimeOutStr:" + ftsTimeOutStr);
                response.setError("fts.error");
                return response;
            }
            try {
                ftsPortInt = Integer.parseInt(ftsPortStr);
                ftsTimeOutInt = Integer.parseInt(ftsTimeOutStr);
            } catch (Exception e) {
                log.error("fts.port.convert.error{}", Throwables.getStackTraceAsString(e));
                response.setError("fts.port.convert.error");
                return response;
            }
            //构造fts传输对象
            FTSUtil ftsUtil = new FTSUtil(ftsIpStr, ftsPortInt, ftsTimeOutInt, mode);

            String date = createDateParam;

            Date preDate = DateHelper.string2Date(date, "yyyyMMdd");
            Date tomorrow = new Date(new Date().getTime() + 1000 * 60 * 60 * 24);

            log.info("配置文件路径filePath:" + filePath + ",targetFilePath:" + targetFilePath);
            filePath = dealDatePatternStr("\\[[yMdHms]+\\]", "\"\\\\[|\\\\]\"", filePath, tomorrow);
            targetFilePath = dealDatePatternStr("\\[[yMdHms]+\\]", "\"\\\\[|\\\\]\"", targetFilePath, tomorrow);
            log.info("转换后的路径filePath:" + filePath + ",targetFilePath:" + targetFilePath);
            File file = new File(filePath);
            if (!file.exists()) {//文件目录不存在，创建目录
                //创建目录并赋予777权限
                if (!createDirectory(filePath)) {
                    log.error("文件夹创建失败：" + filePath);
                    throw new Exception("文件夹创建失败：" + filePath);
                }
                log.info("文件夹创建成功：" + filePath);
            }


            log.info("fileName:" + fileName + ",endFileName:" + endFileName);
            //先转换出结束文件名，再转换出目标文件名
            //记录文件
            fileName = dealDatePatternStr("\\[[yMdHms]+\\]", "\\[|\\]", fileName, null);
            fileName = dealDatePatternStr("\\{[yMdHms]+\\}", "\\{|\\}", fileName, preDate);
            //结束文件
            endFileName = dealDatePatternStr("\\[[yMdHms]+\\]", "\\[|\\]", endFileName, null);
            endFileName = dealDatePatternStr("\\{[yMdHms]+\\}", "\\{|\\}", endFileName, preDate);

            String fullFileName = filePath + fileName;//对账文件完整路径
            String fullEndFileName = filePath + endFileName;//对账文件结束文件完整路径
            log.info("fullFileName:" + fullFileName + ",\r\n fullEndFileName:" + fullEndFileName);
            //对账文件filewrite
            FileWriter fwJfdj = new FileWriter(fullFileName);
            bwJfdj = new BufferedWriter(fwJfdj);

//            String payResultTime=DateHelper.getCurrentTime();//获取数据库时间

            //查出昨天的然后生成对账文件
            // 处理大订单订单(积分商城)
            List<OrderMainModel> orders = orderMainDao.findCheckAccMain(date);// 获取5条小订单信息
            if (orders != null && orders.size() != 0) {
                log.info("积分商城渠道总数：" + orders.size());
                for (OrderMainModel orderMainModel : orders) {
                    String createDateTime = DateHelper.date2string(orderMainModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                    String serialNo = orderMainModel.getSerialNo();
                    String ismerge = orderMainModel.getIsmerge();
                    String integraltypeId = orderMainModel.getIntegraltypeId();
                    Long totalBonus = orderMainModel.getTotalBonus();
                    String cardno = orderMainModel.getCardno();
                    String sourceId = orderMainModel.getSourceId();
                    String tradeCode = null;// 交易码
                    if ("0".equals(ismerge)) {// 是合并支付
                        tradeCode = "bms103";
                    } else {// 不是合并支付
                        tradeCode = "bms102";
                    }
                    String sourceNm = sourceIdChangeToChannel(sourceId);

                    String line = sourceNm + "|" + createDateTime + "|" + serialNo + "|"
                            + tradeCode + "|" + cardno + "||" + integraltypeId + "||CNY|||" + totalBonus + "||";
                    bwJfdj.write(line);
                    bwJfdj.newLine();
                }
            } else {
                log.info("积分商城渠道总数：0");
            }
            // 处理子订单(cc渠道)
            List<OrderMainModel> ccorders = orderMainDao.findCCCheckAccOrder(date);// 获取5条小订单信息
            int count = 0;
            if (ccorders != null && ccorders.size() != 0) {
                params = Maps.newHashMap();
                params.put("orderMainIdList", ccorders);
                List<TblOrderCardMappingModel> cardorders = tblOrderCardMappingDao.findCCCheckAccOrder(params);// 获取5条小订单信息
                if (cardorders != null && cardorders.size() != 0) {
                    for (TblOrderCardMappingModel tblOrderCardMappingModel : cardorders) {
                        for (OrderMainModel orderMainModel : ccorders) {
                            if (orderMainModel.getOrdermainId().equals(tblOrderCardMappingModel.getOrdermainId())) {
                                String cardNo = tblOrderCardMappingModel.getCardNo();
                                String txnDate = DateHelper.date2string(orderMainModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                                String serialNo = orderMainModel.getSerialNo();
                                String bonusType = tblOrderCardMappingModel.getBonusType();
                                Long bonusValue = tblOrderCardMappingModel.getBonusValue();
                                String ismerge = orderMainModel.getIsmerge();
                                String tradeCode = null;
                                if ("0".equals(ismerge)) {// 是合并支付
                                    tradeCode = "bms103";
                                } else {// 不是合并支付
                                    tradeCode = "bms102";
                                }
                                String line = "CCAG|" + txnDate + "|" + serialNo + "|"
                                        + tradeCode + "|" + cardNo + "||" + bonusType + "||CNY|||" + bonusValue + "||";
                                bwJfdj.write(line);
                                bwJfdj.newLine();
                                count++;
                            }
                        }
                    }
                }
                log.info("CC商城渠道总数：" + count);
            } else {
                log.info("CC商城渠道总数：" + count);
            }
            // 处理退货订单(积分商城)
            // 处理退货以及撤销订单
            List<TblOrderCancelModel> orderCancelList = tblOrderCancelDao.findSumTblOrderCancel(date);
            List<OrderMainModel> orderMainList = orderMainDao.findJfList();
            if (orderCancelList != null && orderCancelList.size() > 0) {
                log.info("退货撤销渠道总数：" + orderCancelList.size());
                params = Maps.newHashMap();
                params.put("orderCancelList", orderCancelList);
                List<OrderSubModel> orderSubList = orderSubDao.findOrderCancelByList(params);
                List<TblOrderExtend2Model> extend2Models = tblOrderExtend2Dao.findByOrderCancelIds(params);
                if (orderSubList != null && orderSubList.size() > 0) {
                    for (OrderSubModel orderSubModel : orderSubList) {
                        if (orderMainList != null && orderMainList.size() > 0) {
                            for (OrderMainModel orderMainModel : orderMainList) {
                                if (orderMainModel.getOrdermainId().equals(orderSubModel.getOrdermainId())) {
                                    String createDate = DateHelper.date2string(orderMainModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                                    String serialNo = orderMainModel.getSerialNo();
                                    Long bonusValue = orderSubModel.getBonusTotalvalue();
                                    String bonusType = orderSubModel.getBonusType();
                                    String sourceId = orderMainModel.getSourceId();
                                    String tradeCode = "bms203";
                                    //--部分退积分判断 福袋部分退积分
                                    if (extend2Models != null && extend2Models.size() > 0) {
                                        for (TblOrderExtend2Model tblOrderExtend2Model : extend2Models) {
                                            if (orderSubModel.getOrderId().equals(tblOrderExtend2Model.getOrderId())) {
                                                if ("1".equals(tblOrderExtend2Model.getIsPartlyRefundIntegral())) {
                                                    bonusValue = tblOrderExtend2Model.getRefundIntegral();
                                                    break;
                                                }
                                            }

                                        }
                                    }
                                    log.info("sourceId：" + sourceId);
                                    //"00"代表商城渠道 "01"、"02"代表积分渠道,"03"代表手机渠道
                                    String sourceNm = sourceIdChangeToChannel(sourceId);

                                    String line = sourceNm + "|" + createDate + "|" + serialNo + "|"
                                            + tradeCode + "|||" + bonusType + "||CNY|||" + bonusValue + "||";
                                    bwJfdj.write(line);
                                    bwJfdj.newLine();
                                }
                            }

                        }

                    }
                }
            } else {
                log.info("退货撤销渠道总数：0");
            }

            Long id1 = null;//正交易当天最大的自增ID
            Long id2 = null;//负交易当天最大的自增ID
            //处理广发商城积分支付（正交易）
            List<OrderCheckModel> orderCheckModels = orderCheckDao.findOrderChecks(date);
            if (orderCheckModels != null && orderCheckModels.size() > 0) {
                params = Maps.newHashMap();
                params.put("orderCancelList", orderCheckModels);
                List<OrderSubModel> orderSubAllList = orderSubDao.findOrderCancelByList(params);
                log.info("处理广发商城积分支付数量:" + orderCheckModels.size());
                int index = 0;
                for (OrderCheckModel orderCheckModel : orderCheckModels) {
                    if (orderSubAllList != null && orderSubAllList.size() > 0) {
                        for (OrderSubModel orderSubModel : orderSubAllList) {
                            if (orderCheckModel.getOrderId().equals(orderSubModel.getOrderId())) {
                                String serialNo = orderSubModel.getOrderIdHost();
                                String createDate = DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                                String cardNo = orderSubModel.getCardno();
                                String integraltypeId = orderSubModel.getIntegraltypeId();
                                Long bonusTotalvalue = orderSubModel.getBonusTotalvalue();
                                String sourceId = orderSubModel.getSourceId();
                                if (index == 0) {
                                    id1 = orderCheckModel.getId();
                                }
                                log.info("id1:" + id1);
                                String sourceNm = sourceIdChangeToChannel(sourceId);
                                String tradeCode = "";
                                String line = "";
                                tradeCode = "bms103";
                                line = sourceNm + "|" + createDate + "|" + serialNo + "|"
                                        + tradeCode + "|" + cardNo + "||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||";
                                bwJfdj.write(line);
                                bwJfdj.newLine();
                            }
                        }

                    }
                    index++;
                }
            }
            //处理广发商城积分支付/积分商城（负交易）
            List<OrderCheckModel> orderCheckModels1 = orderCheckDao.findOrderChecks1(date);
            if (orderCheckModels1 != null && orderCheckModels1.size() > 0) {
                params = Maps.newHashMap();
                params.put("orderCancelList", orderCheckModels1);
                List<OrderSubModel> orderSubAllList1 = orderSubDao.findOrderCancelByList(params);
                params = Maps.newHashMap();
                params.put("orderMainIdList", orderSubAllList1);
                List<OrderMainModel> orderMainModels = orderMainDao.findOrdersByList(params);
                log.info("处理广发商城积分支付数量:" + orderCheckModels1.size());
                int index = 0;
                for (OrderCheckModel orderCheckModel : orderCheckModels1) {
                    if (orderSubAllList1 != null && orderSubAllList1.size() > 0) {
                        for (OrderSubModel orderSubModel : orderSubAllList1) {
                            if (orderCheckModel.getOrderId().equals(orderSubModel.getOrderId())) {
                                if (orderMainModels != null && orderMainModels.size() > 0) {
                                    for (OrderMainModel orderMainModel : orderMainModels) {
                                        if (orderMainModel.getOrdermainId().equals(orderSubModel.getOrdermainId())) {
                                            String serialNo = "";
                                            String orderTypeId = orderSubModel.getOrdertypeId();
                                            //积分商城的订单流水号取大订单表中的SERIAL_NO,广发商城的积分对账流水号，取小订单表中的ORDER_ID_HOST
                                            if ("JF".equals(orderTypeId)) {
                                                serialNo = orderMainModel.getSerialNo();
                                            } else if ("YG".equals(orderTypeId) || "FQ".equals(orderTypeId)) {
                                                serialNo = orderSubModel.getOrderIdHost();
                                            }
                                            String createDate = DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                                            String cardNo = orderSubModel.getCardno();
                                            String integraltypeId = orderSubModel.getIntegraltypeId();
                                            Long bonusTotalvalue = orderSubModel.getBonusTotalvalue();
                                            String sourceId = orderSubModel.getSourceId();
                                            String curStatusId = orderCheckModel.getCurStatusId();
                                            if (index == 0) {
                                                id2 = orderCheckModel.getId();
                                            }
                                            log.info("id2:" + id2);
                                            String sourceNm = sourceIdChangeToChannel(sourceId);
                                            String tradeCode = "";
                                            String line = "";

                                            /** 对于FQ支付失败订单，白天发起主动积分撤销，晚上对账bms202  */
                                            String ocDoDate = orderCheckModel.getDoDate();
                                            String ocDOTime = orderCheckModel.getDoTime();
                                            String jfRefundSerialno = orderCheckModel.getJfRefundSerialno();
                                            //暂时只有分期订单bps失败，会主动撤销 （ordercheck状态0307支付失败）
                                            if ("FQ".equals(orderTypeId) && "0307".equals(curStatusId)) {
                                                //历史的积分撤销没有流水
                                                if (null == jfRefundSerialno || 0 == jfRefundSerialno.trim().length()) {
                                                    continue;
                                                }
                                                tradeCode = "bms202";//nsct009主动撤销
                                                line = sourceNm + "|" + ocDoDate + "|" + ocDOTime + "|" + jfRefundSerialno + "|"
                                                        + tradeCode + "|" + cardNo + "||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||";
                                            } else {
                                                tradeCode = "bms203";
                                                line = sourceNm + "|" + createDate + "|" + serialNo + "|"
                                                        + tradeCode + "|||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||";
                                            }
                                            bwJfdj.write(line);
                                            bwJfdj.newLine();
                                        }
                                    }
                                }
                            }

                        }
                    }
                    index++;
                }
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
            log.info("对账文件:" + jfdjFile.exists() + ",对账文件长度:" + jfdjFile.length() + ",对账文件end:" + jfdjEndFile.exists());
            if (jfdjFile.exists() && 0 != jfdjFile.length() && jfdjEndFile.exists()) {

                log.info("对账文件chmod");
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
                List<String> tempFileNameList = new ArrayList<String>();
                tempFileNameList.add(fileName);
                tempFileNameList.add(endFileName);
                log.info("fts传输id:" + ftsTaskIdStr + ",filePath:" + filePath + ",targetFilePath:" + targetFilePath + ",tempFileNameList:" + tempFileNameList);
                boolean ftsFlag = false;
                try {//fts 上传文件
                    ftsUtil.send(filePath + fileName, fileName, targetFilePath, ftsTaskIdStr);
                    ftsUtil.send(filePath + endFileName, endFileName, targetFilePath, ftsTaskIdStr);
                    ftsFlag = true;
                } catch (Exception e) {
                    log.error("fts传输文件失败:{}", Throwables.getStackTraceAsString(e));
                    response.setError("补发对账文件失败");
                    throw new ResponseException(Contants.ERROR_CODE_500, "fts传输文件失败");
                }
                if (ftsFlag) {
                    update = makecheckjobManager.updateCheckStatus(date);//更新对账文件状态
                    update = makecheckjobManager.updateTblOrderCancel(date);//更新cancel表
                    if (id1 != null) {//更新正交易对账文件标志
                        params = Maps.newHashMap();
                        params.put("id", id1);
                        params.put("create_date", date);
                        update = makecheckjobManager.updatePoint(params);//更新tblcheck
                    }
                    if (id2 != null) {//更新负交易对账文件标志
                        params = Maps.newHashMap();
                        params.put("id", id2);
                        params.put("create_date", date);
                        update = makecheckjobManager.updatePoint1(params);//更新tblcheck
                    }

                    TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
                    tblMakecheckjobHistory.setOpe(user.getId());
                    tblMakecheckjobHistory.setOpedate(DateHelper.string2Date(DateHelper.getCurrentDate(), DateHelper.YYYY_MM_DD));
                    tblMakecheckjobHistory.setOpetime(DateHelper.string2Date(DateHelper.getCurrentTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
                    tblMakecheckjobHistory.setIp(ip);
                    tblMakecheckjobHistory.setDate(DateHelper.string2Date(date, DateHelper.YYYY_MM_DD));
                    tblMakecheckjobHistory.setResult("0");
                    tblMakecheckjobHistory.setResultdesc("成功");
                    tblMakecheckjobHistory.setDesc("");
                    tblMakecheckjobHistory.setIsshoudong("0");
                    tblMakecheckjobHistory.setIsrenew("补跑");
                    update = makecheckjobManager.insert(tblMakecheckjobHistory);//插入历史
                } else {
                    //如果不成功
                    TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
                    tblMakecheckjobHistory.setOpe(user.getId());
                    tblMakecheckjobHistory.setOpedate(DateHelper.string2Date(DateHelper.getCurrentDate(), DateHelper.YYYY_MM_DD));
                    tblMakecheckjobHistory.setOpetime(DateHelper.string2Date(DateHelper.getCurrentTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
                    tblMakecheckjobHistory.setIp(ip);
                    tblMakecheckjobHistory.setDate(DateHelper.string2Date(date, DateHelper.YYYY_MM_DD));
                    tblMakecheckjobHistory.setResult("1");
                    tblMakecheckjobHistory.setResultdesc("失败");
                    tblMakecheckjobHistory.setDesc("");
                    tblMakecheckjobHistory.setIsshoudong("0");
                    tblMakecheckjobHistory.setIsrenew("补跑");
                    makecheckjobManager.insert(tblMakecheckjobHistory);//插入历史
                }
            } else {
                log.info("没有对账记录");
                response.setError("没有对账记录");
                return response;
            }
            response.setResult(update);
        } catch (Exception e) {
            log.error("renew.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, "renew.error");
        } finally {
            if (bwJfdj != null) {
                try {
                    bwJfdj.flush();
                    bwJfdj.close();
                } catch (Exception e) {
                    log.error(e.getMessage(), Throwables.getStackTraceAsString(e));
                }
            }
            bwJfdj = null;
            if (bwJfdjEnd != null) {
                try {
                    bwJfdjEnd.flush();
                    bwJfdjEnd.close();
                } catch (Exception e) {
                    log.error(e.getMessage(), Throwables.getStackTraceAsString(e));
                }
            }
            bwJfdjEnd = null;
        }
        return response;
    }

    /**
     * 匹配路里面的日期格式，进行替换
     *
     * @param patternStr    模式例如 \\[[yMdHms]+\\]
     * @param patternRepStr 替换模式中[] 留下日期格式
     * @param str           要转换的字符串
     * @param date          特定日期（null：取当前日期）
     * @return str 同时转换多个文件的，不能确保全部文件时间一致（请在特定的场景使用）；
     */
    private String dealDatePatternStr(String patternStr, String patternRepStr, String str, Date date) {
        Pattern pattern = Pattern.compile(patternStr);
        Matcher matcher = pattern.matcher(str);
        log.info("patternStr:" + patternStr + ",str:" + str);

        List matchList = new ArrayList();
        List convertMatchList = new ArrayList();
        if (matcher.matches()) {//完全匹配，返回当前字符串
            log.info("完全匹配");
            matchList.add(str);
        } else {//非完全匹配
            while (matcher.find()) {//记录匹配项
                log.info("matcher.group():" + matcher.group());
                matchList.add(matcher.group());
            }
        }
        log.info("retList:" + matchList);
        //把匹配的日期格式，输出成对应的日期
        if (null != matchList && matchList.size() > 0) {
            for (int i = 0; i < matchList.size(); i++) {
                String tempItem = null == matchList.get(i) ? "" : String.valueOf(matchList.get(i)).trim();
                if (null != tempItem && tempItem.length() > 0) {
                    try {
                        String tempDate = "";
                        if (null != date) {//日期不为空
                            //替换模式符合 例如 匹配模式是 [yMd+] ,会替换"["和"]",剩余日期格式
                            tempDate = DateHelper.date2string(date, tempItem.replaceAll(patternRepStr, ""));
                        } else {
                            tempDate = DateHelper.date2string(new Date(), tempItem.replaceAll(patternRepStr, ""));
                        }
                        log.info("tempDate:" + tempDate);
                        convertMatchList.add(tempDate);
                    } catch (Exception e) {
                        log.error("转换异常:" + tempItem, e);
                        convertMatchList.add("");
                    }
                } else {
                    convertMatchList.add("");
                }
            }
        }
        log.info("convertMatchList:" + convertMatchList);
        for (int i = 0; i < matchList.size() && i < convertMatchList.size(); i++) {
            String tempMatch = null == matchList.get(i) ? "" : String.valueOf(matchList.get(i)).trim();
            String tempConv = null == convertMatchList.get(i) ? "" : String.valueOf(convertMatchList.get(i)).trim();
            if (tempMatch.length() > 0 && tempConv.length() > 0) {
                str = str.replace(tempMatch, tempConv);
            }
        }
        log.info("result:" + str);
        return str;
    }

    /**
     * 创建目录，且赋予777权限给新增的目录
     *
     * @param path
     * @return
     */
    private boolean createDirectory(String path) throws Exception {
        log.info("path:" + path);
        if (null == path || 0 == path.trim().length()) {
            return false;
        }
        File temp = new File(path);
        if (temp.exists()) {
            return true;
        } else {
            log.info("parent:" + temp.getParent());
            if (!createDirectory(temp.getParent())) {
                return false;
            }
            if (temp.mkdir()) {
                //chmod 777
                try {
                    log.info("create directory:" + temp.getPath());
                    log.info("chmod 777 to current folder");
                    Runtime.getRuntime().exec("chmod 777 " + temp.getPath());
                } catch (Exception e) {
                    log.error("chmod 777 " + temp.getPath() + ",error:" + e.getMessage(), e);
                }
                return true;
            } else {
                return false;
            }
        }
    }

    /**
     * <p>Description:上送积分系统渠道标志转换</p>
     *
     * @param sourceId
     * @return
     */
    private static String sourceIdChangeToChannel(String sourceId) {
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
        if (Contants.SOURCE_ID_APP.equals(sourceId)){
            return Contants.SOURCE_ID_APP_TYPY;
        }
        return Contants.SOURCE_ID_MALL_TYPY;
    }

    private static String getOKDate(String sdate) {
        sdate = sdate.substring(0, 4) + "-" + sdate.substring(4, 6) + "-"
                + sdate.substring(6, 8);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        ParsePosition pos = new ParsePosition(0);
        Date strtodate = formatter.parse(sdate, pos);
        String dateString = formatter.format(strtodate);
        return dateString;
    }
}
