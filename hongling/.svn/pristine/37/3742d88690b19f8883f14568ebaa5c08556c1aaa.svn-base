package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.SizeRange;

public class SizeRangeManager {

	DataAccessObject dao = new DataAccessObject();
	private static List<SizeRange> sizeRanges = null;
	
	@SuppressWarnings("unchecked")
	private List<SizeRange> getSizeRanges()
    {
    	try {
    		if(sizeRanges == null){		
    			Query query = DataAccessObject.openSession().createQuery("FROM SizeRange");
    			sizeRanges=query.list();
    		}
    		
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	List<SizeRange> ranges = new ArrayList<SizeRange>();
    	for(SizeRange range: sizeRanges){
    		ranges.add((SizeRange)range.clone());
    	}
    	return ranges;
    }

	public List<SizeRange> getSizeRange(String strSign, Integer nUnitID){
		List<SizeRange> ranges = new ArrayList<SizeRange>();
		for(SizeRange range:this.getSizeRanges()){
			if(StringUtils.isNotEmpty(range.getSign()) && range.getSign().equals(strSign)){
				ranges.add(range);
			}
		}
		extendRanges(ranges, nUnitID);
		return ranges;
	}

	public List<SizeRange> getSizeRange(String strSizeStandardID, String strSign, Integer nUnitID){
		List<SizeRange> ranges = new ArrayList<SizeRange>();
		for(SizeRange range:this.getSizeRanges()){
			if(StringUtils.isNotEmpty(range.getSizeStandardIDs()) && Utility.contains(range.getSizeStandardIDs(),strSizeStandardID)){
				if(StringUtils.isNotEmpty(range.getSign()) && range.getSign().equals(strSign)){
					ranges.add(range);
				}
			}
		}
		extendRanges(ranges, nUnitID);
		return ranges;
	}
	
	private void extendRanges(List<SizeRange> ranges, Integer nUnitID){
		for(SizeRange range:ranges){
			if(CDict.UnitInch.getID().equals(nUnitID)){
				if(StringUtils.isNotEmpty(Utility.toSafeString(range.getSizeFrom()))){
					range.setSizeFrom(Utility.cmToInch(range.getSizeFrom()));
				}
				if(StringUtils.isNotEmpty(Utility.toSafeString(range.getSizeTo()))){
					range.setSizeTo(Utility.cmToInch(range.getSizeTo()));
				}
			}
		}
	}
}