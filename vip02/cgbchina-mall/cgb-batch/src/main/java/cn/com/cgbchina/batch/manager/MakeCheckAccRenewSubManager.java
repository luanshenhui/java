package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.MakeCheckAccRenewDao;
import cn.com.cgbchina.batch.model.TblMakecheckjobHistoryModel;
import cn.com.cgbchina.common.utils.DateHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by w2001316 on 2016/7/29.
 */
@Component
@Slf4j
@Transactional
public class MakeCheckAccRenewSubManager {

    @Resource
    private MakeCheckAccRenewDao makeCheckAccRenewDao;
    @Transactional
    public void accRenewDaoCreate(boolean ftsFlag, String day, String payResultTime, Long id1, Long id2) {
        if (ftsFlag) {
            log.info("积分系统对账文件接口返回成功(自动补跑):00");
            //更新对账文件状态
            makeCheckAccRenewDao.updateCheckStatus(day, payResultTime);
            log.info("更新退货对账文件状态");
            //更新退货对账文件状态
            makeCheckAccRenewDao.updateTblOrderCancel(day);
            if (id1 != null) {//更新正交易对账文件标志
                makeCheckAccRenewDao.updateTblOrderPoint1(id1, day);
            }
            if (id2 != null) {//更新负交易对账文件标志
                makeCheckAccRenewDao.updateTblOrderPoint2(id2, day);
            }

            TblMakecheckjobHistoryModel tblMakecheckjobHistory = new TblMakecheckjobHistoryModel();
            tblMakecheckjobHistory.setOpe("System");
            tblMakecheckjobHistory.setOpedate(DateHelper.getyyyyMMdd());
            tblMakecheckjobHistory.setOpetime(DateHelper.getHHmmss());
            tblMakecheckjobHistory.setIp("");
            tblMakecheckjobHistory.setDate(DateHelper.string2Date(day, DateHelper.YYYYMMDD));
            tblMakecheckjobHistory.setResult("0");
            tblMakecheckjobHistory.setResultdesc("成功");
            tblMakecheckjobHistory.setDesc("");
            tblMakecheckjobHistory.setIsshoudong("自动");
            tblMakecheckjobHistory.setIsrenew("补跑");
            makeCheckAccRenewDao.insertTblMakecheckjobHistory(tblMakecheckjobHistory);//插入历史
        } else {//如果不成功
            log.info("积分系统对账文件接口返回失败(自动补跑)");
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
            makeCheckAccRenewDao.insertTblMakecheckjobHistory(tblMakecheckjobHistory);//插入历史
        }
    }
    @Transactional
    public void insertTblMakecheckjobHistory(TblMakecheckjobHistoryModel tblMakecheckjobHistory) {
        makeCheckAccRenewDao.insertTblMakecheckjobHistory(tblMakecheckjobHistory);
    }
}
