package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.MakeCheckAccDao;
import cn.com.cgbchina.batch.dao.MakePrivilegeFileDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.MakeCheckAccModel;
import cn.com.cgbchina.batch.model.MakePrivilegeFileModel;
import cn.com.cgbchina.batch.model.OrderMainModel;
import cn.com.cgbchina.batch.model.TblMakecheckjobHistoryModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.CheckAccFileUtil;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.FTSUtil;
import cn.com.cgbchina.common.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by w2001316 on 2016/7/28.
 */
@Component
@Slf4j
public class MakeCheckAccManager {

	@Resource
	private MakeCheckAccDao makeCheckAccDao;

	@Resource
	private MakePrivilegeFileDao makePrivilegeFileDao;
	@Autowired
	private MakeCheckAccSubManager makeCheckAccSubManager;

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
	@Value("#{app.checkAccTxtYhqPath}")
	private String localFileName;
	@Value("#{app.checkAccTxtYhqTxt}")
	private String fileNameCheckAccTxtYhq;
	@Value("#{app.checkAccTxtYhqTxtEnd}")
	private String endFileNameCheckAccTxtYhq;
	@Value("#{app.mode}")
	private String mode;
	// 积分对账文件格式化日期用
	private String dateFormat = "yyyyMMdd|HHmmss";
	@Transactional
	public void makeCheckAccWithTxn() throws BatchException {
		log.info("进入MakeCheckAccServiceImpl:makeCheckAccWithTxn");
		int againTimes = 0;// 当前失败最多跑多少次的次数，当前最多跑3次
		String yestoday = "";
		BufferedWriter bwJfdj = null;
		BufferedWriter bwJfdjEnd = null;
		CheckAccFileUtil checkAccFileUtil = new CheckAccFileUtil();
		// fts 配置信息
		int ftsPortInt = -1;
		int ftsTimeOutInt = -1;
		log.info("ftpIpStr:" + ftsIpStr + ",ftpPortStr:" + ftsPortStr + ",ftpTimeOutStr:" + ftsTimeOutStr);
		if (null == ftsTaskIdStr || 0 == ftsTaskIdStr.length() || null == ftsIpStr || 0 == ftsIpStr.length()
				|| null == ftsPortStr || 0 == ftsPortStr.length() || null == ftsTimeOutStr
				|| 0 == ftsTimeOutStr.length()) {
			log.error("fts配置有误.");
			return;
		}
		try {
			ftsPortInt = Integer.parseInt(ftsPortStr);
			ftsTimeOutInt = Integer.parseInt(ftsTimeOutStr);
		} catch (Exception e) {
			log.error("fts端口转换出错:" + e.getMessage(), e);
		}
		// 构造fts传输对象
		FTSUtil ftsUtil = new FTSUtil(ftsIpStr, ftsPortInt, ftsTimeOutInt, mode);
		while (againTimes < 3) {
			try {
				yestoday = DateTime.now().minusDays(1).toString(DateHelper.YYYYMMDD);
				// 返回昨天日期对象
				Date preDate = DateHelper.string2Date(yestoday, DateHelper.YYYYMMDD);
				/** 新文服路径改造 */
				// 文件路径
				String filePath = filePathTmp;
				String targetFilePath = targetFilePathTmp;
				log.info("配置文件路径filePath:" + filePath + ",targetFilePath:" + targetFilePath);
				filePath = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
						Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, filePath, null);
				targetFilePath = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
						Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, targetFilePath, null);
				log.info("转换后的路径filePath:" + filePath + ",targetFilePath:" + targetFilePath);
				File file = new File(filePath);
				if (!file.exists()) {// 文件目录不存在，创建目录
					// 创建目录并赋予777权限
					if (!checkAccFileUtil.createDirectory(filePath)) {
						log.error("文件夹创建失败：" + filePath);
						throw new Exception("文件夹创建失败：" + filePath);
					}
					log.info("文件夹创建成功：" + filePath);
				}

				// 目标文件名，目标结束文件名
				String fileName = fileNameTmp;
				String endFileName = endFileNameTmp;
				log.info("fileName:" + fileName + ",endFileName:" + endFileName);
				// 先转换出结束文件名，再转换出目标文件名
				// 记录文件
				fileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
						Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, fileName, null);
				fileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_JF_DATE_PATTERN,
						Contants.CHECK_ACC_JF_DATE_PATTERN_REPLACE, fileName, preDate);
				// 结束文件
				endFileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
						Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, endFileName, null);
				endFileName = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_JF_DATE_PATTERN,
						Contants.CHECK_ACC_JF_DATE_PATTERN_REPLACE, endFileName, preDate);

				String fullFileName = filePath + fileName;// 对账文件完整路径
				String fullEndFileName = filePath + endFileName;// 对账文件结束文件完整路径
				log.info("fullFileName:" + fullFileName + ",\r\n fullEndFileName:" + fullEndFileName);
				// 对账文件filewrite
				FileWriter fwJfdj = new FileWriter(fullFileName);
				bwJfdj = new BufferedWriter(fwJfdj);
				// 获取数据库时间
				String payResultTime = makeCheckAccDao.getdbtime();

				int sumOrder = 0;
				// 查出昨天的然后生成对账文件
				// 处理大订单订单(积分商城)
				sumOrder = makeCheckAccDao.getSumCheckAccOrderMain(yestoday, payResultTime);// 获取总数
				log.info("商城渠道总数：" + sumOrder);
				for (int i = 0; i < sumOrder; i = i + 500) {
					List<OrderMainModel> orders = makeCheckAccDao.getCheckAccOrderMain(i, 500, yestoday, payResultTime);// 获取5条小订单信息
					for (OrderMainModel orderMainModel : orders) {
						String createDateTime = DateHelper.date2string(orderMainModel.getCreateTime(), dateFormat);
						String serialNo = StringUtils.trim(orderMainModel.getSerialNo());
						String ordermainId = StringUtils.trim(orderMainModel.getOrdermainId());
						String ismerge = StringUtils.trim(orderMainModel.getIsmerge());
						String integraltypeId = StringUtils.trim(orderMainModel.getIntegraltypeId());
						String defraytype = StringUtils.trim(orderMainModel.getDefraytype());
						BigDecimal totalPrice = orderMainModel.getTotalPrice();
						Long totalBonus = orderMainModel.getTotalBonus();
						String cardno = StringUtils.trim(orderMainModel.getCardno());
						String sourceId = StringUtils.trim(orderMainModel.getSourceId());
						String tradeCode = null;// 交易码
						if ("0".equals(ismerge)) {// 是合并支付
							tradeCode = "bms103";
						} else {// 不是合并支付
							tradeCode = "bms102";
						}
						String sourceNm = sourceIdChangeToChannel(sourceId);
						String line = sourceNm + "|" + createDateTime + "|" + serialNo + "|" + tradeCode + "|" + cardno
								+ "||" + integraltypeId + "||CNY|||" + totalBonus + "||" + "02" + "|" + ordermainId;
						bwJfdj.write(line);
						bwJfdj.newLine();
					}
				}
				// 处理子订单(cc渠道)
				sumOrder = makeCheckAccDao.getSumCCCheckAccOrder(yestoday, payResultTime);// 总数
				log.info("CC渠道总数：" + sumOrder);
				for (int i = 0; i < sumOrder; i = i + 500) {
					List<MakeCheckAccModel> orders = makeCheckAccDao.getCCCheckAccOrder(i, 500, yestoday,
							payResultTime);// 获取5条小订单信息
					for (MakeCheckAccModel makeCheckAccModel : orders) {
						String ordermainId = StringUtils.trim(makeCheckAccModel.getOrdermainId());
						String cardNo = StringUtils.trim(makeCheckAccModel.getCardNo());
						String serialNo = StringUtils.trim(makeCheckAccModel.getSerialNo());
						String defrayType = StringUtils.trim(makeCheckAccModel.getDefraytype());
						BigDecimal amount = makeCheckAccModel.getAmount();
						String bonusType = StringUtils.trim(makeCheckAccModel.getBonusType());
						String bonusValue = StringUtils.trim(makeCheckAccModel.getBonusValue());
						String bonusTxnCode = StringUtils.trim(makeCheckAccModel.getBonusTxnCode());
						String ismerge = StringUtils.trim(makeCheckAccModel.getIsmerge());
						String createDateTime = DateHelper.date2string(makeCheckAccModel.getCreateTime(), dateFormat);
						String tradeCode = null;
						if ("0".equals(ismerge)) {// 是合并支付
							tradeCode = "bms103";
						} else {// 不是合并支付
							tradeCode = "bms102";
						}
						String line = "CCAG|" + createDateTime + "|" + serialNo + "|" + tradeCode + "|" + cardNo + "||"
								+ bonusType + "||CNY|||" + bonusValue + "||" + "02" + "|" + ordermainId;

						bwJfdj.write(line);
						bwJfdj.newLine();
					}
				}

				// 处理退货以及撤销订单
				List<String> orderCancelIds = makeCheckAccDao.getTblOrderCancel(yestoday);
				log.info("CC退货成功订单总数：" + orderCancelIds.size());
				for (String orderId : orderCancelIds) {
					List<MakeCheckAccModel> lst = makeCheckAccDao.getTblOrderCancelList(orderId);
					if (lst != null && lst.size() > 0) {
						MakeCheckAccModel makeCheckAccModel = lst.get(0);
						String ordermainId = StringUtils.trim(makeCheckAccModel.getOrdermainId());
						String cardNo = StringUtils.trim(makeCheckAccModel.getCardNo());
						String createDateTime = DateHelper.date2string(makeCheckAccModel.getCreateTime(), dateFormat);
						String serialNo = StringUtils.trim(makeCheckAccModel.getSerialNo());
						String bonusValue = StringUtils.trim(makeCheckAccModel.getBonusTotalvalue());
						String bonusType = StringUtils.trim(makeCheckAccModel.getBonusType());
						String sourceId = StringUtils.trim(makeCheckAccModel.getSourceId());
						String tradeCode = "bms203";
						// --部分退积分判断
						String bonusValueRe = makeCheckAccDao.getRefundIntegralByBonus(orderId);
						if (StringUtils.notEmpty(bonusValueRe)) {
							bonusValue = bonusValueRe;
						}
						// --
						log.info("sourceId：" + sourceId);
						// "00"代表商城渠道 "01"、"02"代表积分渠道,"03"代表手机渠道
						String sourceNm = sourceIdChangeToChannel(sourceId);

						String line = sourceNm + "|" + createDateTime + "|" + serialNo + "|" + tradeCode + "|||"
								+ bonusType + "||CNY|||" + bonusValue + "||" + "02" + "|" + ordermainId;

						bwJfdj.write(line);
						bwJfdj.newLine();

					}
				}
				// 处理广发商城积分支付(正交易)
				List<MakeCheckAccModel> oList = makeCheckAccDao.getTblOrderPointList(yestoday);
				Long id1 = null;
				Long id2 = null;
				log.info("处理广发商城积分支付数量正交易:" + oList.size());
				int index = 0;
				int index1 = 0;
				for (MakeCheckAccModel makeCheckAccModel : oList) {
					String serialNo = StringUtils.dealNull(makeCheckAccModel.getOrderIdHost());
					String createDateTime = StringUtils
							.dealNull(DateHelper.date2string(makeCheckAccModel.getCreateTime(), dateFormat));
					String cardNo = StringUtils.dealNull(makeCheckAccModel.getCardNo());
					String integraltypeId = StringUtils.dealNull(makeCheckAccModel.getIntegraltypeId());
					String bonusTotalvalue = StringUtils.dealNull(makeCheckAccModel.getBonusTotalvalue());
					String sourceId = StringUtils.dealNull(makeCheckAccModel.getSourceId());
					String curStatusId = StringUtils.dealNull(makeCheckAccModel.getCurStatusId());
					String terminalId = "";
					String orderId = "";
					if ("JF".equals(makeCheckAccModel.getOrdertypeId())) {
						terminalId = "02";
						orderId = makeCheckAccModel.getOrdermainId();
					} else if ("YG".equals(makeCheckAccModel.getOrdertypeId()) || "FQ".equals(makeCheckAccModel.getOrdertypeId())) {
						terminalId = "01";
						orderId = makeCheckAccModel.getOrderId();
					}
					if (index++ == 0) {
						id1 = makeCheckAccModel.getId();
					}
					String sourceNm = sourceIdChangeToChannel(sourceId);
					String tradeCode = "";
					String line = "";

					tradeCode = "bms103";
					line = sourceNm + "|" + createDateTime + "|" + serialNo + "|" + tradeCode + "|" + cardNo + "||"
							+ integraltypeId + "||CNY|||" + bonusTotalvalue + "||" + terminalId + "|" + orderId;
					bwJfdj.write(line);
					bwJfdj.newLine();
				}
				log.info("***********id1:{}, list(0).id:{}", id1,oList.size() > 0? oList.get(0).getId():"");

				// 处理广发和积分商城积分支付(负交易)
				List<MakeCheckAccModel> oList1 = makeCheckAccDao.getTblOrderPointList1(yestoday);
				log.info("处理广发商城积分支付数量负交易:" + oList1.size());
				for (MakeCheckAccModel makeCheckAccModel : oList1) {
					String serialNo = "";
					String orderYypeId = StringUtils.dealNull(makeCheckAccModel.getOrdertypeId());
					String terminalId = "";
					String orderId = "";
					// 积分商城的订单流水号取大订单表中的SERIAL_NO,广发商城的积分对账流水号，取小订单表中的ORDER_ID_HOST
					if ("JF".equals(orderYypeId)) {
						serialNo = StringUtils.dealNull(makeCheckAccModel.getSerialNo());
						terminalId = "02";
						orderId = makeCheckAccModel.getOrdermainId();
					} else if ("YG".equals(orderYypeId) || "FQ".equals(orderYypeId)) {
						serialNo = StringUtils.dealNull(makeCheckAccModel.getOrderIdHost());
						terminalId = "01";
						orderId = makeCheckAccModel.getOrderId();
					}
					String createDateTime = StringUtils
							.dealNull(DateHelper.date2string(makeCheckAccModel.getCreateTime(), dateFormat));
					String cardNo = StringUtils.dealNull(makeCheckAccModel.getCardNo());
					String integraltypeId = StringUtils.dealNull(makeCheckAccModel.getIntegraltypeId());
					String bonusTotalvalue = StringUtils.dealNull(makeCheckAccModel.getBonusTotalvalue());
					String sourceId = StringUtils.dealNull(makeCheckAccModel.getSourceId());
					String curStatusId = StringUtils.dealNull(makeCheckAccModel.getCurStatusId());
					if (index1++ == 0) {
						id2 = makeCheckAccModel.getId();
					}
					String sourceNm = sourceIdChangeToChannel(sourceId);
					String tradeCode = "";
					String line = "";

					/** 20150202 hwh 修改:对于FQ支付失败订单，白天发起主动积分撤销，晚上对账bms202 start */
					String ocDoDate = StringUtils.dealNull(makeCheckAccModel.getDoDate());
					String ocDOTime = StringUtils.dealNull(makeCheckAccModel.getDoTime());
					String jfRefundSerialno = StringUtils.dealNull(makeCheckAccModel.getJfRefundSerialno());
					// 暂时只有分期订单bps失败，会主动撤销 （ordercheck状态0307支付失败）
					if ("FQ".equals(orderYypeId) && Contants.SUB_ORDER_STATUS_0307.equals(curStatusId)) {
						// 历史撤销的ordercheck 积分撤销流水为空，则不处理
						if (null == jfRefundSerialno || 0 == jfRefundSerialno.trim().length()) {
							continue;
						}
						tradeCode = "bms202";// nsct009主动撤销
						/**
						 * 渠道类型（渠道类型码）、日期、流水号、交易码、卡号、积分类型、消费类型、币种（CNY）、
						 * 交易总金额(商城可为空)、积分支付金额(商城可为空)、积分交易额、商户编号(商城可为空)、终端号(商城可为空)
						 */
						line = sourceNm + "|" + ocDoDate + "|" + ocDOTime + "|" + jfRefundSerialno + "|" + tradeCode
								+ "|" + cardNo + "||" + integraltypeId + "||CNY|||" + bonusTotalvalue + "||" + terminalId + "|" + orderId;
					} else {
						tradeCode = "bms203";
						line = sourceNm + "|" + createDateTime + "|" + serialNo + "|" + tradeCode + "|||"
								+ integraltypeId + "||CNY|||" + bonusTotalvalue + "||" + terminalId + "|" + orderId;
					}
					bwJfdj.write(line);
					bwJfdj.newLine();
				}
				log.info("***********id2:{}, list(0).id:{}", id2,oList1.size() > 0? oList1.get(0).getId():"");
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
				log.info("对账文件:" + jfdjFile.exists() + ",对账文件长度:" + jfdjFile.length() + ",对账文件end:"
						+ jfdjEndFile.exists());
				// 对账文件存在且不为空
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
					log.info("fts传输id:" + ftsTaskIdStr + ",filePath:" + filePath + ",targetFilePath:" + targetFilePath
							+ ",tempFileNameList:" + tempFileNameList);
					boolean ftsFlag = false;
					try {// 调用 fts传输文件
						ftsFlag = ftsUtil.UploadFilesToFts(ftsTaskIdStr, filePath, targetFilePath, tempFileNameList);
					} catch (Exception e) {
						log.error("调用fts失败:" + e.getMessage(), e);
					}
					againTimes = makeCheckAccSubManager.daoCreate(ftsFlag, yestoday, payResultTime, id1, id2, againTimes);
				} else {
					log.info("doc为null");
					againTimes++;
				}
			} catch (Exception e) {
				e.printStackTrace();
				log.error("送对账文件发生异常");
				log.error(e.getMessage(), e);
				againTimes++;
				TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
				tblMakecheckjobHistory.setOpe("System");
				tblMakecheckjobHistory.setOpedate(DateHelper.getyyyyMMdd());
				tblMakecheckjobHistory.setOpetime(DateHelper.getHHmmss());
				tblMakecheckjobHistory.setIp("");
				tblMakecheckjobHistory.setDate(DateHelper.string2Date(yestoday, DateHelper.YYYYMMDD));
				tblMakecheckjobHistory.setResult("1");
				tblMakecheckjobHistory.setResultdesc("失败");
				tblMakecheckjobHistory.setDesc("异常捕捉抛得异常");
				tblMakecheckjobHistory.setIsshoudong("1");
				tblMakecheckjobHistory.setIsrenew("正常跑");
				try {
					makeCheckAccSubManager.insertTblMakecheckjobHistory(tblMakecheckjobHistory);
				} catch (Exception e1) {
					e1.printStackTrace();
					log.error(e1.getMessage(), e1);
				} // 插入历史
			} finally {
				if (bwJfdj != null) {
					try {
						bwJfdj.flush();
						bwJfdj.close();
					} catch (IOException e) {
						e.printStackTrace();
						log.error(e.getMessage(), e);
					}
				}
				bwJfdj = null;
				if (bwJfdjEnd != null) {
					try {
						bwJfdjEnd.flush();
						bwJfdjEnd.close();
					} catch (IOException e) {
						e.printStackTrace();
						log.error(e.getMessage(), e);
					}
				}
				bwJfdjEnd = null;
			}
		}
	}

	public void makePrivilegeFileWithTxn() throws BatchException {
		log.info("进入优惠券对账文件生成方法");
		log.info("配置文件路径:" + localFileName);
		CheckAccFileUtil checkAccFileUtil = new CheckAccFileUtil();
		// 匹配文件路径 [yMdHms]+ 模式，替换模式[|]，并进行替换
		// donghb 0906 start
		String localFileNamePath = checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
				Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, localFileName, null);// 转换里面的日期，替换成对应的日期
		log.info("转换后路径:" + localFileNamePath);
		File file = new File(localFileNamePath);
		if (!file.exists()) {// 创建目录
			// 创建目录并赋予777权限
			try {
				checkAccFileUtil.createDirectory(localFileNamePath);
				log.info("文件夹创建成功：" + localFileNamePath);
			} catch (Exception e) {
				log.error("文件夹创建失败：" + localFileNamePath);
				throw new BatchException(e);
			}
		}
		// 目标文件名，目标结束文件名
		log.info("fileName:" + fileNameCheckAccTxtYhq + ",endFileName:" + endFileNameCheckAccTxtYhq);
		// 先转换出结束文件名，再转换出目标文件名
		String nullFileName = localFileNamePath
				+ checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
						Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, endFileNameCheckAccTxtYhq, null);
		String localFileNameFile = localFileNamePath + checkAccFileUtil.dealDatePatternStr(Contants.CHECK_ACC_COMMON_DATE_PATTERN,
				Contants.CHECK_ACC_COMMON_DATE_PATTERN_REPLACE, fileNameCheckAccTxtYhq, null);
		log.info("localFileName:" + localFileNameFile + ",\r\n nullFileName:" + nullFileName);

		BufferedWriter bw = null;
		BufferedWriter bwNullFile = null;// 空文件 writer
		try {
			List<MakePrivilegeFileModel> oList = makePrivilegeFileDao.getTblOrderCheckList();
			FileWriter fw = new FileWriter(localFileNameFile);
			// donghb 0906 end
			bw = new BufferedWriter(fw);
			if (oList != null && oList.size() > 0) {
				for (MakePrivilegeFileModel makePrivilegeFileModel : oList) {// 循环读取符合条件数据
					String privilegeId = StringUtils.addNullString(20, makePrivilegeFileModel.getVoucherNo());// 优惠券ID
					String createDate = StringUtils.addNullString(8,
							DateHelper.getyyyyMMdd(makePrivilegeFileModel.getCreateTime()));// 订单创建日期
					String contIdcard = StringUtils.addNullString(30, makePrivilegeFileModel.getContIdcard());// 证件号---针对定长设置30位
					// donghb 0906 start
					String curStatusId = StringUtils.dealNull(makePrivilegeFileModel.getCurStatusId());// 订单状态
					// donghb 0906 end
					String dateSerial = StringUtils.addNullString(14,
							makePrivilegeFileModel.getDoDate() + makePrivilegeFileModel.getDoTime());// 交易时间流水号
					String tradeCode = StringUtils.addNullString(6, "");// 交易码
					if ("0308".equals(curStatusId) || "0310".equals(curStatusId)) {// 支付成功，已签收
						tradeCode = "BVS405";// 使用
					} else if ("0312".equals(curStatusId) || "0327".equals(curStatusId)
							|| "0380".equals(curStatusId) || "0381".equals(curStatusId)) {// 已撤单、退货成功
						tradeCode = "BVS406";// 撤销
					} else if ("0307".equals(curStatusId) || "0304".equals(curStatusId)) {// 支付失败、已废单
						tradeCode = "000000";// 支付失败
					}
					// 组装对账文件
					String line = "MALL" + contIdcard + privilegeId + tradeCode + createDate + dateSerial;
					bw.write(line);
					bw.newLine();
				}

				makeCheckAccSubManager.updateTblOrderCheck();// 更新优惠券对账文件表
				log.info("生成对账文件完成，更新优惠券对账文件表成功!");

			} else {
				log.info("未找到需要生成优惠券对账文件的数据!");
			}
			FileWriter fwNullFile = new FileWriter(nullFileName);
			bwNullFile = new BufferedWriter(fwNullFile);
			// 插入集中调度历史任务表
			makeCheckAccSubManager.insertTblMkfileInf();
			log.info("生成标志文件完成,更新集中调度任务历史表完成 !");
			bw.flush();
			bw.close();
			bw = null;
			bwNullFile.flush();
			bwNullFile.close();
			bwNullFile = null;
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage(), e);
			throw new BatchException(e);
		} finally {
			if (bw != null) {
				try {
					bw.flush();
					bw.close();
				} catch (IOException e) {
					e.printStackTrace();
					log.error(e.getMessage(), e);
				}
				bw = null;
			}
			if (null != bwNullFile) {
				try {
					bwNullFile.flush();
					bwNullFile.close();
				} catch (Exception e) {
					e.printStackTrace();
					log.error("关闭 bwNullFile writer失败:" + e.getMessage(), e);
				}
				bwNullFile = null;
			}
			if (null != localFileName && localFileName.trim().length() > 0) {
				try {
					File localFile = new File(localFileName);
					if (!localFile.exists()) {
						localFile.createNewFile();
					}
					log.info("chmod 777 " + localFileName);
					Runtime.getRuntime().exec(" chmod 777 " + localFileName);
				} catch (Exception e) {
					log.error("chmod 777 失败:" + localFileName, e);
				}
			}
			if (null != nullFileName && nullFileName.trim().length() > 0) {
				try {
					File localFile = new File(nullFileName);
					if (!localFile.exists()) {
						boolean ceateFlag = localFile.createNewFile();
						log.info("创建文件:" + nullFileName + "," + ceateFlag);
					}
					log.info("chmod 777 " + nullFileName);
					Runtime.getRuntime().exec(" chmod 777 " + nullFileName);
				} catch (Exception e) {
					log.error("chmod 777 失败:" + nullFileName, e);
				}
			}
		}

	}

	/**
	 * <p>
	 * Description:上送积分系统渠道标志转换
	 * </p>
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
}
