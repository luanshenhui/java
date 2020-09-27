package hongling.service.distribution;

import hongling.business.LogisticsManager;
import hongling.entity.Logistics;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mchange.v2.resourcepool.ResourcePool.Manager;

import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class AddDistributions extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		try {
			super.service();
			String param=getParameter("formData");
			String createby=CurrentInfo.getCurrentMember().getName();
			SimpleDateFormat dateformat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String now=dateformat.format(new Date());
			param=param.replace("}",",");
			param=param+"'createby':'"+createby+"'";
			param=param+",";
			param=param+"'createtime':'"+now+"'";
			param=param+"}";
			Logistics logistics=new Logistics();
			logistics=(Logistics)EntityHelper.updateEntityFromFormData(logistics, param);
			new LogisticsManager().saveLogistics(logistics);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
