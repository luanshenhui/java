package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.entity.FixedStyle;

public class FixedStyleManager {

	private static List<FixedStyle> fixedStyles = null;
	@SuppressWarnings("unchecked")
	public List<FixedStyle> getFixedStyles()
    {
    	try {
    		if(fixedStyles == null){		
    			Query query = DataAccessObject.openSession().createQuery("FROM FixedStyle order by sequenceNo");
    			fixedStyles=query.list();
    		}
			
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return fixedStyles;
    }
	
	public FixedStyle getFixedStyleByID(Integer nID){
		List<FixedStyle> fixedStyles = this.getFixedStyles();
		for(FixedStyle fixedStyle:fixedStyles){
			if(fixedStyle.getFixedID().equals(nID)){
				return fixedStyle;
			}
		}
		return null;
	}
	
	public boolean isFixStyle(Integer nID){
		if(this.getFixedStyleByID(nID) == null){
			return false;
		}else{
			return true;
		}
	}
	
	public List<FixedStyle> getFixStylesBySingleClothingID(Integer nSingleClothingID){
		List<FixedStyle> fixedStyles = new ArrayList<FixedStyle>();
		//根据前四位判断是相同的
		//得到所有的产品
		List<FixedStyle> all =this.getFixedStyles();
		//得到SingleClothingID中的code
		String clothingCode = DictManager.getDictByID(nSingleClothingID).getCode();
		//循环产品
		for(int i=0; i<all.size(); i++){
			//通过getDictByID()得到产品中DICT的code
			FixedStyle fixedStyle = all.get(i);
			int fixedId = fixedStyle.getFixedID();
			Dict dict  = DictManager.getDictByID(fixedId);
			if(dict != null){
				String fixedCode = dict.getCode();
				//将dict.code前4位与SingleClothingID.code的前四位相比较，相同的就是该服装的固定样式
				if((clothingCode.substring(0, 4)).equals(fixedCode.subSequence(0, 4))){
					fixedStyles.add(fixedStyle);
				}
			}
		}
		
		return fixedStyles;
	}
}