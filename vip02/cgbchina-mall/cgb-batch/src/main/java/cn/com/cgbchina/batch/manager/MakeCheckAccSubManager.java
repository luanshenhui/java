package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.MakeCheckAccDao;
import cn.com.cgbchina.batch.dao.MakePrivilegeFileDao;
import cn.com.cgbchina.batch.model.TblMakecheckjobHistoryModel;
import cn.com.cgbchina.common.utils.DateHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by w2001316 on 2016/7/28.
 */
@Component
@Slf4j
@Transactional
public class MakeCheckAccSubManager {

	@Resource
	private MakeCheckAccDao makeCheckAccDao;

	@Resource
	private MakePrivilegeFileDao makePrivilegeFileDao;
	@Transactional
	public int daoCreate(boolean ftsFlag, String yestoday, String payResultTime, Long id1, Long id2, int againTimes) {
		int retTimes = againTimes;
		if (ftsFlag) {
			log.info("积分系统对账文件接口返回成功(正常跑)");
			makeCheckAccDao.updateCheckStatus(yestoday, payResultTime);// 更新对账文件状态
			// 更新数据库字段
			makeCheckAccDao.updateTblOrderCancel(yestoday);// 更新退货的对账文件状态
			// 积分对账跑完之后需要重置对应状态
			if (id1 != null) {
				makeCheckAccDao.updatePoint1(id1, yestoday);
			}
			if (id2 != null) {
				makeCheckAccDao.updatePoint2(id2, yestoday);
			}
			retTimes = 3;
			TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
			tblMakecheckjobHistory.setOpe("System");
			tblMakecheckjobHistory.setOpedate(DateHelper.getyyyyMMdd());
			tblMakecheckjobHistory.setOpetime(DateHelper.getHHmmss());
			tblMakecheckjobHistory.setIp("");
			tblMakecheckjobHistory.setDate(DateHelper.string2Date(yestoday, DateHelper.YYYYMMDD));
			tblMakecheckjobHistory.setResult("0");
			tblMakecheckjobHistory.setResultdesc("成功");
			tblMakecheckjobHistory.setDesc("");
			tblMakecheckjobHistory.setIsshoudong("1");
			tblMakecheckjobHistory.setIsrenew("正常跑");
			makeCheckAccDao.insertTblMakecheckjobHistory(tblMakecheckjobHistory);// 插入历史
		} else {// 如果不成功
			log.info("积分系统对账文件接口返回失败(正常跑)");
			retTimes++;
			TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
			tblMakecheckjobHistory.setOpe("System");
			tblMakecheckjobHistory.setOpedate(DateHelper.getyyyyMMdd());
			tblMakecheckjobHistory.setOpetime(DateHelper.getHHmmss());
			tblMakecheckjobHistory.setIp("");
			tblMakecheckjobHistory.setDate(DateHelper.string2Date(yestoday, DateHelper.YYYYMMDD));
			tblMakecheckjobHistory.setResult("1");
			tblMakecheckjobHistory.setResultdesc("失败");
			tblMakecheckjobHistory.setDesc("");
			tblMakecheckjobHistory.setIsshoudong("1");
			tblMakecheckjobHistory.setIsrenew("正常跑");
			makeCheckAccDao.insertTblMakecheckjobHistory(tblMakecheckjobHistory);// 插入历史
		}
		return retTimes;
	}
	@Transactional
	public void insertTblMakecheckjobHistory(TblMakecheckjobHistoryModel tblMakecheckjobHistory) {
		makeCheckAccDao.insertTblMakecheckjobHistory(tblMakecheckjobHistory);
	}
	@Transactional
	public void updateTblOrderCheck() {
		makePrivilegeFileDao.updateTblOrderCheck();
	}
	@Transactional
	public void insertTblMkfileInf() {
		makePrivilegeFileDao.insertTblMkfileInf();
	}
}
