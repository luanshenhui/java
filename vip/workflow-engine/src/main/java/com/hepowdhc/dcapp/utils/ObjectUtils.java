package com.hepowdhc.dcapp.utils;

import java.io.*;

/**
 * Created by fzxs on 16-12-27.
 */
public final class ObjectUtils extends org.apache.commons.lang3.ObjectUtils {

    public static <T> T deepClone(T target) {

        if (target instanceof Serializable) {
            try {
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

                ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);

                objectOutputStream.writeObject(target);

                ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(byteArrayOutputStream.toByteArray());

                ObjectInputStream objectInputStream = new ObjectInputStream(byteArrayInputStream);

                return (T) objectInputStream.readObject();

            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        return null;
    }


}
