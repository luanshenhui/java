package centling.service.webservice;

//IO Classes
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.io.File;
// Net classes
import java.net.URL;

//Text Classes
import java.text.DateFormat;
import java.text.SimpleDateFormat;

//Parse Packages
import javax.xml.parsers.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;

/**
 * This class contains is a sample client class used to send request XML
 * messages to XML Shipping service of DHL
 * 
 * @author Dhawal Jogi (Infosys)
 **/
public class DHLClient {
	/**
	 * Private method to write the response from the input stream to a file in
	 * local directory.
	 * 
	 * @param strResponse
	 *            The string format of the response XML message
	 **/
	private static String fileWriter(String strResponse,String responseMessagePath) {

		DateFormat today = new SimpleDateFormat("yyyy_MM_dd_hh_mm_ss_SSS");

		String responseFileName = checkForRootElement(strResponse) + "_"
				+ today.format(new java.util.Date());

		String ufn = responseMessagePath + responseFileName;
		File resFile = new File(ufn + ".xml");
		int i = 0;
		try {
			// create file and if it already exits
			// if file exist add counter to it
			while (!resFile.createNewFile()) {
				resFile = new File(ufn + "_" + (++i) + ".xml");
			}
			OutputStream output = new FileOutputStream(resFile);
			PrintStream p = null; // declare a print stream object
			// Connect print stream to the output stream
			p = new PrintStream(output);
			p.println(strResponse);
			p.close();
		} catch (Exception e) {
			System.err.println(e.getMessage());
		}
		return resFile.getName();
	}// end of fileWriter method

	/**
	 * Returns the value of the root element of the response XML message send by
	 * DHL Server
	 * 
	 * @param strResponse
	 *            The string format of the response XML message
	 * @return name of the root element of type string
	 **/
	private static String checkForRootElement(String strResponse) {
		Element element = null;
		try {
			byte[] byteArray = strResponse.getBytes();
			ByteArrayInputStream baip = new ByteArrayInputStream(byteArray);
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder documentBuilder = factory.newDocumentBuilder();
			Document doc = documentBuilder.parse(baip); // Parsing the
														// inputstream
			element = doc.getDocumentElement(); // getting the root element

		} catch (Exception e) {
			System.out.println("Exception in checkForRootElement "
					+ e.getMessage());
		}
		String rootElement = element.getTagName();
		// Check if root element has res: as prefix

		if (rootElement.startsWith("res:") || rootElement.startsWith("req:")
				|| rootElement.startsWith("err:")
				|| rootElement.startsWith("edlres:")
				|| rootElement.startsWith("ilres:")) {

			int index = rootElement.indexOf(":");

			rootElement = rootElement.substring(index + 1);
		}
		return rootElement; // returning the value of the root element
	} // end of checkForRootElement method

	/**
	 * This constructor is used to do the following important operations 
	 * 1) Read a request XML 
	 * 2) Connect to Server 
	 * 3) Send the request XML 
	 * 4) Receive response XML message 
	 * 5) Calls a private method to write the response XML message
	 * 
	 * @param requestMessagePath 
	 * 		The path of the request XML message to be send to server
	 * 
	 * @param httpURL 
	 * 		The http URL to connect to the server (e.g. http://<ipaddress>:<port>/application name/Servlet name)
	 * 
	 * @param responseMessagePath 
	 * 		The path where the response XML message is to be stored
	 */
	public static String getResponseXML(String requestMessagePath, String httpURL,
			String responseMessagePath) {
		String responseFileName = null;
		FileInputStream fis = null;
		try {
			// Preparing file inputstream from a file
			fis = new FileInputStream(requestMessagePath);

			// Getting size of the stream
			int fisSize = fis.available();
			byte[] buffer = new byte[fisSize];

			// Reading file into buffer
			fis.read(buffer);

			String clientRequestXML = new String(buffer);

			/* Preparing the URL and opening connection to the server */
			URL servletURL = null;
			servletURL = new URL(httpURL);

			HttpURLConnection servletConnection = null;
			servletConnection = (HttpURLConnection) servletURL.openConnection();
			servletConnection.setDoOutput(true); // to allow us to write to the
													// URL
			servletConnection.setDoInput(true);
			servletConnection.setUseCaches(false);
			servletConnection.setRequestMethod("POST");

			servletConnection.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			String len = Integer.toString(clientRequestXML.getBytes().length);
			servletConnection.setRequestProperty("Content-Length", len);
			// servletConnection.setRequestProperty("Content-Language",
			// "en-US");

			/* Code for sending data to the server */
			/*
			 * DataOutputStream dataOutputStream; dataOutputStream = new
			 * DataOutputStream(servletConnection.getOutputStream());
			 * 
			 * ByteArrayOutputStream byteOutputStream = new
			 * ByteArrayOutputStream();
			 */
			// servletConnection.setReadTimeout(10000);
			servletConnection.connect();
			OutputStreamWriter wr = new OutputStreamWriter(servletConnection.getOutputStream());
			wr.write(clientRequestXML);
			wr.flush();
			wr.close();

			/*
			 * byte[] dataStream = clientRequestXML.getBytes();
			 * dataOutputStream.write(dataStream); //Writing data to the servlet
			 * dataOutputStream.flush(); dataOutputStream.close();
			 */

			/* Code for getting and processing response from DHL's servlet */
			InputStream inputStream = null;
			inputStream = servletConnection.getInputStream();
			StringBuffer response = new StringBuffer();
			int printResponse;

			// Reading the response into StringBuffer
			while ((printResponse = inputStream.read()) != -1) {
				response.append((char) printResponse);
			}
			inputStream.close();
			
			// Calling filewriter to write the response to a file
			responseFileName = fileWriter(response.toString(), responseMessagePath);
		} catch (MalformedURLException mfURLex) {
			System.out.println("MalformedURLException " + mfURLex.getMessage());
		} catch (IOException e) {
			System.out.println("IOException " + e.getMessage());
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException e) {
					System.out.println("IOException " + e.getMessage());
				}
			}
		}
		
		return responseFileName;
	}
}// End of Class DHLClient
