package com.hepowdhc.dcapp.engine;

import com.hepowdhc.dcapp.config.EngineConf;
import com.hepowdhc.dcapp.exception.SocketNotActiveException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.util.Arrays;
import java.util.Properties;
import java.util.function.Consumer;

/**
 * Created by fzxs on 17-1-11.
 */

public class AnalysisObject {

    private InetAddress address;

    private DataOutputStream out;

    private DataInputStream in;

    private Socket socket;

    private Logger logger = LoggerFactory.getLogger(getClass());

    public AnalysisObject(EngineConf conf) {

        try {

//            Properties prop = config.engineConfig();

//            Properties

            address = InetAddress.getByName(conf.getSocketHost());

            socket = new Socket(address, conf.getSocketPort());

            out = new DataOutputStream(socket.getOutputStream());

            in = new DataInputStream(socket.getInputStream());

        } catch (Exception e) {
            logger.error("Socket", e.fillInStackTrace());
            throw new SocketNotActiveException();
        }


    }

    public void start() {

        try {

            out.writeUTF("start");

            if (!StringUtils.equalsIgnoreCase("ok", in.readUTF())) {
                throw new SocketNotActiveException();
            }

        } catch (IOException e) {
            logger.error("行为启动失败", e.fillInStackTrace());
            throw new SocketNotActiveException();
        }

    }

    public void exec(Consumer<String> consumer, String... rules) {

        Arrays.stream(rules).forEach(rule -> {

            try {

                out.writeUTF(rule);
                out.flush();
                consumer.accept(in.readUTF());

            } catch (IOException e) {
                logger.error("行为执行失败", e.fillInStackTrace());
                e.printStackTrace();

            }

        });


    }

    public void stop() {

        try {
            out.writeUTF("stop");
            out.flush();
            out.close();
            in.close();
            socket.close();
        } catch (IOException e) {
            logger.error("Socket断开失败:", e.fillInStackTrace());
        }


    }

}
