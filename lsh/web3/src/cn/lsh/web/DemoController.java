package cn.lsh.web;


import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.TextMessage;
import javax.management.MBeanServerConnection;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value = "/receive")
public class DemoController {


    //队列名gzframe.demo
    @Resource(name="demoQueueDestination")
    private Destination demoQueueDestination;

    
  //队列消息消费者
    @Resource(name="consumerService")
    private ConsumerService consumer;
    
    @RequestMapping(value="/producer",method=RequestMethod.GET)
    public ModelAndView producer(){
        System.out.println("------------go producer");
        
        Date now = new Date(); 
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String time = dateFormat.format( now ); 
        System.out.println(time);
        
        ModelAndView mv = new ModelAndView();
        mv.addObject("time", time);
        mv.setViewName("jms_producer");        
        return mv;
    }
    
    //http://localhost:8081/web3/receive/receive
    @RequestMapping(value="/receive",method=RequestMethod.GET)
    public ModelAndView queue_receive() throws JMSException {
        System.out.println("------------receive message");
        ModelAndView mv = new ModelAndView();
        
        TextMessage tm = consumer.receive(demoQueueDestination);
        mv.addObject("textMessage", tm.getText());
        
        mv.setViewName("queue_receive");
        return mv;
    }
    
    /*
     * ActiveMQ Manager Test
     */
    @RequestMapping(value="/jms",method=RequestMethod.GET)
    public ModelAndView jmsManager() throws IOException {
        System.out.println("------------jms manager");
        ModelAndView mv = new ModelAndView();
        mv.setViewName("welcome");
        
        JMXServiceURL url = new JMXServiceURL("");
        JMXConnector connector = JMXConnectorFactory.connect(url);
        connector.connect();
        MBeanServerConnection connection = connector.getMBeanServerConnection();
        
        return mv;
    }
    
    
    

}
