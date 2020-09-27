package cn.com.cgbchina.common.utils;

import com.google.common.base.Throwables;
import com.google.common.io.ByteStreams;

import lombok.extern.slf4j.Slf4j;
import net.sf.jxls.transformer.XLSTransformer;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Map;

/**
 * fileName参数为输出给前台下载的时候 下载的文件名 filePath为要下载的模板文件的绝对路径
 *
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/24.
 */
@Slf4j
public class ExportUtils {

    private static String DOWNLOAD_URL;

    public void setDownloadUrl(String downloadUrl) {
        DOWNLOAD_URL = downloadUrl;
    }

    /**
     * 处理所有检查型异常版本 如果出现检找到查型异常 文件未找到等等 会吸收掉掉异常 页面不报错
     *
     * @param response
     * @param fileName
     * @param filePath
     * @param contextMap
     */
    public static void exportTemplate(HttpServletResponse response, String fileName, String filePath,
                                      Map<String, Object> contextMap) {
        InputStream inputStream = null;
        OutputStream outputStream = null;
        try {
            response.reset();
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition",
                    "attachment;filename=" + new String(fileName.getBytes("UTF-8"), "iso8859-1") + ";target=_blank");
            inputStream = new FileInputStream(filePath);
            outputStream = response.getOutputStream();
            XLSTransformer transformer = new XLSTransformer();
            Workbook workbook = transformer.transformXLS(inputStream, contextMap);
            // merge单元格
            if (contextMap.containsKey("mergeSize")) {
                int size = (int) contextMap.get("mergeSize");
                Sheet sheet = workbook.getSheetAt(0);
                for (int i = 0; i < 12; i++) {
                    CellRangeAddress mergeAddress = new CellRangeAddress(3, size + 2, i, i);

                    sheet.addMergedRegion(mergeAddress);
                }
            }
            workbook.write(outputStream);
            outputStream.flush();
            outputStream.close();
        } catch (UnsupportedEncodingException e) {
            log.error("export excel template", e);
            e.printStackTrace();
        } catch (FileNotFoundException e) {
            log.error("export excel template", e);
            e.printStackTrace();
        } catch (IOException e) {
            log.error("export excel template", e);
            e.printStackTrace();
        } catch (InvalidFormatException e) {
            log.error("export excel template", e);
            e.printStackTrace();
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                log.error("fail to close inputstream , error:{}", Throwables.getStackTraceAsString(e));
            }
        }
    }

    public static void copyRegions(HSSFSheet sheet, int startRow, int endRow, int startColumn, int endColumn) {
        CellRangeAddress region = new CellRangeAddress(startRow, endRow, startColumn, endColumn);
        sheet.addMergedRegion(region);
    }

    /**
     * @param workbook
     * @param contextMap
     */
    public static void exportTemplate(Workbook workbook, Map<String, Object> contextMap) {
        XLSTransformer transformer = new XLSTransformer();
        transformer.transformWorkbook(workbook, contextMap);
    }

    public static void downloadReport(String fileUrl, HttpServletResponse response, HttpServletRequest request) {
        BufferedOutputStream os = null;
        try {
            String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);// 文件名称
            URL url = new URL(DOWNLOAD_URL + fileUrl);
            URLConnection conn = url.openConnection();

            int fileSize = conn.getContentLength(); // 取数据长度
            String userAgent = request.getHeader("User-Agent");
            String rtn = "";
            String new_filename = URLEncoder.encode(fileName, "UTF-8");
            // 如果没有UA，则默认使用IE的方式进行编码
            rtn = "filename=\"" + new_filename + "\"";
            if (userAgent != null) {
                userAgent = userAgent.toLowerCase();
                // IE浏览器，只能采用URLEncoder编码
                if (userAgent.contains("msie")) {
                    rtn = "filename=\"" + new_filename + "\"";
                }
                // Opera浏览器只能采用filename*
                else if (userAgent.contains("opera")) {
                    rtn = "filename*=UTF-8''" + new_filename;
                }
                // Safari浏览器，只能采用ISO编码的中文输出
                else if (userAgent.contains("safari")) {
                    rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
                }
                // Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
                else if (userAgent.contains("applewebkit")) {
                    rtn = "filename=\"" + new_filename + "\"";
                }
                // ie11
                else if (userAgent.contains("mozilla") && !userAgent.contains("firefox")) {
                    rtn = "filename=\"" + new_filename + "\"";
                    // 火狐
                } else if (userAgent.contains("firefox") && userAgent.contains("mozilla")) {
                    rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
                }
            }
            // 清空response
            response.reset();
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Disposition",
                    "attachment;" + rtn + ";target=_blank");
            response.addHeader("Content-Length", "" + fileSize);

            os = new BufferedOutputStream(response.getOutputStream());
            // 从输入流中读入字节流，然后写到文件中
            ByteStreams.copy(conn.getInputStream(), os);
            os.flush();
            os.close();
        } catch (Exception e) {
            log.error("download report erro:{}", Throwables.getStackTraceAsString(e));
        } finally {
            if (os != null) {
                try {
                    os.close();
                } catch (IOException e) {
                    log.error("download report erro:{}", Throwables.getStackTraceAsString(e));
                }
            }
        }
    }
}
