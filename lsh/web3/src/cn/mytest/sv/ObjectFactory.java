
package cn.mytest.sv;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the cn.mytest.sv package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _ServiceResult_QNAME = new QName("http://cn.service.com/", "serviceResult");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: cn.mytest.sv
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link ServiceResult }
     * 
     */
    public ServiceResult createServiceResult() {
        return new ServiceResult();
    }

    /**
     * Create an instance of {@link VslDecIo }
     * 
     */
    public VslDecIo createVslDecIo() {
        return new VslDecIo();
    }

    /**
     * Create an instance of {@link VslUpdateDecIo }
     * 
     */
    public VslUpdateDecIo createVslUpdateDecIo() {
        return new VslUpdateDecIo();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ServiceResult }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://cn.service.com/", name = "serviceResult")
    public JAXBElement<ServiceResult> createServiceResult(ServiceResult value) {
        return new JAXBElement<ServiceResult>(_ServiceResult_QNAME, ServiceResult.class, null, value);
    }

}
