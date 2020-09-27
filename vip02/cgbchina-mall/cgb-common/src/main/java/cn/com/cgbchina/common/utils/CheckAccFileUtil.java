package cn.com.cgbchina.common.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import lombok.extern.slf4j.Slf4j;

/**
 * 新文服 文件名、路径处理
 * 主要处理日期匹配；777目录创建
 * @author hwh 20250623
 */
@Slf4j
public class CheckAccFileUtil {

	/**
	 * 匹配路里面的日期格式，进行替换
	 * @param patternStr 模式例如 \\[[yMdHms]+\\]
	 * @param patternRepStr 替换模式中[] 留下日期格式
	 * @param str 要转换的字符串
	 * @param date 特定日期（null：取当前日期）
	 * @return
	 * 20150424 hwh  同时转换多个文件的，不能确保全部文件时间一致（请在特定的场景使用）；
	 */
	public String dealDatePatternStr(String patternStr,String patternRepStr,String str,Date date){
		Pattern pattern = Pattern.compile(patternStr);
		Matcher matcher = pattern.matcher(str);
		log.info("patternStr:"+patternStr+",str:"+str);;
		List matchList = new ArrayList();
		List convertMatchList = new ArrayList();
		if(matcher.matches()){//完全匹配，返回当前字符串
			log.info("完全匹配");
			matchList.add(str);
		}else{//非完全匹配
			while (matcher.find()){//记录匹配项
				log.info("matcher.group():"+matcher.group());
				matchList.add(matcher.group());
			}
		}
		log.info("retList:"+matchList);
		//把匹配的日期格式，输出成对应的日期
		if(null!=matchList && matchList.size()>0){
			for(int i =0;i<matchList.size();i++){
				String tempItem = null == matchList.get(i)?"":String.valueOf(matchList.get(i)).trim();
				if(null!=tempItem && tempItem.length()>0){
					try{
						String tempDate="";
						if(null!=date){//日期不为空
							//替换模式符合 例如 匹配模式是 [yMd+] ,会替换"["和"]",剩余日期格式
							tempDate = DateHelper.date2string(date, tempItem.replaceAll(patternRepStr, ""));
						}else{
							tempDate = DateHelper.date2string(new Date(), tempItem.replaceAll(patternRepStr, ""));
						}
						log.info("tempDate:"+tempDate);
						convertMatchList.add(tempDate);
					}catch(Exception e ){
						log.error("转换异常:"+tempItem,e);
						convertMatchList.add("");
					}
				}else{
					convertMatchList.add("");
				}
			}
		}
		log.info("convertMatchList:"+convertMatchList);
		for(int i = 0;i<matchList.size() && i<convertMatchList.size();i++){
			String tempMatch = null==matchList.get(i)?"":String.valueOf(matchList.get(i)).trim();
			String tempConv = null==convertMatchList.get(i)?"":String.valueOf(convertMatchList.get(i)).trim();
			if(tempMatch.length()>0 && tempConv.length()>0){
				str = str.replace(tempMatch, tempConv);
			}
		}
		log.info("result:"+str);
		return str;
	}

	/**
	 * 创建目录，且赋予777权限给新增的目录
	 * @param path
	 * @return
	 * hwh 20150428 
	 */
	public boolean createDirectory(String path)throws Exception{
		log.info("path:"+path);
		if(null == path || 0==path.trim().length()){
			return false;
		}
		File temp = new File(path);
		if(temp.exists()){
			return true;
		}else{
			log.info("parent:"+temp.getParent());
			if(!createDirectory(temp.getParent())){
				return false;
			}
			if(temp.mkdir()){
				//chmod 777 
				try{
					log.info("create directory:"+temp.getPath());
					log.info("chmod 777 to current folder");
					Runtime.getRuntime().exec( "chmod 777 "+temp.getPath());
				}catch(Exception e){
					log.error("chmod 777 "+temp.getPath()+",error:"+e.getMessage(),e);
				}
				return true;
			}else{
				return false;
			}
		}
	}
}
