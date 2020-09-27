package cn.rkylin.apollo.common.scheduler;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.quartz.QuartzJobBean;

import cn.rkylin.apollo.common.util.BeanUtils;
import cn.rkylin.apollo.common.util.ListUtils;
import cn.rkylin.apollo.common.util.PropertiesUtils;
import cn.rkylin.apollo.notice.service.INoticeConfigureService;
import cn.rkylin.apollo.notice.service.INoticeStrategyService;
import cn.rkylin.core.ApolloMap;
/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo 
 * FileName: BacklogNoticeJob.java
 * 
 * @Description: 待办事项微信通知Job
 * @author zhangXinyuan
 * @Date 2016-8-25 下午 13:23
 * @version 1.00
 */
public class BacklogNoticeJob extends QuartzJobBean {
	private static final Log log = LogFactory.getLog(BacklogNoticeJob.class);
	//通知配置bean
	private INoticeConfigureService noticeConfigureService;
	//通知策略
	private INoticeStrategyService noticeStrategyService;
	//Redis模板
	private RedisTemplate<String, String> redisTemplate;
	//执行标识
	private static int flag = 0;
	//private java.text.DateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
	private static final String NOTICE_FILE = "wechat_notice.txt";
	private static final String WECHAT_UPLOAD_URL = PropertiesUtils.getVal("wechatUploadUrl");
	private static final String NOTICE_VALUE = "1";
	//查询要通知的人，查询通知人的待办事项，根据通知人查询通知策略，每个事项用什么方式去通知，多久通知一次
	@Override
	protected void executeInternal(JobExecutionContext arg0) throws JobExecutionException {
		if (flag == 0) {
			flag = 1;
			try {
				log.info("微信通知生成通知txt文件开始！");
				noticeWatiManage();
				log.info("微信通知生成通知txt文件结束！");
			} catch (Exception e) {
				log.error("查询通知配置信息异常！", e);
			} finally {
				flag = 0;
			}
		}
	}
	
	/**
	 * 定时生成微信通知文件主方法
	 */
	private void noticeWatiManage() {
		try {
			// 1.获取通知人
			List<Map<String, Object>> noticeConfigureList = getNoticeConfigureServiceBean().findByWhere(new ApolloMap<String, Object>());
			if (!ListUtils.isEmpty(noticeConfigureList)) {
				Map<String, Object> needNoticeMap = new HashMap<String, Object>();
				List<String> cacheNoticeDataList = new ArrayList<String>();
				for (Map<String, Object> noticeMap : noticeConfigureList) {
					// 2. 获取通知人的待办事项
					List<Map<String, Object>> watiManageList = getWatiManageList(noticeMap.get("USER_ID"));
					String noticeUserAccount = null;
					String noticeWechatName = null;
					if (null != noticeMap.get("USER_ACCOUNT")) {
						noticeUserAccount = String.valueOf(noticeMap.get("USER_ACCOUNT"));
					}
					if(null != noticeMap.get("WECHAT_NAME")){
						noticeWechatName = String.valueOf(noticeMap.get("WECHAT_NAME"));
					}
					// 3. 获取通知策略
					List<Map<String, Object>> noticeStrategyList = getNoticeStrategyList(noticeUserAccount);
					// 4. 匹配通知策略
					List<String> noticeNameList = new ArrayList<String>();
					for (Map<String, Object> manageMap : watiManageList) {
						String importantTypeCode = null;
						String formName = null;
						String redisFormNameKey = null;
						Map<String, Object> noticeFormMap = getRedisNoticeExists(manageMap);
						if (null == noticeFormMap) {
							continue;
						}
						// 5.在REDIS中已经存在不进入本次通知
						if (null != noticeFormMap.get("continueHas")) {
							Boolean continueHas = (Boolean) noticeFormMap.get("continueHas");
							if (!continueHas) {
								continue;
							}
						}
						if (null != noticeFormMap.get("importantTypeCode")) {
							importantTypeCode = String.valueOf(noticeFormMap.get("importantTypeCode"));
						}
						if (null != noticeFormMap.get("formName")) {
							formName = String.valueOf(noticeFormMap.get("formName"));
						}
						if (null != noticeFormMap.get("redisFormNameKey")) {
							redisFormNameKey = String.valueOf(noticeFormMap.get("redisFormNameKey"));
						}

						// 待处理事项匹配对应的通知策略
						if (!ListUtils.isEmpty(noticeStrategyList)) {
							for (Map<String, Object> strategyMap : noticeStrategyList) {
								// 策略人
								String nsUserAccount = String.valueOf(strategyMap.get("USER_ACCOUNT"));
								// 策略类型
								String strategyType = String.valueOf(strategyMap.get("STRATEGY_TYPE"));
								// 通知方式
								String noticeTypeId = String.valueOf(strategyMap.get("NOTICE_TYPE_ID"));
								// 策略级别
								String strategyTypeCode = String.valueOf(strategyMap.get("IMOORYANT_TYPE_CODE"));
								// 通知时间（目前是设置REDIS key 的过期时间）
								Long noticeTime = null;
								if (null != strategyMap.get("NOTICE_TIME")) {
									noticeTime = Long.valueOf(String.valueOf(strategyMap.get("NOTICE_TIME")));
								}
								// 通知待处理人，必须与策略配置人相等才应用此规则
								if (StringUtils.isNotEmpty(noticeUserAccount) && StringUtils.isNotEmpty(nsUserAccount)
										&& noticeUserAccount.equals(nsUserAccount)) {
									// 1OA待办事项, 1003微信通知方式
									if ("1".equals(strategyType) && "1003".equals(noticeTypeId)) {
										// 待办事项级别 与 策略级别相等
										if (importantTypeCode.equals(strategyTypeCode)) {
											getredisTemplateBean().opsForValue().set(redisFormNameKey, NOTICE_VALUE,noticeTime, TimeUnit.MINUTES);
											log.info("Redis中存储成功待办事项为：" + getredisTemplateBean().opsForValue().get(redisFormNameKey.toString()));
										}
									}
								}
							}
						}
						// 表示在REDIS中存入成功
						if (StringUtils.isNotEmpty(getredisTemplateBean().opsForValue().get(redisFormNameKey.toString()))) {
							noticeNameList.add(formName);
							cacheNoticeDataList.add(getredisTemplateBean().opsForValue().get(redisFormNameKey.toString()));
						}
					}
					needNoticeMap.put(noticeWechatName, noticeNameList);
					//Test 发送wangwenwei 同时也发送一份给 zhangxinyuan
					if(StringUtils.isNotEmpty(noticeWechatName)){
						if("wangwenwei".equals(noticeWechatName)){
							needNoticeMap.put("zhangxinyuan", noticeNameList);
						}
					}
				}
				// 生成微信通知文件
				createNoticeFile(needNoticeMap, cacheNoticeDataList);
				
			}
		} catch (Exception e) {
			log.error("生成通知文件异常", e);
		}
	}
	
	/**
	 * 循环把内容输出到wechat_notice.txt文件中
	 * @param needNoticeMap
	 * @param noticetList
	 */
	@SuppressWarnings("unchecked")
	private void createNoticeFile(Map<String, Object> needNoticeMap, List<String> noticetList) {
		if (null != needNoticeMap) {
			FileWriter noticeWriter = null;
			Iterator<Map.Entry<String, Object>> noticeMap = needNoticeMap.entrySet().iterator();
			try {
				if(!ListUtils.isEmpty(noticetList) && noticetList.size()>0){
					noticeWriter = new FileWriter(WECHAT_UPLOAD_URL+NOTICE_FILE);
				}
				while (noticeMap.hasNext()) {
					Map.Entry<String, Object> noticeEntry = (Map.Entry<String, Object>) noticeMap.next();
					if(StringUtils.isEmpty(noticeEntry.getKey())){
						continue;
					}
					String wechatName = noticeEntry.getKey();
					// 待办事项不为空这一行就都不为空否则本行为空
					List<String> noticeList = (List<String>) noticeEntry.getValue();
					if (!ListUtils.isEmpty(noticeList) && noticeList.size() > 0) {
						noticeWriter.write(wechatName);
						noticeWriter.write(String.valueOf("^^"));
						noticeWriter.write(String.valueOf(noticeList.size()));
						noticeWriter.write(String.valueOf("^^"));
						for (int i = 0; i < noticeList.size(); i++) {
							noticeWriter.write("\\\\n");
							noticeWriter.write(i + 1+ ".");
							noticeWriter.write(noticeList.get(i));
						}
						noticeWriter.write("\r\n"); // 换行
					}
				}
			} catch (Exception e) {
				log.error("生出微信通知txt文件异常", e);
			} finally {
				try {
					if (null != noticeWriter) {
						noticeWriter.flush();
						noticeWriter.close();
					}
				} catch (IOException e) {
					log.error("IO输出流异常", e);
				}
			}
		}
	}
	
	/**
	 * 获取待办事项级别 事项表单名称，并判断在redis是否存在
	 * @param manageMap
	 * @return
	 */
	private Map<String, Object> getRedisNoticeExists(Map<String, Object> manageMap) {
		// 待处理事项级别
		String formName = null;
		String importantTypeCode = null;
		String approvalName = null;
		boolean continueHas = true;
		StringBuffer redisFormNameKey = new StringBuffer();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (null != manageMap) {

			importantTypeCode = (null != manageMap.get("IMPORTANT_TYPE_CODE")
					? String.valueOf(manageMap.get("IMPORTANT_TYPE_CODE")) : "");
			approvalName = (null != manageMap.get("APPROVAL_NAME") ? String.valueOf(manageMap.get("APPROVAL_NAME"))
					: "");
			String userGuid = null;
			redisFormNameKey.append("plat:wx:notice:");
			redisFormNameKey.append(approvalName);
			redisFormNameKey.append(":");
			if(null != manageMap.get("FORM_GUID")){
				redisFormNameKey.append(String.valueOf(manageMap.get("FORM_GUID")));
			}
			if(null != manageMap.get("TABLE_NAME") && "T_BECOME_FULL_MEMBER_NEW".equals(String.valueOf(manageMap.get("TABLE_NAME")))){
				if(null != manageMap.get("NEW_EMP_GUID")){
					userGuid = String.valueOf(manageMap.get("NEW_EMP_GUID"));
				}
			}else{
				if(null != manageMap.get("REQUEST_PERN_GUID")){
					userGuid = String.valueOf(manageMap.get("REQUEST_PERN_GUID"));
				}
			}
			redisFormNameKey.append(":");
			redisFormNameKey.append(userGuid);
			if (null != manageMap.get("FORM_NAME")) {
				formName = String.valueOf(manageMap.get("FORM_NAME"));
				/*String[] formNameArray = formName.split("_");
				if (formNameArray.length > 1) {
					redisFormNameKey.append(formNameArray[0]);
					redisFormNameKey.append(formNameArray[1]);
				}*/
			}
			log.info("获取Redis中已存在的待办事项为："+getredisTemplateBean().opsForValue().get(redisFormNameKey.toString()));
			if (StringUtils.isNotEmpty(getredisTemplateBean().opsForValue().get(redisFormNameKey.toString()))) {
				continueHas = false;
			}
		}
		resultMap.put("importantTypeCode", importantTypeCode);
		resultMap.put("approvalName", approvalName);
		resultMap.put("formName", formName);
		resultMap.put("redisFormNameKey", redisFormNameKey);
		resultMap.put("continueHas", continueHas);
		return resultMap;
	}
	
	/**
	 * 根据通知人查询待办事项
	 * @param obj
	 * @return
	 */
	private List<Map<String, Object>> getWatiManageList(Object obj) {
		List<Map<String, Object>> watiManageList = null;
		String extRequestPernGuid = null;
		String extFormGuid = null;
		String extFormName = null;

		String withinRequestPernGuid = null;
		String withinFormGuid = null;
		String withinFormName = null;
		if (null != obj) {
			String userId = String.valueOf(obj);
			ApolloMap<String, Object> params = new ApolloMap<String, Object>();
			params.put("userId", userId);
			try {
				Long startTime =System.currentTimeMillis();
				watiManageList = getNoticeConfigureServiceBean().findWaitManageByWhere(params);
				Long endTime =System.currentTimeMillis();
				log.error("本次根据通知人查询待办事项列表耗费时间为-----------------------"+(startTime-endTime)+"ms");
				if (!ListUtils.isEmpty(watiManageList) && watiManageList.size() > 0) {
					StringBuffer extFormAddTo = null;
					StringBuffer withinFormAddTo = null;
					// 去重,同一个人（申请人ID）多个相同的申请单（包含FORM_NAME 名称相同）
					for (int i = 0; i < watiManageList.size(); i++) {
						for (int j = watiManageList.size() - 1; j > i; j--) {
							Map<String, Object> externalMap = watiManageList.get(i);
							Map<String, Object> withinMap = watiManageList.get(j);
							if (null != externalMap.get("REQUEST_PERN_GUID")) {
								extRequestPernGuid = String.valueOf(externalMap.get("REQUEST_PERN_GUID"));
							}
							if (null != externalMap.get("FORM_GUID")) {
								extFormGuid = String.valueOf(externalMap.get("FORM_GUID"));
							}
							if (null != externalMap.get("FORM_NAME")) {
								extFormAddTo = new StringBuffer();
								extFormName = String.valueOf(externalMap.get("FORM_NAME"));
								String[] formNameArray = extFormName.split("_");
								extFormAddTo.append(formNameArray[0]);
								extFormAddTo.append(formNameArray[1]);
							}

							if (null != withinMap.get("REQUEST_PERN_GUID")) {
								withinRequestPernGuid = String.valueOf(withinMap.get("REQUEST_PERN_GUID"));
							}
							if (null != withinMap.get("FORM_GUID")) {
								withinFormGuid = String.valueOf(withinMap.get("FORM_GUID"));
							}
							if (null != withinMap.get("FORM_NAME")) {
								withinFormAddTo = new StringBuffer();
								withinFormName = String.valueOf(withinMap.get("FORM_NAME"));
								String[] formNameArray = withinFormName.split("_");
								withinFormAddTo.append(formNameArray[0]);
								withinFormAddTo.append(formNameArray[1]);
							}
							if (extRequestPernGuid.equals(withinRequestPernGuid) && extFormGuid.equals(withinFormGuid)
									&& extFormAddTo.toString().equals(withinFormAddTo.toString())) {
								watiManageList.remove(j);
							}
						}
					}
				}
			} catch (Exception e) {
				log.error("根据通知人查询待办事项异常", e);
			}
		}
		return watiManageList;
	}
	
	/**
	 * 根据用户账号查询通知策略
	 * @param obj
	 * @return
	 */
	private List<Map<String, Object>> getNoticeStrategyList(String strParam) {
		List<Map<String, Object>> noticeStrategyList = null;
		if (StringUtils.isNotEmpty(strParam)) {
			ApolloMap<String, Object> params = new ApolloMap<String, Object>();
			params.put("userAccount", strParam);
			try {
				noticeStrategyList = getNoticeStrategyServiceBean().findByWhere(params);
			} catch (Exception e) {
				log.error("根据用户账号查询通知策略异常", e);
			}
		}
		return noticeStrategyList;
	}

	/**
	 * 通知配置bean
	 * @return
	 */
	public INoticeConfigureService getNoticeConfigureServiceBean() {
		if (null == noticeConfigureService) {
			try {
				ApplicationContext context = BeanUtils.getApplicationContext();
				noticeConfigureService = (INoticeConfigureService) context.getBean("noticeConfigureService");
			} catch (BeansException e) {
				log.error("待办事项通知初始化配置表bean失败！", e);
			}
		}
		return noticeConfigureService;
	}
	
	/**
	 * 通知策略bean
	 * @return
	 */
	public INoticeStrategyService getNoticeStrategyServiceBean() {
		if (null == noticeStrategyService) {
			try {
				noticeStrategyService = (INoticeStrategyService) BeanUtils.getBean("noticeStrategyService");
			} catch (Exception e) {
				log.error("初始化通知策略bean失败", e);
			}
		}
		return noticeStrategyService;
	}
	
	/**
	 * 获取REDIS模板bean
	 * @return
	 */ 
	@SuppressWarnings("unchecked")
	public RedisTemplate<String, String> getredisTemplateBean() {
		if (null == redisTemplate) {
			try {
				redisTemplate = (RedisTemplate<String, String>) BeanUtils.getBean("redisTemplate");
			} catch (BeansException e) {
				log.error("待办事项通知初始化配置表bean失败！", e);
			}
		}
		return redisTemplate;
	}
}
