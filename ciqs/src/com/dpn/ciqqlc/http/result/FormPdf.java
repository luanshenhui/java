package com.dpn.ciqqlc.http.result;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.ElectronicSealUtil;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;

public abstract class FormPdf<T> {
	/**
	 * pdf展示
	 * @param request
	 * @param response
	 * @param t
	 * @param templatePDF
	 * @param actionType
	 * @param isdownload 
	 */
	protected  void toPrintPlanNote(HttpServletRequest request,
			HttpServletResponse response, T t, String templatePDF, String actionType, boolean isdownload){
        response.setContentType("application/pdf");
        if(isdownload){
        	response.setHeader("Content-disposition","attachment; filename=" +"D:\\"+new Date()+actionType+".pdf" );
        }
        OutputStream os = null;
        PdfStamper ps = null;
        PdfReader reader = null;
        try {
			os = response.getOutputStream();
			// 2 读入pdf表单
			reader = new PdfReader(templatePDF);
			// 3 根据表单生成一个新的pdf
			ps = new PdfStamper(reader, os);
			// 4 获取pdf表单
			AcroFields form = ps.getAcroFields();
			// 5给表单添加中文字体 这里采用系统字体。不设置的话，中文可能无法显示
			BaseFont bf = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
			form.addSubstitutionFont(bf);
			formSet(request,ps,form,t,actionType);
			ps.setFormFlattening(true);
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		} finally {
			try {
				if(ps!=null){
					ps.close();
				}
				if(reader!=null){
					reader.close();
				}
				if(os!=null){
					os.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	

	}
	

	/**
	 * PDF盖章
	 * @param request
	 * @param response
	 * @param t
	 * @param templatePDF
	 * @param actionType
	 * @param isdownload
	 */
	protected  String printPlanNoteGz(HttpServletRequest request,
			HttpServletResponse response, T t, String templatePDF, String actionType){
        response.setContentType("application/pdf");
        OutputStream os = null;
        PdfStamper ps = null;
        PdfReader reader = null;
        String fileName = Constants.GAI_ZHANG+DateUtil.getYYYYMMddHHmmssSSS()+".pdf";
        try {
        	os = response.getOutputStream();
			// 2 读入pdf表单
			reader = new PdfReader(templatePDF);
			// 3 根据表单生成一个新的pdf
			ps = new PdfStamper(reader, new FileOutputStream(fileName));
			// 4 获取pdf表单
			AcroFields form = ps.getAcroFields();
			// 5给表单添加中文字体 这里采用系统字体。不设置的话，中文可能无法显示
			BaseFont bf = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
			form.addSubstitutionFont(bf);
			formSet(request,ps,form,t,actionType);
			ps.setFormFlattening(true);
			ps.close();
			reader.close();
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(ps!=null){
					ps.close();
				}
				if(reader!=null){
					reader.close();
				}
				if(os!=null){
					os.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	
        return fileName;
	}
	
	/**
	 * pdf 赋值方法
	 * @param request 
	 * @param ps 
	 * @param acroform
	 * @param t
	 * @param actionType pdf证书类型
	 * @return
	 */
	protected abstract void formSet(HttpServletRequest request, PdfStamper ps, AcroFields acroform,T t, String actionType);
	
	
	protected String toPrintFile(HttpServletRequest request,
			HttpServletResponse response, T t, String templatePDF,String actionType) {
		FileOutputStream fos=null;
		PdfReader reader =null;
		String id=request.getParameter("id");
		String fileName = Constants.GAI_ZHANG+DateUtil.getYYYYMMddHHmmssSSS()+".pdf";
		try {
			reader = new PdfReader(templatePDF);
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			PdfStamper ps = new PdfStamper(reader, bos);
			AcroFields form = ps.getAcroFields();
			BaseFont bf = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
			form.addSubstitutionFont(bf);
			formSet(request,ps,form,t,actionType);
			ps.setFormFlattening(true);
			ps.close();
			fos = new FileOutputStream(fileName);
			fos.write(bos.toByteArray());
			
			return fileName;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		}finally{
			try {
				if(fos!=null){
					fos.close();
				}
				if(reader!=null){
					reader.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return fileName;
	}
	
	
	protected void newDownLoad(String filePath, HttpServletResponse response) throws Exception {
	        File f = new File(filePath);
	        if (!f.exists()) {
	            response.sendError(404, "File not found!");
	            return;
	        }
	        int size=(int) f.length();
	        BufferedInputStream br = new BufferedInputStream(new FileInputStream(f));
	        byte[] buf = new byte[1024];
	        int len = 0;
	        response.reset(); 
	        response.setContentType("application/x-msdownload");
	        response.setContentLength(size);
//	        response.setCharacterEncoding("GB2312");
	        String fileName = new String(f.getName().getBytes(), "ISO-8859-1"); 
	        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
	        OutputStream out = response.getOutputStream();
	        while ((len = br.read(buf)) > 0)
	            out.write(buf, 0, len);
	        br.close();
	        out.close();
	        
	        f.delete();
	        String s=f.toString();
	        s=s.replaceAll("\\\\", "/");
	        int iu=s.lastIndexOf("/");
	        s=s.substring(0,iu);
	        if (!new File(s).isDirectory()) {
	        	return;
	        }
	        File ff = new File(s);
	        File fa[] = ff.listFiles();
	        if(fa.length<1){
	        	new File(s).delete();
	        	int u=s.lastIndexOf("/");
	        	s=s.substring(0,u);
	        	if (!new File(s).isDirectory()) {
		        	return;
		        }
	        	File f2 = new File(s);
	  	        File fa2[] = f2.listFiles();
	  	        if(fa2.length<1){
	  	        	new File(s).delete();
	  	        }
	        }
	    }
	

	protected void noDeleteDownLoad(String filePath, HttpServletResponse response) throws Exception {
        File f = new File(filePath);
        if (!f.exists()) {
            response.sendError(404, "File not found!");
            return;
        }
        int size=(int) f.length();
        BufferedInputStream br = new BufferedInputStream(new FileInputStream(f));
        byte[] buf = new byte[1024];
        int len = 0;
        response.reset(); 
        response.setContentType("application/x-msdownload");
        response.setContentLength(size);
        String fileName = new String(f.getName().getBytes(), "ISO-8859-1"); 
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
        OutputStream out = response.getOutputStream();
        while ((len = br.read(buf)) > 0)
            out.write(buf, 0, len);
        br.close();
        out.close();
    }
}
