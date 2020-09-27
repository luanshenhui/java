package chinsoft.business;

import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.ElementFont;

public class ElementFontManager {

	DataAccessObject dao = new DataAccessObject();
	private static List<ElementFont> fonts = null;
	
	@SuppressWarnings({ "static-access", "unchecked" })
	public List<ElementFont> getElementFonts()
    {
    	try {
    		if(fonts == null){		
    			Query query = dao.openSession().createQuery("FROM ElementFont");
    			fonts=query.list();
    		}
			
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			dao.closeSession();
		}
    	return fonts;
    }
	
	public String getElementFont(Integer nContentID,String strTempComponentIDs)
    {
		List<ElementFont> elementFonts = this.getElementFonts();
		
		String strFont = "arial";
    	try {
    		Dict content = DictManager.getDictByID(nContentID);
			if(content != null){
				Dict position = DictManager.getDictByID(content.getParentID());
				if(position != null){
					List<Dict> dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(),position.getID());
					if(dicts.size()>0){
						List<Dict> allFonts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(),dicts.get(1).getID());
						for(Dict font:allFonts){
							if(Utility.contains(strTempComponentIDs, Utility.toSafeString(font.getID()))){
								for(ElementFont elementFont:elementFonts){
									if(Utility.contains(elementFont.getElementIDs(),Utility.toSafeString(font.getID()))){
										strFont = elementFont.getFont();
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
    	return strFont;
    }
}