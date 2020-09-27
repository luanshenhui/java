package com.sanzeng.hello_watch.ui.activity.login;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
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
import com.iflytek.cloud.VerifierListener;
import com.iflytek.cloud.VerifierResult;
import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.cts.AppConst;
import com.sanzeng.hello_watch.ui.activity.MainActivity;
import com.sanzeng.hello_watch.utils.NetworkUtil;
import com.sanzeng.hello_watch.utils.PfsUtils;
import com.sanzeng.hello_watch.utils.ProjectPfs;
import com.sanzeng.hello_watch.utils.ViewUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import pub.devrel.easypermissions.EasyPermissions;

public class LoginActivity extends Activity implements EasyPermissions.PermissionCallbacks {

    @BindView(R.id.address_tv)
    TextView address_tv;

    @BindView(R.id.showMsg)
    TextView showMsg;

    // 定位client
    private LocationClient client;
    // 请求权限code
    private final static int REQUEST_CODE_LOCATION = 100;

    // 声纹识别对象
    private SpeakerVerifier mVerifier;

    private static final int PWD_TYPE_TEXT = 1;
    private static final int PWD_TYPE_FREE = 2;

    // 当前声纹密码类型，1、2、3分别为文本、自由说和数字密码
    private int mPwdType = PWD_TYPE_TEXT;

    // 文本声纹密码
    private String mTextPwd = "";

    // 请使用英文字母或者字母和数字的组合，勿使用中文字符
    private String mAuthId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        ButterKnife.bind(this);

        // 定位动作
        locateAction();

        // 初始化SpeakerVerifier，InitListener为初始化完成后的回调接口
        mVerifier = SpeakerVerifier.createVerifier(LoginActivity.this, new InitListener() {

            @Override
            public void onInit(int errorCode) {
                if (ErrorCode.SUCCESS == errorCode) {
                    ViewUtils.showToast(LoginActivity.this, "引擎初始化成功");
                } else {
                    ViewUtils.showToast(LoginActivity.this, "引擎初始化失败，错误码：" + errorCode);
                }
            }
        });
    }



    @Override
    protected void onResume() {
        super.onResume();
        mAuthId = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.M_AUTH_ID);
        mTextPwd = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.TEXT_PSW);
        if (!checkInstance()) {
            return;
        }
        verify();
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
            address_tv.setText("定位失败");
            ViewUtils.showToast(this, getString(R.string.lbs_address_fail));
            return;
        }

        startLocate(); // 进行定位
    }


    /**
     * 授权成功后进行定位
     */
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
        address_tv.setText("定位失败");
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
                        String address = bdLocation.getCity();
                        address_tv.setText("当前位置:" + address);
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
                ViewUtils.showToast(LoginActivity.this, "请获取密码后进行操作");
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
                //是否输入手环
                String  strWatchCode = PfsUtils.readString(ProjectPfs.PFS_SYS, AppConst.WATCH_CODE);
                //是否选择角色
                boolean flag_peo = PfsUtils.readBoolean(ProjectPfs.PFS_SYS, AppConst.CHOICE_PEOPLE);
                if (!strWatchCode.equals("")) {
                    if (flag_peo) {
                        startActivity(new Intent(LoginActivity.this, MainActivity.class));
                        finish();
                    } else{
                        startActivity(new Intent(LoginActivity.this, SureRoleActivity.class));
                        finish();
                    }
                } else {
                    startActivity(new Intent(LoginActivity.this, JoinFamilyActivity.class));
                    finish();
                }
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
//                    ViewUtils.showToast(LoginActivity.this, "" + error.getPlainDescription(true));
                    // 开始验证
                    mVerifier.startListening(mVerifyListener);
                    break;
            }
        }

        @Override
        public void onEndOfSpeech() {
            // 此回调表示：检测到了语音的尾端点，已经进入识别过程，不再接受语音输入
//            ViewUtils.showToast(LoginActivity.this, "结束说话");
        }

        @Override
        public void onBeginOfSpeech() {
            // 此回调表示：sdk内部录音机已经准备好了，用户可以开始语音输入
            ViewUtils.showToast(LoginActivity.this, "开始说话");
        }
    };

    /**
     * 在页面销毁的时候要将定位client移除
     */
    @Override
    public void onStop() {
        super.onStop();
        if (client != null) {
            client.stop();
        }
    }

    /**
     * 取消注册广播
     */
    @Override
    protected void onDestroy() {
        if (client != null) {
            client.stop();
        }

        if (null != mVerifier) {
            mVerifier.stopListening();
            mVerifier.destroy();
        }
        super.onDestroy();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    private boolean checkInstance() {
        if (null == mVerifier) {
            // 创建单例失败，与 21001 错误为同样原因，
            // 参考 http://bbs.xfyun.cn/forum.php?mod=viewthread&tid=9688
//            ，请确认 libmsc.so 放置正确，
//            且有调用 createUtility 进行初始化
            ViewUtils.showToast(this, "创建对象失败");
            return false;
        } else {
            return true;
        }
    }
}
