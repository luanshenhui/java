package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.BatchSmspInfDao;
import cn.com.cgbchina.batch.manager.BatchSmsTemplateManager;
import cn.com.cgbchina.batch.model.BatchSmspCustModel;
import cn.com.cgbchina.batch.model.BatchSmspInfModel;
import cn.com.cgbchina.batch.model.BatchSmspRecordModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

/**
 * Created by lvzd on 2016/12/5.
 */
@Service
@Slf4j
public class SmsFileUploadServiceImpl implements SmsFileUploadService {

    @Value("#{app.smsTemplateUp}")
    private String fileUpBase;

    @Value("#{app.smsTemplateDown}")
    private String fileDwBase;
    @Autowired
    private BatchSmsTemplateManager batchSmsTemplateManager;
    @Resource
    private BatchSmspInfDao batchSmspInfDao;
    // 线程池
    private ExecutorService executorService = Executors.newFixedThreadPool(1);
    @Override
    public void uploadSmsFile(String[] args) {
        String fileName = args[0];
        Long id = Long.valueOf(args[1]);
        String userId = args[2];
        importNameList(fileName, id, userId);
    }

    private static List<String> readImportFile(String fileName) {
        List<String> readlines = Lists.newArrayList();
        // 1 文件读取
        Reader reader = null;
        BufferedReader bufferedReader = null;
        try {
            reader = new InputStreamReader(new FileInputStream(new File(fileName)), "UTF-8");
            bufferedReader = new BufferedReader(reader);
            String strLine;
            // 将导入内容写入服务器
            while ((strLine = bufferedReader.readLine()) != null) {
                readlines.add(strLine);
            }

            bufferedReader.close();
            reader.close();
        } catch (IOException e) {
            log.error("短信文件读取异常");
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
        }
        return readlines;
    }


    /**
     * 内容写出
     *
     * @param path
     * @param content
     */
    private static void write(String path, String content) {
        File f = new File(path);
        try (BufferedWriter output = new BufferedWriter(new FileWriter(f, true))) {
            output.write(content + "\r\n");
            output.close();
        } catch (Exception e) {
            log.error(Throwables.getStackTraceAsString(e));
        }
    }

    private void readAndMakeFile(List<String> fileLines, Long id, String userId,
                                 List<Long> phones, List<String[]> insertList,
                                 final String upLoadFilePath, final String downLoadFilePath, int num) {
        int lineNum = num;
        int totalNum = 200000;
        final StringBuffer sb = new StringBuffer();
        final StringBuffer sbfail = new StringBuffer();
        for (String line : fileLines) {
            ++lineNum;
            sb.append(id + "|" + line + "|" + userId + "\r\n");
            // 进行数据操作
            if (lineNum > totalNum) {
                sbfail.append(line + "   超过导入最大数量20万条\r\n");
                continue;
            }
            if (line.trim().length() <= 0) {
                continue;
            }
            String[] arry = line.split("\\|");
            if (arry.length != 2) {
                sbfail.append(line + "   格式不正确\r\n");
                continue;
            }
            if (arry[0].trim().length() == 0) {
                sbfail.append(line + "   手机号为空\r\n");
                continue;
            }
            if (arry[0].trim().length() != 11 || arry[1].trim().length() > 20) {
                sbfail.append(line + "   手机号或卡号长度错误\r\n");
                continue;
            }
            Long p = 0l;
            try {
                p = Long.parseLong(arry[0]);
            } catch (Exception e) {
                sbfail.append(line + "   手机号格式不正确\r\n");
                continue;
            }
            if (phones.contains(p)) {
                sbfail.append(line + "   重复的手机号\r\n");
                continue;
            }
            phones.add(p);
            insertList.add(new String[]{arry[0], arry[1]});
        }
        if (sb.length() > 0 || sbfail.length() > 0) {
            executorService.submit(new Runnable() {
                public void run() {
                    try {
                        if (sb.length() > 0) {
                            write(upLoadFilePath, sb.toString());
                            sb.setLength(0);
                        }
                        if (sbfail.length() > 0) {
                            // 在服务器上写失败文件
                            write(downLoadFilePath, sbfail.toString());
                            sbfail.setLength(0);
                        }
                    } catch (Exception e) {
                        log.error("生成文件异常,erro{}", Throwables.getStackTraceAsString(e));
                    }
                }
            });
        }
    }
    /**
     * 白名单导入
     *
     */
    private void importNameList(String fileNm, Long id, String userId) {
        log.info("白名单导入 fileNm:" + fileNm + " id:" + id + " userId:" + userId);
        // 1 导入文件读取
        List<String> fileLines = readImportFile(fileUpBase + fileNm);
        String loadStatus = "";
        String smsLoadStatus = Contants.SMSP_LOAD_0202;
        int successNum = 0;
        int updateNum = 0;
        String fileName = "";
        int lineNum = 0;  // 行数计数
        int failNum = 0;
        // 上传文件路径
        fileName = id + "/" + DateHelper.getCurrentTimess() + "_" +  fileNm;
        final String upLoadFilePath = fileUpBase + fileName;
        final String downLoadFilePath = fileDwBase + fileName;
        if (fileLines.size() == 0) {
            updateSms(id, userId, Contants.SMSP_LOAD_0203);
            write(downLoadFilePath, "导入文件为空！");
        } else {
            log.info("文件校验开始");
            // 3 数据分析
            List<Long> phones = Lists.newArrayList();
            List<String[]> insertList = Lists.newArrayList();
            File downLoadDir = new File(fileDwBase + id);
            if(!downLoadDir.exists()) {
                boolean b = downLoadDir.mkdirs();
                if(!b){
                    log.error("SmsFileUploadService.write.failed");
                }
            }

            List<List<String>> filelinelist = Lists.partition(fileLines, 50000);
            for (List<String> lines : filelinelist) {
                readAndMakeFile(lines, id, userId, phones, insertList, upLoadFilePath, downLoadFilePath, lineNum);
                lineNum = lineNum + lines.size();
            }

            log.info("文件生成完成");

            // 查询该短信维护表id下的所有名单
            int count = batchSmspInfDao.countSmspCustById(id);
            log.info("数据库中件数："+ count);

            // 4 异步发送,数据更新
            if (insertList.size() > 50000) {
                // 多线程执行
                ExecutorService executorService = Executors.newCachedThreadPool();
                CompletionService<Map<String, Object>> completionService =
                        new ExecutorCompletionService<Map<String, Object>>(executorService);
                List<List<BatchSmspCustModel>> smspInsert = Lists.partition(toIDbList(insertList, id, userId), 50000);
                for (List<BatchSmspCustModel> scsupdate : smspInsert) {
                    submitService(completionService, scsupdate);
                }

                // 5 返回结果处理
                try {
                    for (int j = 0; j < smspInsert.size(); j++) {
                        Map<String, Object> map = completionService.take().get();
                        loadStatus = String.valueOf(map.get("loadStatus"));
                        if (!Contants.LOADSTATUS_SUCCESS.equals(loadStatus))  {
                            log.error("MessageTemplate.importCusts.Update  error:{}", (String) map.get("errorMsg"));
                            smsLoadStatus = Contants.SMSP_LOAD_0203;
                        } else {
                            successNum = successNum + (int)map.get("successNum");
                            updateNum = updateNum + (int)map.get("updateNum");
                        }
                    }
                    // 导入完成，更新导入状态和当前状态
                    updateSms(id, userId, smsLoadStatus);
                } catch (InterruptedException e) {
                    log.error("InterruptedException.error:{}", Throwables.getStackTraceAsString(e));
                    updateSms(id, userId, Contants.SMSP_LOAD_0203);
                } catch (Exception e) {
                    log.error("MessageTemplate.importCusts.Exception error:{}", Throwables.getStackTraceAsString(e));
                    updateSms(id, userId, Contants.SMSP_LOAD_0203);
                }
                executorService.shutdown();
            } else {
                Map<String, Object> map = importData(toIDbList(insertList, id, userId));
                try {
                    loadStatus = String.valueOf(map.get("loadStatus"));
                    if (!Contants.LOADSTATUS_SUCCESS.equals(loadStatus))  {
                        log.error("MessageTemplate.importCusts.Update  error:{}", (String) map.get("errorMsg"));
                        smsLoadStatus = Contants.SMSP_LOAD_0203;
                    } else {
                        successNum = successNum + (int)map.get("successNum");
                        updateNum = updateNum + (int)map.get("updateNum");
                    }
                    // 导入完成，更新导入状态和当前状态
                    updateSms(id, userId, smsLoadStatus);
                } catch (Exception e) {
                    log.error("MessageTemplate.importCusts.Exception error:{}", Throwables.getStackTraceAsString(e));
                    updateSms(id, userId, Contants.SMSP_LOAD_0203);
                }
            }

            // 失败件数
            failNum = lineNum - successNum;
            if (failNum == 0) {
                // 在服务器上写失败文件
                write(downLoadFilePath, "全部数据导入成功！");
                log.info("全部数据导入成功");
            } else {
                log.info("全部数据 成功:" + successNum + "失败:" + failNum);
            }
        }
        // 在履历表中插入数据
        BatchSmspRecordModel smspRecordModel = new BatchSmspRecordModel();
        smspRecordModel.setFilePath(fileName);
        smspRecordModel.setSId(id);
        smspRecordModel.setCreateOper(userId);
        smspRecordModel.setTotalNum(lineNum);
        smspRecordModel.setSuccessNum(successNum);
        smspRecordModel.setFailNum(failNum);
        smspRecordModel.setRepeatNum(updateNum);
        smspRecordModel.setLoadStatus(loadStatus);// 导入状态 0201-成功,0202-失败
        batchSmsTemplateManager.createRecord(smspRecordModel);
        log.info("短信白名单导入成功");
    }

    /**
     * Model数据转换
     * @param smsList
     * @param id
     * @param userid
     * @return
     */
   private static List<BatchSmspCustModel> toIDbList(List<String[]> smsList, final Long id, final String userid) {
       return Lists.transform(smsList, new Function<String[], BatchSmspCustModel>() {
           @Override
           public BatchSmspCustModel apply(@NotNull String[] input) {
               BatchSmspCustModel model = new BatchSmspCustModel();
               model.setCardNo(input[1]);
               model.setPhone(input[0]);
               model.setCreateOper(userid);
               model.setModifyOper(userid);
               model.setId(id);
               return model;
           }
       });
   }

    /**
     * 短信模板导入状态
     * @param id
     * @param userId
     * @param loadStatus
     * @return
     */
    private boolean updateSms(Long id, String userId, String loadStatus) {
        // 短信模板导入状态
        BatchSmspInfModel smspInfModel = new BatchSmspInfModel();
        smspInfModel.setId(id);
        smspInfModel.setLoadDatetime(new Date());
        smspInfModel.setModifyOper(userId);
        smspInfModel.setLoadStatus(loadStatus);// 导入中
        // 导入短信模板数据
        return batchSmsTemplateManager.update(smspInfModel);
    }

    /**
     * 线程开始
     *
     * @param completionService
     * @param models
     */
    private void submitService(CompletionService<Map<String, Object>> completionService,
                               final List<BatchSmspCustModel> models) {
        completionService.submit(new Callable<Map<String, Object>>() {
            @Override
            public Map<String, Object> call() throws Exception {
                try {
                    return importData(models);
                } catch (Exception e) {
                    log.error("msg.error------>{}", Throwables.getStackTraceAsString(e));
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("errorMsg", Throwables.getStackTraceAsString(e));
                    return map;
                }
            }
        });
    }

    /**
     * 导入 数据
     *
     * @param smspCustModelList 导入白名单信息
     */
    public Map<String, Object> importData(List<BatchSmspCustModel> smspCustModelList) {
        log.info("导入数据库" + Thread.currentThread().getName());
        Map<String, Object> resultMap = com.google.common.collect.Maps.newHashMapWithExpectedSize(10);
        String loadStatus = Contants.LOADSTATUS_SUCCESS;//导入状态
        String errorMsg = ""; //错误信息
        int successNum = 0;
        int updateNum = 0;
        try {
            boolean flag = true;
            if (smspCustModelList != null) {
                List<List<BatchSmspCustModel>> smspCust = Lists.partition(smspCustModelList, 1000);
                for (List<BatchSmspCustModel> scsinsert : smspCust) {
                    int num = batchSmsTemplateManager.replaceImportData(scsinsert);
                    if (num == -1) {
                        flag = false;
                    } else {
                        successNum = successNum + scsinsert.size();
                        updateNum = updateNum + num;
                    }
                }
            }
            if(!flag) {
                errorMsg = "数据库更新异常";
                loadStatus = Contants.LOADSTATUS_FAILED;
            }
        } catch (Exception e) {
            log.error("MessageTemplateManager.importData.error: {}", Throwables.getStackTraceAsString(e));
            errorMsg = Throwables.getStackTraceAsString(e);
            loadStatus = Contants.LOADSTATUS_FAILED;
        }
        resultMap.put("updateNum", updateNum);
        resultMap.put("successNum", successNum);
        resultMap.put("loadStatus", loadStatus);
        resultMap.put("errorMsg", errorMsg);
        return resultMap;
    }
}
