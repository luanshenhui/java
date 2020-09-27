package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;
import hongling.entity.FabricWareroom;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveFabricWareroom extends BaseServlet {
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
			formData=formData+"}";
			String ID = EntityHelper.getValueByParamID(formData);
			FabricWareroom fabricWareroom=new FabricWareroom();
			if(ID.length()>0){
				fabricWareroom=new FabricWareroomManager().getFabricWareroomByID(ID);
			}
			fabricWareroom=(FabricWareroom)EntityHelper.updateEntityFromFormData(fabricWareroom,formData);
			new FabricWareroomManager().saveFabricWareroom(fabricWareroom);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
