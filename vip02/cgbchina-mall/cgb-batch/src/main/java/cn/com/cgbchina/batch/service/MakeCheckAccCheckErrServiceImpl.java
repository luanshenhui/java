package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.MakeCheckAccCheckErrDao;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
@Service
@Slf4j
public class MakeCheckAccCheckErrServiceImpl implements MakeCheckAccCheckErrService {

	@Resource
	private MakeCheckAccCheckErrDao makeCheckAccCheckErrDao;
	public Response<Boolean> allFunctions(){//调用所有方法
		log.info("【集中调度】对账文件异常检查任务开始...");
		Response<Boolean> response = new Response<>();
		String isShouDong = "";
		try {
			isShouDong = getisShouDong();
			log.info("AccChecking:isShouDong=="+isShouDong);
			String datetime = DateTime.now().toString(DateHelper.YYYY_MM_DD).concat(" 00:00:00");
			makeCheckAccCheckErrWithTxn(datetime);
			makeCheckCancelErrWithTxn(datetime);
			String yestoday = DateTime.now().minusDays(1).toString(DateHelper.YYYYMMDD);
			makeCheckCheckErrWithTxn(yestoday);
			log.info("【集中调度】对账文件任异常检查任务结束");
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("对账文件任异常检查任务异常{}.",Throwables.getStackTraceAsString(e));
			//判断是否手动处理对账文件异常标示，如果是自动则表示正常执行返回0不报警，如果是手动则返回1报警。
			if("1".equals(isShouDong)) {
				response.setResult(Boolean.TRUE);
				return response;
			} else {
				response.setError(Throwables.getStackTraceAsString(e));
				response.setResult(Boolean.FALSE);
				return response;
			}
		}
	}

	/**
	 * 获取是否手动处理对账文件异常标示 0:手动 1:自动
	 * @return
	 * @throws Exception
	 */
	private String getisShouDong() throws Exception {
		return makeCheckAccCheckErrDao.getIsShouDong();
	}

	private void makeCheckAccCheckErrWithTxn(String datetime) throws Exception {
		Long i = makeCheckAccCheckErrDao.getMakeAccErrSum(datetime);
		log.info("查出了" + i.longValue() + "条");
		if(i != null && i.longValue() > 0) {//如果有异常数据，报警
			throw new Exception();
		}
	}

	private void makeCheckCancelErrWithTxn(String datetime) throws Exception{
		Long i = makeCheckAccCheckErrDao.getUncheckNum(datetime);
		log.info("退货记录检查查出了" + i.longValue() + "条");
		if(i != null && i.longValue() > 0) {//有异常数据存在
			throw new Exception();
		}
	}

	private void makeCheckCheckErrWithTxn(String datetime) throws Exception {
		int i = makeCheckAccCheckErrDao.getCheckUncheckNum(datetime);
		log.info("广发积分记录检查查出了" + i + "条");
		if( i > 0) {//有异常数据存在
			throw new Exception();
		}
	}
}
