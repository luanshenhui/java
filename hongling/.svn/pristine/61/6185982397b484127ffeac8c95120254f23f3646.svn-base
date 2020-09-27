package rcmtm.synchronousDealCash;

import java.lang.reflect.Field;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.hibernate.SQLQuery;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;

import centling.entity.Deal;
import chinsoft.business.CDict;
import chinsoft.business.CompanysManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.XmlManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.InterfaceOperateInfo;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;

/**
 * 定时搜索 状态 不同步的订单 分线程发送
 * 
 * @author Administrator
 * 
 */
public class SearchDealCashTask implements Runnable {
	
	private final static ScheduledExecutorService service = Executors.newScheduledThreadPool(10);
	SearchDealCashService searchDealCashService =new SearchDealCashService();
	
	@Override
	public void run() {

		LogPrinter.info(new SimpleDateFormat("yyyy-mm-dd_HH:mm:ss").format(new Date()) + "  扫瞄需要同步的oa扣费信息!");
		
			String userid1="208";//添加料册的源数据
			String workflowId1="3861";
			String userId2="5096";//添加材料发货的源数据
			String workflowId2="721";
			String userId3="114";//添加返修接口
			String workflowId3="7341";
			Date date=new Date();
			try {
				LogPrinter.info("扫瞄需要同步的oa扣费信息start");
				searchDealCashService.findMaterialVolumesDealCash(userid1,workflowId1,date);

				searchDealCashService.findMaterialDealCash(userId2, workflowId2,date);

				searchDealCashService.findReturnRepairDealCash(userId3, workflowId3,date);

			} catch (Exception e) {
				LogPrinter.info("发生异常");
				LogPrinter.error(e);
				e.printStackTrace();
			}
			LogPrinter.info(new SimpleDateFormat("yyyy-mm-dd_HH:mm:ss").format(new Date()) + "扫瞄需要同步的oa扣费信息end");
	}

}
