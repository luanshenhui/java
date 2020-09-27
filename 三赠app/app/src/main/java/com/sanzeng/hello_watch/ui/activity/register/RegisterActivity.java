package com.sanzeng.hello_watch.ui.activity.register;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Environment;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.iflytek.cloud.ErrorCode;
import com.iflytek.cloud.InitListener;
import com.iflytek.cloud.SpeakerVerifier;
import com.iflytek.cloud.SpeechConstant;
import com.iflytek.cloud.SpeechError;
import com.iflytek.cloud.SpeechListener;
import com.iflytek.cloud.VerifierListener;
import com.iflytek.cloud.VerifierResult;
import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.ui.activity.MainActivity;
import com.sanzeng.hello_watch.ui.activity.login.JoinFamilyActivity;
import com.sanzeng.hello_watch.ui.activity.login.SureRoleActivity;
import com.sanzeng.hello_watch.utils.NetworkUtil;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ViewUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Calendar;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import pub.devrel.easypermissions.EasyPermissions;

public class RegisterActivity extends Activity implements EasyPermissions.PermissionCallbacks {

    @BindView(R.id.showPwd)
    TextView showPwd;

    @BindView(R.id.showMsg)
    TextView showMsg;

    @BindView(R.id.showRegFbk)
    TextView showRegFbk;

    @BindView(R.id.watch_code)
    TextView watch_code;

    @BindView(R.id.register_tv)
    TextView register_tv;

    // 声纹识别对象
    private SpeakerVerifier mVerifier;

    private static final int PWD_TYPE_TEXT = 1;
    private static final int PWD_TYPE_FREE = 2;
    private static final int PWD_TYPE_NUM = 3;

    // 当前声纹密码类型，1、2、3分别为文本、自由说和数字密码
    private int mPwdType = PWD_TYPE_TEXT;

    // 文本声纹密码
    private String mTextPwd = "";

    // 请使用英文字母或者字母和数字的组合，勿使用中文字符
    private String mAuthId;

    //判断是否注册过
    private boolean flag_voice;

    // 定位client
    private LocationClient client;
    // 请求权限code
    private final static int REQUEST_CODE_LOCATION = 100;

    //    设备类型 1:手环  2：手机
    private int deviceType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        ButterKnife.bind(this);

        if (NetworkUtil.isNetworkPass(this))
            initView();
        else ViewUtils.showToast(this, getString(R.string.net_error));

    }

    private void initView() {
        // 定位动作
        locateAction();

        flag_voice = PfsUtils.readBoolean(ProjectPfs.PFS_SYS, AppConst.VOICE_IS_SUC);
        // 初始化SpeakerVerifier，InitListener为初始化完成后的回调接口
        mVerifier = SpeakerVerifier.createVerifier(RegisterActivity.this, new InitListener() {

            @Override
            public void onInit(int errorCode) {
                if (ErrorCode.SUCCESS == errorCode) {
                    ViewUtils.showToast(RegisterActivity.this, "引擎初始化成功");
                } else {
                    ViewUtils.showToast(RegisterActivity.this, "引擎初始化失败，错误码：" + errorCode);
                }
            }
        });

        if (!checkInstance()) {
            return;
        }

        if (!flag_voice) {
            Calendar calendar = Calendar.getInstance();
            mAuthId = "SZ" + calendar.getTimeInMillis();

            //缓存==用户id供其它页面调用
            PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID, mAuthId);
        }
        deviceType = PfsUtils.readInteger(ProjectPfs.PFS_SYS, AppConst.DEVICE_TYPE);
        if (deviceType == 1) {
            String mAuthId = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID);
            watch_code.setText("您的手环码为:" + mAuthId);
        } else {
            watch_code.setVisibility(View.GONE);
        }

        //获取密码之前先终止之前的注册或验证过程4
        getPassword();
    }

    /**
     * 判断定位权限和网络连接
     */
    private void locateAction() {
        /* 如果网络断开 不需要定位 直接显示定位失败 */
        if (!NetworkUtil.isNetworkPass(this)) {
            ViewUtils.showToast(this, getString(R.string.net_error));
            return;
        }

        /* 判断定位权限 若权限为询问状态去申请
        若权限关闭 则提示用户 并且显示定位失败 */
        if (!checkLocationPms()) {
            String[] perms = {Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION};
            EasyPermissions.requestPermissions(this
                    , getString(R.string.lbs_address_fail), REQUEST_CODE_LOCATION, perms);
            ViewUtils.showToast(this, getString(R.string.lbs_address_fail));
            return;
        }

        startLocate(); // 进行定位
    }

    /**
     * 初始化百度定位client并且开始定位
     */
    private synchronized void startLocate() {
        LocateListener listener = new LocateListener();
        client = new LocationClient(getApplicationContext());
        client.registerLocationListener(listener);

        /* 设置定位参数 这里只需要显示城市 */
        LocationClientOption option = new LocationClientOption();
        option.setIsNeedAddress(true);// 可选，设置是否需要地址信息，默认不需要
        client.setLocOption(option);
        client.start();
    }

    /**
     * 定位获取位置信息监听
     * 定位成功显示当前城市
     * 定位失败显示定位失败
     */
    private class LocateListener implements BDLocationListener {
        @Override
        public void onReceiveLocation(final BDLocation bdLocation) {
            if (bdLocation.getCity() != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        String province = bdLocation.getProvince();
                        if (province != null && !province.equals("")) {
                            String provinceSub = province.substring(0, 2);
                            PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.CURRENT_LOCATION, provinceSub);
                            //                        ViewUtils.showToast(RegisterActivity.this, "当前位置:" + cityCode);
                        }
                    }
                });
            }
        }

        @Override
        public void onConnectHotSpotMessage(String s, int i) {

        }
    }

    /**
     * 判断定位权限是否开启
     *
     * @return true 开启了定位权限
     * false 未开启定位权限
     */
    private boolean checkLocationPms() {
        return EasyPermissions.hasPermissions(this
                , Manifest.permission.ACCESS_COARSE_LOCATION
                , Manifest.permission.ACCESS_FINE_LOCATION
                , Manifest.permission.ACCESS_WIFI_STATE
                , Manifest.permission.CHANGE_WIFI_STATE
        );
    }


    private void getPassword() {
        mVerifier.cancel();
        // 清空参数
        mVerifier.setParameter(SpeechConstant.PARAMS, null);
        mVerifier.setParameter(SpeechConstant.ISV_PWDT, "" + mPwdType);
        if (mPwdType != PWD_TYPE_FREE)
            mVerifier.getPasswordList(mPwdListenter);
    }

    private String[] items;
    private SpeechListener mPwdListenter = new SpeechListener() {
        @Override
        public void onEvent(int eventType, Bundle params) {
        }

        @Override
        public void onBufferReceived(byte[] buffer) {

            String result = new String(buffer);
            switch (mPwdType) {
                case 1:
                    try {
                        JSONObject object = new JSONObject(result);
                        if (!object.has("txt_pwd")) {
                            return;
                        }

                        JSONArray pwdArray = object.optJSONArray("txt_pwd");
                        items = new String[pwdArray.length()];
                        for (int i = 0; i < pwdArray.length(); i++) {
                            items[i] = pwdArray.getString(i);
                        }
                        mTextPwd = items[0];
                        register_tv.setText(mTextPwd);

                        if (flag_voice) {
                            mAuthId = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID);
                            mTextPwd = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.TEXT_PSW);
                            //验证登陆
                            verify();
                        } else {
                            //注册密码
                            startRegister();
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    break;

                default:
                    break;
            }

        }

        @Override
        public void onCompleted(SpeechError error) {

            if (null != error && ErrorCode.SUCCESS != error.getErrorCode()) {
                ViewUtils.showToast(RegisterActivity.this, "获取失败：" + error.getErrorCode());
            }
        }
    };

    /**
     * 验证声纹密码
     */
    private void verify() {
        // 清空提示信息
        ((TextView) findViewById(R.id.showMsg)).setText("");
        // 清空参数
        mVerifier.setParameter(SpeechConstant.PARAMS, null);
        mVerifier.setParameter(SpeechConstant.ISV_AUDIO_PATH,
                Environment.getExternalStorageDirectory().getAbsolutePath() + "/msc/verify.pcm");
        mVerifier = SpeakerVerifier.getVerifier();
        // 设置业务类型为验证
        mVerifier.setParameter(SpeechConstant.ISV_SST, "verify");
        // 对于某些麦克风非常灵敏的机器，如nexus、samsung i9300等，建议加上以下设置对录音进行消噪处理
//			mVerify.setParameter(SpeechConstant.AUDIO_SOURCE, "" + MediaRecorder.AudioSource.VOICE_RECOGNITION);

        if (mPwdType == PWD_TYPE_TEXT) {
            // 文本密码注册需要传入密码
            if (TextUtils.isEmpty(mTextPwd)) {
                ViewUtils.showToast(RegisterActivity.this, "请获取密码后进行操作");
                return;
            }
            mVerifier.setParameter(SpeechConstant.ISV_PWD, mTextPwd);
            ((TextView) findViewById(R.id.showPwd)).setText("请读出：" + mTextPwd);
        } else if (mPwdType == PWD_TYPE_FREE) {
            mVerifier.setParameter(SpeechConstant.SAMPLE_RATE, "8000");
            ((TextView) findViewById(R.id.showPwd)).setText("请随便说些用于验证");
        }

        // 设置auth_id，不能设置为空
        mVerifier.setParameter(SpeechConstant.AUTH_ID, mAuthId);
        mVerifier.setParameter(SpeechConstant.ISV_PWDT, "" + mPwdType);
        // 开始验证
        mVerifier.startListening(mVerifyListener);
    }

    private VerifierListener mVerifyListener = new VerifierListener() {

        @Override
        public void onVolumeChanged(int volume, byte[] data) {
//            ViewUtils.showToast(LoginActivity.this, "当前正在说话，音量大小：" + volume);
            Log.d("voice", "返回音频数据：" + data.length);
        }

        @Override
        public void onResult(VerifierResult result) {
            showMsg.setText(result.source);

            if (result.ret == 0) {
                // 验证通过
                showMsg.setText("验证通过");

                judgeDevice();

            } else {
                // 验证不通过
                switch (result.err) {
                    case VerifierResult.MSS_ERROR_IVP_GENERAL:
                        showMsg.setText("内核异常");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_TRUNCATED:
                        showMsg.setText("出现截幅");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_MUCH_NOISE:
                        showMsg.setText("太多噪音");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_UTTER_TOO_SHORT:
                        showMsg.setText("录音太短");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_TEXT_NOT_MATCH:
                        showMsg.setText("验证不通过，您所读的文本不一致");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_TOO_LOW:
                        showMsg.setText("音量太低");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_NO_ENOUGH_AUDIO:
                        showMsg.setText("音频长达不到自由说的要求");
                        break;
                    default:
                        showMsg.setText("验证不通过");
                        break;
                }
                // 开始验证
                mVerifier.startListening(mVerifyListener);
            }
        }

        // 保留方法，暂不用
        @Override
        public void onEvent(int eventType, int arg1, int arg2, Bundle arg3) {
            // 以下代码用于获取与云端的会话id，当业务出错时将会话id提供给技术支持人员，可用于查询会话日志，定位出错原因
            //	if (SpeechEvent.EVENT_SESSION_ID == eventType) {
            //		String sid = obj.getString(SpeechEvent.KEY_EVENT_SESSION_ID);
            //		Log.d(TAG, "session id =" + sid);
            //	}
        }

        @Override
        public void onError(SpeechError error) {

            switch (error.getErrorCode()) {
                case ErrorCode.MSP_ERROR_NOT_FOUND:
                    showMsg.setText("模型不存在，请先注册");
                    break;

                default:
//                    ViewUtils.showToast(RegisterActivity.this, "onError Code：" + error.getPlainDescription(true));
                    // 开始验证
                    mVerifier.startListening(mVerifyListener);
                    break;
            }
        }

        @Override
        public void onEndOfSpeech() {
            // 此回调表示：检测到了语音的尾端点，已经进入识别过程，不再接受语音输入
//            ViewUtils.showToast(RegisterActivity.this, "结束说话");
        }

        @Override
        public void onBeginOfSpeech() {
            // 此回调表示：sdk内部录音机已经准备好了，用户可以开始语音输入
            ViewUtils.showToast(RegisterActivity.this, "开始说话");
        }
    };

    /**
     * 注册声纹密码
     */
    private void startRegister() {
        // 清空参数
        mVerifier.setParameter(SpeechConstant.PARAMS, null);
        mVerifier.setParameter(SpeechConstant.ISV_AUDIO_PATH,
                Environment.getExternalStorageDirectory().getAbsolutePath() + "/msc/test.pcm");
        // 对于某些麦克风非常灵敏的机器，如nexus、samsung i9300等，建议加上以下设置对录音进行消噪处理
//			mVerify.setParameter(SpeechConstant.AUDIO_SOURCE, "" + MediaRecorder.AudioSource.VOICE_RECOGNITION);
        if (mPwdType == PWD_TYPE_TEXT) {
            // 文本密码注册需要传入密码
            if (TextUtils.isEmpty(mTextPwd)) {
                ViewUtils.showToast(RegisterActivity.this, "请获取密码后进行操作");
                return;
            }
            mVerifier.setParameter(SpeechConstant.ISV_PWD, mTextPwd);
            showPwd.setText("请读出：" + mTextPwd);
            showMsg.setText("注册 第" + 1 + "遍，剩余4遍");
        } else if (mPwdType == PWD_TYPE_FREE) {
//            这里插一句嘴，自由说的注册参数之次数 设置为“1” 音质的的设置“8000”
            mVerifier.setParameter(SpeechConstant.ISV_RGN, "1");
            mVerifier.setParameter(SpeechConstant.SAMPLE_RATE, "8000");

        }

        // 设置auth_id，不能设置为空
        mVerifier.setParameter(SpeechConstant.AUTH_ID, mAuthId);
        // 设置业务类型为注册
        mVerifier.setParameter(SpeechConstant.ISV_SST, "train");
        // 设置声纹密码类型
        mVerifier.setParameter(SpeechConstant.ISV_PWDT, "" + mPwdType);
        // 开始注册
        mVerifier.startListening(mRegisterListener);
    }

    private VerifierListener mRegisterListener = new VerifierListener() {

        @Override
        public void onVolumeChanged(int volume, byte[] data) {
//            ViewUtils.showToast(LoginActivity.this, "当前正在说话，音量大小：" + volume);
            Log.d("voice", "返回音频数据：" + data.length);
        }

        @Override
        public void onResult(VerifierResult result) {
            ((TextView) findViewById(R.id.showMsg)).setText(result.source);

            if (result.ret == ErrorCode.SUCCESS) {
                switch (result.err) {
                    case VerifierResult.MSS_ERROR_IVP_GENERAL:
                        showMsg.setText("内核异常");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_EXTRA_RGN_SOPPORT:
                        showRegFbk.setText("训练达到最大次数");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_TRUNCATED:
                        showRegFbk.setText("出现截幅");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_MUCH_NOISE:
                        showRegFbk.setText("太多噪音");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_UTTER_TOO_SHORT:
                        showRegFbk.setText("录音太短");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_TEXT_NOT_MATCH:
                        showRegFbk.setText("训练失败，您所读的文本不一致");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_TOO_LOW:
                        showRegFbk.setText("音量太低");
                        break;
                    case VerifierResult.MSS_ERROR_IVP_NO_ENOUGH_AUDIO:
                        showMsg.setText("音频长达不到自由说的要求");
                    default:
                        showRegFbk.setText("");
                        break;
                }

                if (result.suc == result.rgn) {
                    showMsg.setText("注册成功");
                    PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.VOICE_IS_SUC, true);
                    PfsUtils.savePfs(ProjectPfs.PFS_SYS, AppConst.TEXT_PSW, mTextPwd);
                    verify();
//                    if (PWD_TYPE_TEXT == mPwdType) {
//                        register_et.setText("您的文本密码声纹ID：\n" + result.vid);
//                    }
                } else {
                    int nowTimes = result.suc + 1;
                    int leftTimes = result.rgn - nowTimes;

                    if (PWD_TYPE_TEXT == mPwdType) {
                        showPwd.setText("请读出：" + mTextPwd);
                    }
                    showMsg.setText("注册 第" + nowTimes + "遍，剩余" + leftTimes + "遍");
                }
            } else {
                showMsg.setText("注册失败，请重新开始。");
                // 开始注册
                mVerifier.startListening(mRegisterListener);
            }
        }

        // 保留方法，暂不用
        @Override
        public void onEvent(int eventType, int arg1, int arg2, Bundle arg3) {
            // 以下代码用于获取与云端的会话id，当业务出错时将会话id提供给技术支持人员，可用于查询会话日志，定位出错原因
            //	if (SpeechEvent.EVENT_SESSION_ID == eventType) {
            //		String sid = obj.getString(SpeechEvent.KEY_EVENT_SESSION_ID);
            //		Log.d(TAG, "session id =" + sid);
            //	}
        }

        @Override
        public void onError(SpeechError error) {
            if (error.getErrorCode() == ErrorCode.MSP_ERROR_ALREADY_EXIST) {
                ViewUtils.showToast(RegisterActivity.this, "模型已存在，如需重新注册，请先删除");
            } else {
//                ViewUtils.showToast(RegisterActivity.this, "错误：" + error.getPlainDescription(true));
                // 开始注册
                mVerifier.startListening(mRegisterListener);
            }
        }

        @Override
        public void onEndOfSpeech() {
//            ViewUtils.showToast(RegisterActivity.this, "结束说话");
        }

        @Override
        public void onBeginOfSpeech() {
            ViewUtils.showToast(RegisterActivity.this, "开始说话");
        }
    };

    /**
     * 判断设备跳转到不同的页面
     */
    private void judgeDevice() {

        boolean isBir = PfsUtils.readBoolean(ProjectPfs.PFS_SYS, AppConst.BIRTHDAY);
        if (deviceType == 1) {
            if (!isBir) {
                startActivity(new Intent(RegisterActivity.this, MainActivity.class));
                finish();
            } else {
                startActivity(new Intent(RegisterActivity.this, InputDateActivity.class));
                finish();
            }
        } else {
            //是否输入手环码
            String strWatchCode = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE);
            //是否选择角色
            boolean flag_peo = PfsUtils.readBoolean(ProjectPfs.PFS_SYS, AppConst.CHOICE_PEOPLE);
            if (strWatchCode != null && !strWatchCode.equals("")) {
                if (flag_peo) {
                    startActivity(new Intent(RegisterActivity.this, MainActivity.class));
                    finish();
                } else {
                    startActivity(new Intent(RegisterActivity.this, SureRoleActivity.class));
                    finish();
                }
            } else {
                startActivity(new Intent(RegisterActivity.this, JoinFamilyActivity.class));
                finish();
            }
        }
    }

    /**
     * 取消注册广播
     */
    @Override
    protected void onDestroy() {

        if (null != mVerifier) {
            mVerifier.stopListening();
            mVerifier.destroy();
        }
        super.onDestroy();
    }

    private boolean checkInstance() {
        if (null == mVerifier) {
            // 创建单例失败，与 21001 错误为同样原因，参考 http://bbs.xfyun.cn/forum.php?mod=viewthread&tid=9688
//            ，请确认 libmsc.so 放置正确，且有调用 createUtility 进行初始化
            ViewUtils.showToast(this, "创建对象失败");
            return false;
        } else {
            return true;
        }
    }

    @Override
    public void onPermissionsGranted(int requestCode, List<String> perms) {

        switch (requestCode) {
            // 定位动作
            case REQUEST_CODE_LOCATION:
                startLocate();
                break;
        }
    }

    @Override
    public void onPermissionsDenied(int requestCode, List<String> perms) {
        ViewUtils.showToast(this, "定位失败");
    }
}
