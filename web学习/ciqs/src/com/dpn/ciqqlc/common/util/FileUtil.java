package com.dpn.ciqqlc.common.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.aspose.words.Document;
import com.aspose.words.SaveFormat;

public class FileUtil {
    
    private static final Logger logger_ = LoggerFactory.getLogger(FileUtil.class);
    
    
    //获取根目录 @LiuChao 2019/11/19
    /*private static String webRootPath(){
		String webRootPath = PropertieUtils.class.getClassLoader().getResource("").getPath();
		webRootPath = webRootPath.substring(0, webRootPath.length() -16);
		webRootPath += "static/pdf_template/";
		return webRootPath;
	}*/
	//public final static String file_path = webRootPath();

	/**
	 * 文件上传
	 * @param file文件对象
	 * @param fileName文件上传全目录(开发期间默认存放在E:\temp\yyyyMM\yyyyMMdd\)
	 * @throws Exception
	 * @return Map数组 (key : "formName" - 表单中文件名称, "filePath" - 文件存储路径)
	 */
	public static List<Map<String, String>> uploadFile(HttpServletRequest request , boolean isApp)
			throws Exception {
		List<Map<String, String>> filePathList = new ArrayList<Map<String, String>>();
		try { 
			DateFormat df1 = new SimpleDateFormat("yyyyMM");
			DateFormat df2 = new SimpleDateFormat("yyyyMMdd");
			
			Date date = new Date(System.currentTimeMillis());
			//String tempContents = "D:\\tmp\\";//临时目录
			String tempContents = Constants.UP_LOAD_P+Constants.UP_LOAD_TMP;
			//String fileSaveMonth = "D:\\"+df1.format(date);//附件保存月目录
			String fileSaveMonth = Constants.UP_LOAD_P+df1.format(date);//附件保存月目录
			if(!(new File(fileSaveMonth).isDirectory())){
				new File(fileSaveMonth).mkdir();
			}
			
//			String fileSaveContents = "D:\\"+df1.format(date)+"\\"+df2.format(date);//附件保存日目录
			String fileSaveContents = Constants.UP_LOAD_P+df1.format(date)+"/"+df2.format(date);//附件保存日目录
			if(!(new File(fileSaveContents).isDirectory())){
				new File(fileSaveContents).mkdir();
			}
			
			DiskFileItemFactory diskFactory = new DiskFileItemFactory();
			diskFactory.setSizeThreshold(4096);
			diskFactory.setRepository(new File(tempContents));

			/*
			ServletFileUpload upload = new ServletFileUpload(diskFactory);
			
			List fileItems = upload.parseRequest(request);
			Iterator iter = fileItems.iterator();

			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (!item.isFormField()) {
					String filename = item.getName();
					filename = filename.substring(filename.lastIndexOf("/"),filename.length());
					uploadFile = new File(fileSaveContents + filename);
					item.write(uploadFile);
				}
			}
			*/
			
			MultipartHttpServletRequest mhsreq = (MultipartHttpServletRequest)request;
			Iterator<String> fileNameIt = mhsreq.getFileNames();
			while(fileNameIt.hasNext()){
				String fileName = fileNameIt.next();
				MultipartFile file = mhsreq.getFile(fileName);
				
				String newFileName="";
				if(isApp){
//					newFileName=UUID.randomUUID().toString()+"."+ file.getOriginalFilename().split("\\.")[1];
					newFileName=file.getOriginalFilename();
				}else{
					newFileName=DateUtil.DateToString(new Date(), "yyyyMMddHHmmssSSS")+(int)(Math.random()*100)+"."+ file.getOriginalFilename().split("\\.")[1];
				}
				if("".equals(newFileName)){
					continue;
				}
				InputStream is = file.getInputStream();
				FileOutputStream fos = new FileOutputStream(new File(fileSaveContents + "/" +newFileName));
				try {
					int bytesRead = 0;
					byte[] buffer = new byte[1024];
					while((bytesRead = is.read(buffer, 0, 1024)) != -1){
						fos.write(buffer, 0, bytesRead);
					}
					if(null != file){}
				} catch (Exception e) {
					throw e;
				} finally {
					is.close();
					fos.flush();
					fos.close();
					Map<String, String> map = new HashMap<String, String>();
					map.put("name", fileName);
					map.put("fileName", newFileName);
					//map.put("filePath", (fileSaveContents + "\\" + file.getOriginalFilename()).replaceAll("\\\\", "/"));
//					map.put("filePath", (fileSaveContents + "/" + file.getOriginalFilename()));
					String filePath=fileSaveContents + "/" + newFileName;
					filePath = filePath.substring(filePath.indexOf("\\"+Constants.UP_LOAD_P)+17,filePath.length());
					map.put("filePath", filePath);
					filePathList.add(map);
				}
			}
			//List<MultipartFile> l = mhsreq.getFiles(Constants.UPLOAD_PARAM_NAME);
			//for(MultipartFile file : l){
				
			//}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return filePathList;
	}
	
	/**
	 * 上传单个文件
	 * 文件会重命名到毫秒
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String uploadOneFile(HttpServletRequest request)throws Exception {
		String newfile="";
		try { 
			DateFormat df1 = new SimpleDateFormat("yyyyMM");
			DateFormat df2 = new SimpleDateFormat("yyyyMMdd");
			
			Date date = new Date(System.currentTimeMillis());
			String tempContents = Constants.UP_LOAD_P+Constants.UP_LOAD_TMP;
			String fileSaveMonth = Constants.UP_LOAD_P+df1.format(date);//附件保存月目录
			if(!(new File(fileSaveMonth).isDirectory())){
				new File(fileSaveMonth).mkdir();
			}
			String fileSaveContents = Constants.UP_LOAD_P+df1.format(date)+"/"+df2.format(date);//附件保存日目录
			if(!(new File(fileSaveContents).isDirectory())){
				new File(fileSaveContents).mkdir();
			}
			DiskFileItemFactory diskFactory = new DiskFileItemFactory();
			diskFactory.setSizeThreshold(4096);
			diskFactory.setRepository(new File(tempContents));
			
			MultipartHttpServletRequest mhsreq = (MultipartHttpServletRequest)request;
			Iterator<String> fileNameIt = mhsreq.getFileNames();
			while(fileNameIt.hasNext()){
				String fileName = fileNameIt.next();
				MultipartFile file = mhsreq.getFile(fileName);
				InputStream is = file.getInputStream();
				newfile=fileSaveContents + "/" + DateUtil.DateToString(new Date(), "yyyyMMddHHmmssSSS")+"."+file.getOriginalFilename().split("\\.")[1];
				FileOutputStream fos = new FileOutputStream(new File(newfile));
				try {
					int bytesRead = 0;
					byte[] buffer = new byte[1024];
					while((bytesRead = is.read(buffer, 0, 1024)) != -1){
						fos.write(buffer, 0, bytesRead);
					}
					if(null != file){}
				} catch (Exception e) {
					throw e;
				} finally {
					is.close();
					fos.flush();
					fos.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newfile.replaceAll("\\\\", "/");
	}
	
	/**
	 * 文件下载
	 * @param fileName 文件名
	 * 
	 * @param response
	 * @param isDownload 是否下载（不下载则在线打开）
	 * @throws Exception
	 */
	public static void downloadFile(String fileName, HttpServletResponse response, boolean isDownload)
			throws Exception {
		String contentType = "application/x-msdownload";
		String enc = "UTF-8";
		try {
			File file = new File(fileName);// 通过路径读入文件，下载的文件的物理路径＋文件名

			if (file.exists()) {
				String file_name = file.getName();
				file_name = URLEncoder.encode(file.getName(), enc);
				// getResponse的getWriter()方法连续两次输出流到页面的时候，第二次的流会包括第一次的流，所以可以使用将response.reset或者resetBuffer的方法。

				// 加上response.reset()，并且所有的％>后面不要换行，包括最后一个；
				response.reset(); // 非常重要,清空buffer,设置页面不缓存，有则不用bos.flush();
				response.setCharacterEncoding("GB2312");
				if (isDownload) { // 纯下载方式

					response.setContentType(contentType);
					// 客户使用目标另存为对话框保存指定文件
					response.setHeader("Content-Disposition", "attachment; filename=" + file_name);
				} else { // 在线打开方式
					URL u = new URL("file:///" + fileName);
					response.setContentType(u.openConnection().getContentType());
					response.setHeader("Content-Disposition", "inline; filename=" + file_name);
				}
				int fileLength = (int) file.length();
				response.setContentLength(fileLength);
				if (fileLength != 0) {
					InputStream fis = new FileInputStream(file);
					OutputStream fos = response.getOutputStream();
					BufferedInputStream bis = new BufferedInputStream(fis);
					BufferedOutputStream bos = new BufferedOutputStream(fos);
					// 设置缓存
					byte[] buffer = new byte[1024];
					int bytesRead = 0;
					// 循环取出流中的数据
					while ((bytesRead = bis.read(buffer)) != -1) {
						bos.write(buffer, 0, bytesRead);
					}
					fis.close();
					bis.close();
					fos.close();
					bos.flush();
					bos.close();
				}
			}else{
				throw new Exception("文件已不存在");
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * 创建excel工作薄
	 * @param list
	 * @param keys
	 * @param columnNames
	 * @return
	 */
	   public static Workbook createWorkBook(List<Map<String, Object>> list,String []keys,String columnNames[]) {
	        // 创建excel工作簿
	        Workbook wb = new HSSFWorkbook();
	        // 创建第一个sheet（页），并命名
	        Sheet sheet = wb.createSheet(list.get(0).get("sheetName").toString());
	        // 手动设置列宽。第一个参数表示要为第几列设；，第二个参数表示列的宽度，n为列高的像素数。
	        for(int i=0;i<keys.length;i++){
	            sheet.setColumnWidth((short) i, (short) (35.7 * 150));
	        }
	        // 创建第一行
	        Row row = sheet.createRow((short) 0);
	        // 创建两种单元格格式
	        CellStyle cs = wb.createCellStyle();
	        CellStyle cs2 = wb.createCellStyle();
	        // 创建两种字体
	        Font f = wb.createFont();
	        Font f2 = wb.createFont();
	        // 创建第一种字体样式（用于列名）
	        f.setFontHeightInPoints((short) 10);
	        f.setColor(IndexedColors.BLACK.getIndex());
	        f.setBoldweight(Font.BOLDWEIGHT_BOLD);
	        // 创建第二种字体样式（用于值）
	        f2.setFontHeightInPoints((short) 10);
	        f2.setColor(IndexedColors.BLACK.getIndex());

	        Font f3=wb.createFont();
	        f3.setFontHeightInPoints((short) 10);
	        f3.setColor(IndexedColors.RED.getIndex());

	        // 设置第一种单元格的样式（用于列名）
	        cs.setFont(f);
	        cs.setBorderLeft(CellStyle.BORDER_THIN);
	        cs.setBorderRight(CellStyle.BORDER_THIN);
	        cs.setBorderTop(CellStyle.BORDER_THIN);
	        cs.setBorderBottom(CellStyle.BORDER_THIN);
	        cs.setAlignment(CellStyle.ALIGN_CENTER);

	        // 设置第二种单元格的样式（用于值）
	        cs2.setFont(f2);
	        cs2.setBorderLeft(CellStyle.BORDER_THIN);
	        cs2.setBorderRight(CellStyle.BORDER_THIN);
	        cs2.setBorderTop(CellStyle.BORDER_THIN);
	        cs2.setBorderBottom(CellStyle.BORDER_THIN);
	        cs2.setAlignment(CellStyle.ALIGN_CENTER);
	        //设置列名
	        for(int i=0;i<columnNames.length;i++){
	            Cell cell = row.createCell(i);
	            cell.setCellValue(columnNames[i]);
	            cell.setCellStyle(cs);
	        }
	        //设置每行每列的值
	        for (short i = 1; i < list.size(); i++) {
	            // Row 行,Cell 方格 , Row 和 Cell 都是从0开始计数的
	            // 创建一行，在页sheet上
	            Row row1 = sheet.createRow((short) i);
	            // 在row行上创建一个方格
	            for(short j=0;j<keys.length;j++){
	                Cell cell = row1.createCell(j);
	                cell.setCellValue(list.get(i).get(keys[j]) == null?" ": list.get(i).get(keys[j]).toString());
	                cell.setCellStyle(cs2);
	            }
	        }
	        return wb;
	    }

	   /**
	    * 下载excel
	    * @param os
	    * @param response
	    * @param fileName
	    * @throws IOException
	    */
	public static void outPutExcel(ByteArrayOutputStream os, HttpServletResponse response,String fileName) throws IOException {
    	byte[] content = os.toByteArray();
    	InputStream is = new ByteArrayInputStream(content);
    	// 设置response参数，可以打开下载页面
    	response.reset();
    	response.setContentType("application/vnd.ms-excel;charset=utf-8");
    	response.setHeader("Content-Disposition", "attachment;filename="+ new String((fileName + ".xls").getBytes(), "iso-8859-1"));
    	ServletOutputStream out = response.getOutputStream();
    	BufferedInputStream bis = null;
    	BufferedOutputStream bos = null;
    	try {
    		bis = new BufferedInputStream(is);
    		bos = new BufferedOutputStream(out);
    		byte[] buff = new byte[2048];
    		int bytesRead;
    		while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
    			bos.write(buff, 0, bytesRead);
    		}
    	} catch (final IOException e) {
    		throw e;
    	} finally {
    		if (bis != null)
    			bis.close();
    		if (bos != null)
    			bos.close();
    	}
	}

	/**
	 * 口岸卫生许可zip、rar格式文件下载
	 * @param filePath 文件路径
	 * @param response
	 * @throws Exception
	 */
	public static void downXkloadFile(String filePath, HttpServletResponse response)
			throws Exception {
        response.setContentType("APPLICATION/OCTET-STREAM");  
        response.setHeader("Content-Disposition","attachment; filename="+filePath);
        ZipOutputStream out = new ZipOutputStream(response.getOutputStream());
        try {
            ZipUtils.doCompress(Constants.UP_XK_PATH+"/"+filePath, out);
            response.flushBuffer();
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            out.close();
        }
	}
		    
	/**
	 * 卫生许可文件上传
	 * @param isApp
	 * @param request
	 * @throws Exception
	 * @return Map数组 (key : "formName" - 表单中文件名称, "filePath" - 文件存储路径)
	 */
	public static List<Map<String, String>> upXkloadFile(HttpServletRequest request , boolean isApp)
			throws Exception {
		List<Map<String, String>> filePathList = new ArrayList<Map<String, String>>();
		try { 
			String decFilePath = Constants.UP_XK_PATH;
			if(!(new File(decFilePath).isDirectory())){
				new File(decFilePath).mkdir();
			}
			MultipartHttpServletRequest mhsreq = (MultipartHttpServletRequest)request;
			List<MultipartFile> l = mhsreq.getFiles(Constants.UPLOAD_PARAM_NAME);
			for(MultipartFile file : l){
				String filename = file.getOriginalFilename();
				if(filename==null || "".equals(filename)){
					break;
				}
				String newFileName=DateUtil.DateToString(new Date(), "yyyyMMddHHmmssSSS")+(int)(Math.random()*100)+"."+ file.getOriginalFilename().split("\\.")[1];
				InputStream is = file.getInputStream();
				FileOutputStream fos = new FileOutputStream(new File(decFilePath + "/" +newFileName));
				try {
					int bytesRead = 0;
					byte[] buffer = new byte[1024];
					while((bytesRead = is.read(buffer, 0, 1024)) != -1){
						fos.write(buffer, 0, bytesRead);
					}
					if(null != file){}
				} catch (Exception e) {
					throw e;
				} finally {
					is.close();
					fos.flush();
					fos.close();
					Map<String, String> map = new HashMap<String, String>();
					map.put("fileName", file.getName());
					String filePath=decFilePath + "/" + newFileName;
					map.put("filePath", filePath);
					filePathList.add(map);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return filePathList;
	}
	
	/**
	 * 卫生许可文件上传不修改文件名
	 * @param isApp
	 * @param request
	 * @throws Exception
	 * @return Map数组 (key : "formName" - 表单中文件名称, "filePath" - 文件存储路径)
	 */
	public static List<Map<String, String>> appsUpXkloadFile(HttpServletRequest request , boolean isApp)
			throws Exception {
		List<Map<String, String>> filePathList = new ArrayList<Map<String, String>>();
		String decFilePath = Constants.UP_XK_PATH;
		if(!(new File(decFilePath).isDirectory())){
			new File(decFilePath).mkdir();
		}
		MultipartHttpServletRequest mhsreq = (MultipartHttpServletRequest)request;
		List<MultipartFile> l = mhsreq.getFiles(Constants.UPLOAD_PARAM_NAME);
		for(MultipartFile file : l){
			String newFileName=file.getOriginalFilename();
			InputStream is = file.getInputStream();
			FileOutputStream fos = new FileOutputStream(new File(decFilePath + "/" +newFileName));
			try {
				int bytesRead = 0;
				byte[] buffer = new byte[1024];
				while((bytesRead = is.read(buffer, 0, 1024)) != -1){
					fos.write(buffer, 0, bytesRead);
				}
				if(null != file){}
			} catch (Exception e) {
				throw e;
			} finally {
				is.close();
				fos.flush();
				fos.close();
				Map<String, String> map = new HashMap<String, String>();
				map.put("fileName", file.getName());
				String filePath=decFilePath + "/" + newFileName;
				map.put("filePath", filePath);
				filePathList.add(map);
			}
		}
		return filePathList;
	}
	
	/**
     * 判断数据库中二进制文件流的文件类型
     * @param byte[] content
     * @return String 成功返回文件类型，失败返回空字符串
     */
    public static String judgeFileType(byte[] content) {
        String file_type = "";
        InputStream in = null;
        try {
            byte[] b = new byte[4];
            Map<String, String> file_type_map = _getFileTypeMap();
            in = new ByteArrayInputStream(content);
            in.read(b, 0, b.length);
            String value = _bytesToHexString(b);
            file_type = file_type_map.get(value);
        }
        catch(Exception e) {
            logger_.error("###### judgeFileType is error:"+e.getMessage(), e);
        }
        finally {
            try {
                if(in != null) {
                    in.close();
                }
            }
            catch(Exception e) {
                logger_.error("###### judgeFileType close stream is error:"+e.getMessage(), e);
            }
        }
        return file_type;
    }
	
	/**
     * createFileByDB
     * type: 
     * @param FileDTO dto
     * @param HttpServletResponse response
     * reruen String (file_name/false) 成功返回文件名，失败返回false
     */
    public static String createFileByDB(String file_name, byte[] content) {
        String flag = "false";
        
        if(content == null || content.length == 0) {
            return "false";
        }
        
        try {
            File file =new File(Constants.LIMS_FILE_PATH+file_name);//word文档
            if(!file.exists()) {//文件不存在则生成文件
                InputStream iStream = null;
                FileOutputStream outputStream = null;
                try {
                    file.createNewFile();
                    outputStream = new FileOutputStream(file);
                    iStream = new ByteArrayInputStream(content);
                    
                    int size=0;
                    byte[] Buffer = new byte[4096*5];
                    while((size=iStream.read(Buffer))!=-1) {
                        outputStream.write(Buffer,0,size);  
                    }
                    flag = "true";
                }
                catch(Exception e) {
                    flag = "false";
                    logger_.error("###### createFileByDB create file is error:"+e.getMessage(), e);
                }
                finally {
                    try {
                        if(outputStream != null) {
                            outputStream.close();
                        }
                        
                        if(iStream != null) {
                            iStream.close();
                        }
                    }
                    catch(Exception e) {
                        logger_.error("###### createFileByDB file close stream is error:"+e.getMessage(), e);
                    }
                }
            }
            else {
                flag = "true";
            }
        }
        catch(Exception e) {
            flag = "false";
            logger_.error("###### fileToPdf_doc_docx is error:"+e.getMessage(), e);
        }
        
        return flag;
    }
    
	/**
	 * Word to Fdf
	 * type: doc、docx
	 * @param String file_name word文档文件名
	 * reruen String (true/false)
	 */
	public static String wordToPdf(String word_file_name, String pdf_file_name) {
	    String flag = "false";
	    try {
	        //2003Word和2007Word 转成PDF
            File pdf_file = new File(Constants.LIMS_FILE_PATH+pdf_file_name);//新建一个空白pdf文档
            if(!pdf_file.exists()) {//pdf文件不存在则生成
                Document doc = null;
                FileOutputStream os = null;
                try {
                    os = new FileOutputStream(pdf_file);
                    doc = new Document(Constants.LIMS_FILE_PATH+word_file_name);//Address是将要被转化的word文档           
                    doc.save(os, SaveFormat.PDF);//全面支持DOC, DOCX, OOXML, RTF HTML, OpenDocument, PDF, EPUB, XPS, SWF 相互转换            os.close();
                    long fileSize = pdf_file.length();//获取文件大小@LiuChao
                    //判断文件大小,小于1则返回false下载doc/docx文件
                    if(fileSize<1){
                    	flag = "false";
                    }else{
                    	flag = "true";
                    }
                }
                catch(Exception e) {
                    flag = "false";
                    logger_.error("###### fileToPdf_doc_docx word to pdf file is error:"+e.getMessage(), e);
                }
                finally {
                    try {
                        if(os != null) {
                            os.close();
                        }
                        if(doc != null) {
                            doc.clearSectionAttrs();
                        }
                    }
                    catch(Exception e) {
                        logger_.error("###### fileToPdf_doc_docx word to pdf file close stream is error:"+e.getMessage(), e);
                    }
                }
            }
            else {
            	long fileSize = pdf_file.length();
                if(fileSize<1){
                	flag = "false";
                }else{
                	flag = "true";
                }
            }
	    }
	    catch(Exception e) {
	        flag = "false";
	        logger_.error("###### fileToPdf_doc_docx is error:"+e.getMessage(), e);
	    }
	    return flag;
	}
	
	//获取文件头信息
	private static String _bytesToHexString(byte[] src) {  
	    String hv;
	    StringBuilder builder = new StringBuilder();
	    
        if(src == null || src.length <= 0) {  
            return null;  
        }
          
        for(int i = 0; i < src.length; i++) {  
            hv = Integer.toHexString(src[i] & 0xFF).toUpperCase();// 以十六进制（基数 16）无符号整数形式返回一个整数参数的字符串表示形式，并转换为大写  
            if(hv.length() < 2) {
                builder.append(0);
            }  
            builder.append(hv);
        }
        return builder.toString();
    }
	
	//初始化各文件类型的文件头信息
	private static Map<String, String> _getFileTypeMap() {
        HashMap<String, String> mFileTypes = new HashMap<String, String>();
        //本次用到的文件类型，优先初始化
        mFileTypes.put("D0CF11E0", "doc");
        mFileTypes.put("504B0304", "docx");
        //因2003和2007版本的excel文件头信息与word一样且数据库中存储的数据类型并未出现excel，所以excel文件类型被屏蔽掉
//        mFileTypes.put("D0CF11E0", "xls");//excel2003版本文件
//        mFileTypes.put("504B0304", "xlsx");//excel2007以上版本文件
        
        // images  
        mFileTypes.put("424D", "bmp");
        mFileTypes.put("1F8B08", "gz");
        mFileTypes.put("FFD8FF", "jpg");
        mFileTypes.put("2E524D46", "rm");
        mFileTypes.put("52617221", "rar");
        mFileTypes.put("25504446", "pdf");
        mFileTypes.put("89504E47", "png");
        mFileTypes.put("47494638", "gif");
        mFileTypes.put("49492A00", "tif");
        mFileTypes.put("41433130", "dwg");//CAD
        mFileTypes.put("38425053", "psd");
        mFileTypes.put("57415645", "wav");
        mFileTypes.put("41564920", "avi");
        mFileTypes.put("000001BA", "mpg");
        mFileTypes.put("000001B3", "mpg");
        mFileTypes.put("6D6F6F76", "mov");
        mFileTypes.put("4D546864", "mid");
        mFileTypes.put("7B5C727466", "rtf"); // 日记本
        mFileTypes.put("3C3F786D6C", "xml");
        mFileTypes.put("68746D6C3E", "html");
        mFileTypes.put("3026B2758E66CF11", "asf");
        mFileTypes.put("252150532D41646F6265", "ps");
        mFileTypes.put("5374616E64617264204A", "mdb");
        mFileTypes.put("44656C69766572792D646174653A", "eml"); // 邮件
        return mFileTypes;
    }
	
    public static String downFile(String file_name, HttpServletResponse response) {
        String flag = "false";
        
        try {
            File down_file = new File(Constants.LIMS_FILE_PATH+file_name);  //新建一个空白pdf文档
            response.reset();
            response.resetBuffer();
            response.setHeader("Content-Type", "application/octet-stream");
            response.addHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(file_name, "UTF-8") + "\"");
            int fileLength = (int) down_file.length();
            response.setContentLength(fileLength);
            
            //如果文件长度大于0
            if (fileLength != 0) {
                InputStream inStream = null;
                ServletOutputStream servletOS = null;
                try {
                    inStream = new FileInputStream(down_file);
                    servletOS = response.getOutputStream();
                    byte[] buf = new byte[1024];
                    int readLength;
                    while(((readLength = inStream.read(buf)) != -1)) {
                        servletOS.write(buf, 0, readLength);
                    }
                }
                catch(Exception e) {
                    flag = "false";
                    logger_.error("###### fileToPdf_doc_docx down file("+down_file.getName()+") is error:"+e.getMessage(), e);
                }
                finally {
                    try {
                        if(inStream != null) {
                            inStream.close();                            
                        }
                        if(servletOS != null) {
                            servletOS.flush();
                            servletOS.close();
                        }
                    }
                    catch(Exception e) {
                        logger_.error("###### fileToPdf_doc_docx down file("+down_file.getName()+") close stream is error:"+e.getMessage(), e);
                    }
                }
            }
            
            response.setStatus(HttpServletResponse.SC_OK);
            response.flushBuffer();
            flag = "true";
        }
        catch(Exception e) {
            
        }
        return flag;
    }
}