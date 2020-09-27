package hongling.service.distribution;

import hongling.business.LogisticsManager;
import hongling.entity.Logistics;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveDistributionById extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			String param=getParameter("formData");
			String ID = EntityHelper.getValueByParamID(param);
			Logistics logistics=new Logistics();
			if(ID.length()>0){
				logistics= new  LogisticsManager().getLogisticsById(ID);
			}
			logistics=(Logistics)EntityHelper.updateEntityFromFormData(logistics,param);
			new LogisticsManager().saveLogistics(logistics);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
