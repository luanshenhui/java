package com.hepowdhc.dcapp.utils;

import java.util.UUID;

/**
 * Created by fzxs on 16-12-15.
 */
public final class GenUUID {

    public static String uuid() {

        return UUID.randomUUID().toString().replaceAll("-", "");
    }

}
