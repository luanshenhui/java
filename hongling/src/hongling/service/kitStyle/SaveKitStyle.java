package hongling.service.kitStyle;

import hongling.entity.FabricWareroom;
import hongling.entity.KitStyle;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import hongling.business.KitStyleManager;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveKitStyle extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			super.service();
			String formdata=getParameter("formData");
			//{'ID':'','kitStyleNo':'afdafa','category':'1','defaultFabric':'MBK123A','fabrics':'MBK123A%2C','style_3':'MXF0001','style_2000':'%u62C9%u98CE%u6B3E%u5F0F','titleCn':'','titleEn':''}
			String id=getParameter("ID");
			String code=getParameter("kitStyleNo");
			String category=getParameter("category");
			String defaultFabric=getParameter("defaultFabric");
			String fabrics=getParameter("fabrics");
			String categoryId=getParameter("style_3")+","+getParameter("style_2000");
			if(!"".equals(getParameter("style_4000"))){
				categoryId=categoryId+","+getParameter("style_4000");
			}
			String titleCn=getParameter("titleCn");
			String titleEn=getParameter("titleEn");
			String strStyleID=getParameter("styleIDs");
			
			String name=CurrentInfo.getCurrentMember().getUsername();
			SimpleDateFormat dateformat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String now=dateformat.format(new Date());
			formdata="{";
			formdata=formdata+"'ID':'"+id+"'";
			formdata=formdata+",";
			formdata=formdata+"'code':'"+code+"'";
			formdata=formdata+",";
			formdata=formdata+"'categoryID':'"+categoryId+"'";
			formdata=formdata+",";
			formdata=formdata+"'defaultFabric':'"+defaultFabric+"'";
			formdata=formdata+",";
			formdata=formdata+"'fabrics':'"+fabrics+"'";
			formdata=formdata+",";
			formdata=formdata+"'title_Cn':'"+titleCn+"'";
			formdata=formdata+",";
			formdata=formdata+"'title_En':'"+titleEn+"'";
			formdata=formdata+",";
			formdata=formdata+"'createBy':'"+name+"'";
			formdata=formdata+",";
			formdata=formdata+"'createTime':'"+now+"'";
			formdata=formdata+",";
			formdata=formdata+"'status':'1'";
			formdata=formdata+",";
			formdata=formdata+"'styleID':'"+strStyleID+"'";
			formdata=formdata+",";
			formdata=formdata+"'clothingID':'"+category+"'";
			formdata=formdata+"}";
			
			//System.out.println(formdata);
			KitStyle kitStyle=new KitStyle();
			String ID = EntityHelper.getValueByParamID(formdata);
			if(ID.length()>0){
				kitStyle=new KitStyleManager().getKitStyleByID(id);
			}
			kitStyle=(KitStyle)EntityHelper.updateEntityFromFormData(kitStyle,formdata);
			new KitStyleManager().saveKitStyle(kitStyle);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
