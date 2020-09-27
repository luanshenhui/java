package chinsoft.business;

import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.ElementColor;

public class ElementColorManager {

	DataAccessObject dao = new DataAccessObject();
	private static List<ElementColor> colors = null;
	
	@SuppressWarnings({ "static-access", "unchecked" })
	public List<ElementColor> getElementColors()
    {
    	try {
    		if(colors == null){		
    			Query query = dao.openSession().createQuery("FROM ElementColor");
    			colors=query.list();
    		}
			
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			dao.closeSession();
		}
    	return colors;
    }
	
	public String getElementColor(Integer nContentID,String strTempComponentIDs)
    {
		List<ElementColor> elementColors = this.getElementColors();
		
		String strColor = "ff0000";
    	try {
    		Dict content = DictManager.getDictByID(nContentID);
			if(content != null){
				Dict cixiu = DictManager.getDictByID(content.getParentID());
				if(cixiu != null){
					List<Dict> dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(),cixiu.getID());
					if(dicts.size()>0){
						List<Dict> allColors = DictManager.getDicts(CDictCategory.ClothingCategory.getID(),dicts.get(0).getID());
						for(Dict color:allColors){
							if(Utility.contains(strTempComponentIDs, Utility.toSafeString(color.getID()))){
								for(ElementColor elementColor:elementColors){
									if(Utility.contains(elementColor.getElementIDs(),Utility.toSafeString(color.getID()))){
										strColor = elementColor.getColor();
									}
								}
							}
						}
					}
				}
			}
			
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
    	return strColor;
    }
}