package hongling.service.fabrictrader;

import hongling.business.FabricTraderManager;
import hongling.entity.FabricTrader;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SaveFabricTrader extends BaseServlet {
 @Override
protected void service(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
	
	try {
		super.service();
		String formData=getParameter("formData");
		String name=CurrentInfo.getCurrentMember().getUsername();
		SimpleDateFormat dateformat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String now=dateformat.format(new Date());
		formData=formData.replace("}",",");
		formData=formData+"'createBy':'"+name+"'";
		formData=formData+",";
		formData=formData+"'createTime':'"+now+"'";
		formData=formData+",";
		formData=formData+"'traderlevel':'1'";
		formData=formData+"}";
		String ID = EntityHelper.getValueByParamID(formData);
		FabricTrader fabricTrader=new FabricTrader();
		if(ID.length()>0){
			fabricTrader=new FabricTraderManager().getFabricTraderByID(ID);
		}
		fabricTrader=(FabricTrader)EntityHelper.updateEntityFromFormData(fabricTrader,formData);
		new FabricTraderManager().saveFabricTrader(fabricTrader);
		output(Utility.RESULT_VALUE_OK);
	} catch (Exception e) {
		e.printStackTrace();
	}
}

} 
