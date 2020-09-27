package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.BatchSmspCustDao;
import cn.com.cgbchina.batch.model.BatchSmspCustModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.FTSUtil;
import cn.com.cgbchina.item.model.SmspInfModel;
import cn.com.cgbchina.item.model.SmspMdlModel;
import cn.com.cgbchina.item.service.SmsTemplateService;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotifyInfo;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by DHC on 2016/12/5.
 */
@Slf4j
@Service
public class BatchSmspCustServiceImpl implements BatchSmspCustService {

    @Value("#{propertieParam['batchsms.FilePath']}")
    private String smsFilePath;
    @Value("#{propertieParam['batchsms.host']}")
    private String smsHost;
    @Value("#{propertieParam['batchsms.port']}")
    private String smsPort;
    @Value("#{propertieParam['batchsms.taskid']}")
    private String smsTaskId;
    @Value("#{propertieParam['batchsms.ServerPath']}")
    private String smsServerPath;

    @Resource
    private SmsTemplateService smsTemplateService;
    @Resource
    private BatchSmspCustDao batchSmspCustDao;
    @Resource
    private SMSService smsService;

    /**
     * 生成上传文件
     *
     * @param msg
     * @return
     * @throws Exception
     */
    @Override
    public Response sendMessage(String[] msg) throws Exception {
        Response<Boolean> response = Response.newResponse();
        JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
        BatchSmspCustModel dto = jsonMapper.fromJson(msg[0], BatchSmspCustModel.class);

        log.info("【批量发送短信】 入参 sendMessage : msg -->{}", msg[0]);

        String sendStatus = Contants.SMSP_CURSTATUS_0204; // 已完成

        try {
            // 生成文件
            String ftpFile = buildFtpFile(dto);

            // 短信模板数据
            BatchSendSMSNotify batchSendSMSNotify = new BatchSendSMSNotify();
            batchSendSMSNotify.setTransCode("SMS093");
            batchSendSMSNotify.setSendId("SHOP");
            batchSendSMSNotify.setSendDate(new Date());
            batchSendSMSNotify.setSendSn("123");
            batchSendSMSNotify.setBranch("999999");
            batchSendSMSNotify.setSubBranch("999999");
            batchSendSMSNotify.setOperatorId("72");
            batchSendSMSNotify.setChannelId("72");
            batchSendSMSNotify.setFileName(ftpFile);

            // 批量发送短信服务调用
            BaseResult baseResult = smsService.batchSMSNotify(batchSendSMSNotify);
            log.info("【批量发送短信】 sms inteface end,result:{}", jsonMapper.toJson(baseResult));
            if (null == baseResult
                    || !BaseResult.ResultCode.SUCCESS.equals(BaseResult.ResultCode.fromNumber(baseResult.getRetCode()))) {
                // 失败
                sendStatus = Contants.SMSP_CURSTATUS_0207;
            }
            dto.setStatus(sendStatus);
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("【批量发送短信】 sms :Exception :------>:{}", Throwables.getStackTraceAsString(e));
            // 更新状态（发送失败）
            dto.setStatus(Contants.SMSP_CURSTATUS_0207);
            response.setError("send sms fail");
        } finally {
            // 状态判断
            if ("1".equals(dto.getUserType())) {
                dto.setStatus(Contants.SMSP_CURSTATUS_0206); // 白名单发送
            }
            SmspInfModel smspInfModel = BeanUtils.copy(dto, SmspInfModel.class);
            boolean changeStatus = smsTemplateService.updateStatus(smspInfModel).getResult();
            log.info("【批量发送短信】 sms .sms:end-------------->updateStatus:{}", changeStatus);
        }
        return response;
    }

    /**
     * 生成上传文件
     *
     * @param dto
     * @throws Exception
     */
    private String buildFtpFile(BatchSmspCustModel dto) throws Exception {

        log.info("【批量短信文件】 生成文件开始");
        String smspMess = ""; // 短信模板内容
        Response<SmspMdlModel> resp = smsTemplateService.findSmspMess(dto.getSmspId());

        if (resp.isSuccess() && null != resp.getResult()) {
            smspMess = resp.getResult().getSmspMess();
        }

        // 将查询条件放入到paramMap
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("id", dto.getId());// id
        paramMap.put("userType", dto.getUserType());

        SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
        SimpleDateFormat sdfFilePath = new SimpleDateFormat("yyyyMMdd");

        // 文件路径生成
        String srcPath = smsFilePath + "/SHOP/send/SMSP/" + sdfFilePath.format(new Date()) + "/";// 本地路径
        String destPath = smsFilePath + "/SMSP/save/SHOP/" + sdfFilePath.format(new Date()) + "/";// 文服目标路径
        String fileName = "SHOP.SMSP.NNNNNN.S" + sdf.format(new Date()) + ".N"
                + String.valueOf(StringUtil.getRamdomNumber(6));
        String srcFile = srcPath + fileName; //本地文件路径
        String destFile = destPath + fileName;  //ftp文件路径

        log.info("【批量短信文件】 生成路径: srcFile -->{},srcPath-->{},destPath-->{},fileName-->{}",
                srcFile, srcPath, destPath, fileName);

        // 准备数据
        preparedMessage(paramMap, 0, 10000, dto, smspMess, srcFile);

        log.info("【批量短信文件】生成成功，文件路径：{}，准备上传ftp", srcFile);

        File file = new File(srcFile);
        File fileEnd = new File(srcFile + ".end");
        if(file.exists() && fileEnd.exists()){
            // ftp 发送
            FTSUtil ftsUtil;
            if (!smsHost.isEmpty()) {
                ftsUtil = new FTSUtil(smsHost, Integer.parseInt(smsPort), 5000, "");
                ftsUtil.send(srcFile, fileName, destPath, smsTaskId);
                ftsUtil.send(srcFile + ".end", fileName + ".end", destPath, smsTaskId);
            }
        }
        log.info("【批量短信文件】上传成功，上传路径：{}", destFile);
        return destFile;
    }

    /**
     * 准备发送数据
     *
     * @param paramMap
     * @param offset
     * @param limit
     * @param dto
     * @param smspMess
     * @return
     */
    private void preparedMessage(Map<String, Object> paramMap, int offset, int limit, BatchSmspCustModel dto,
                                 String smspMess, String srcFile) {
        // 根据id查询1000条--待发送短信的用户
        List<BatchSmspCustModel> batchSmspCustList = batchSmspCustDao.findSmspCustInfo(paramMap, offset, limit);
        buildMessageFile(batchSmspCustList, dto, smspMess, srcFile);

        if (batchSmspCustList.size() == 10000) {
            preparedMessage(paramMap, offset + 10000, 10000, dto, smspMess, srcFile);
        }
    }

    /**
     * 通过卡号--查询客户名称 并且写入文件
     *
     * @param smspCustModelList
     * @param dto
     * @param smspMess          @return map
     */
    private void buildMessageFile(List<BatchSmspCustModel> smspCustModelList, BatchSmspCustModel dto, String smspMess,
                                  String srcFile) {

        if (null == smspCustModelList || smspCustModelList.isEmpty()) {
            log.error("【批量短信发送】send.sms.error：smspCus.isNull");
//            throw new ResponseException("query.smspCus.isNull");
            return;
        }

        // 短信内容插入短信模板和电话
        List<BatchSendSMSNotifyInfo> infos = Lists.newArrayListWithExpectedSize(smspCustModelList.size());
        BatchSendSMSNotifyInfo sendInfo = null;// 短信内容
        for (BatchSmspCustModel smspCustModel : smspCustModelList) {
            sendInfo = new BatchSendSMSNotifyInfo();
            sendInfo.setSmsId("FH");
            sendInfo.setTemplateId(dto.getSmspId());
            sendInfo.setChannelCode("SHOP");
            sendInfo.setSendBranch("999999");
            sendInfo.setMobile(smspCustModel.getPhone());

            sendInfo.setCardNbr(smspCustModel.getCardNo());
            sendInfo.setItemName(dto.getItemName());
            sendInfo.setGoodsPrice(dto.getGoodsPrice());
            sendInfo.setCustName(smspCustModel.getCustName());
            sendInfo.setOtherMess(dto.getOtherMess());
            sendInfo.setPerStage(dto.getPerStage());
            sendInfo.setStagesCode(dto.getStagesCode());
            sendInfo.setCouponNm(dto.getCouponNm());

            sendInfo.setSmspMess(smspMess);

            infos.add(sendInfo);
        }

        if (!infos.isEmpty()) {
            String srcFileEnd = srcFile + ".end";
            try {
                File smsFile = new File(srcFile);
                File smsEndFile = new File(srcFileEnd);

                FileUtils.writeStringToFile(smsFile, BatchSendSMSNotifyInfo.listToString(infos), "GBK", true);
                FileUtils.writeStringToFile(smsEndFile, "");
            } catch (Exception e) {
                log.error("SMSTemplateService.buildMessage.sms:error:{}", Throwables.getStackTraceAsString(e));
            }
        } else {
            // 失败
            log.error("SMSTemplateService.send.sms:error-------------->: BatchSendSMSNotifyInfos.isEmpty");
        }
    }
}
