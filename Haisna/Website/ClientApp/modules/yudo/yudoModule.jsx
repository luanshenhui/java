/**
 * 誘導のActionとReducer
 */
import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  initializeYudoConsultationMonitorStatus,
  startGetYudoConsultationMonitorStatus,
  stopGetYudoConsultationMonitorStatus,
  getYudoConsultationMonitorStatusRequest,
  getYudoConsultationMonitorStatusSuccess,
  getYudoConsultationMonitorStatusFailure,
  stopRingingYudoConsultationMonitorStatus,
} = createActions(
  'INITIALIZE_YUDO_CONSULTATION_MONITOR_STATUS',
  'START_GET_YUDO_CONSULTATION_MONITOR_STATUS',
  'STOP_GET_YUDO_CONSULTATION_MONITOR_STATUS',
  'GET_YUDO_CONSULTATION_MONITOR_STATUS_REQUEST',
  'GET_YUDO_CONSULTATION_MONITOR_STATUS_SUCCESS',
  'GET_YUDO_CONSULTATION_MONITOR_STATUS_FAILURE',
  'STOP_RINGING_YUDO_CONSULTATION_MONITOR_STATUS',
);

// stateの初期値
const initialState = {
  consultationMonitorStatus: {
    rooms: {
      room1: {
        room_id: '221',
        blink: false,
        dayid: null,
        kenshin_jotai_code: null,
      },
      room2: {
        room_id: '222',
        blink: false,
        dayid: null,
        kenshin_jotai_code: null,
      },
    },
    sound: null,
    doRinging: false,
    intervalId: null,
    messages: [],
  },
};

// reducerの作成
export default handleActions({
  // 診察状態初期化処理
  [initializeYudoConsultationMonitorStatus]: (state) => {
    const { consultationMonitorStatus } = initialState;
    return { ...state, consultationMonitorStatus };
  },
  // 診察状態監視開始処理
  [startGetYudoConsultationMonitorStatus]: (state, action) => {
    const { consultationMonitorStatus } = state;
    const { intervalId, sound } = action.payload;
    return { ...state, consultationMonitorStatus: { ...consultationMonitorStatus, intervalId, sound } };
  },
  // 診察状態取得成功時
  [getYudoConsultationMonitorStatusSuccess]: (state, action) => {
    const { consultationMonitorStatus } = state;
    // 全診察室の初期状態取得
    const initialRooms = initialState.consultationMonitorStatus.rooms;
    // blinkの判定を追加
    const data = Array.isArray(action.payload) ? action.payload
      .map((rec) => ({ ...rec, blink: rec.kenshin_jotai_code === '100027' })) : [];
    // 診察室Aを取得
    const room1 = data.filter((rec) => rec.room_id === '221')[0] || initialRooms.room1;
    // 診察室Bを取得
    const room2 = data.filter((rec) => rec.room_id === '222')[0] || initialRooms.room2;
    // 取得前の部屋状態
    const prevRooms = consultationMonitorStatus.rooms;
    // 音を鳴らす判定を取得
    // 検査室Aか検査室Bの当日IDが変更されたか前回の状態が非点滅状態で点滅状態になった場合に音を鳴らす
    const doRinging =
      ((prevRooms.room1.dayid !== room1.dayid || !prevRooms.room1.blink) && room1.blink) ||
      ((prevRooms.room2.dayid !== room2.dayid || !prevRooms.room2.blink) && room2.blink);
    return { ...state, consultationMonitorStatus: { ...consultationMonitorStatus, rooms: { room1, room2 }, doRinging, messages: [] } };
  },
  // 診察状態取得失敗時
  [getYudoConsultationMonitorStatusFailure]: (state, action) => {
    const { consultationMonitorStatus } = state;
    const messages = action.payload.data.errors;
    return { ...state, consultationMonitorStatus: { ...consultationMonitorStatus, messages } };
  },
  // 音を鳴らすフラグをオフにする
  [stopRingingYudoConsultationMonitorStatus]: (state) => {
    const { consultationMonitorStatus } = state;
    const doRinging = false;
    return { ...state, consultationMonitorStatus: { ...consultationMonitorStatus, doRinging } };
  },
  // 診察状態監視停止処理
  [stopGetYudoConsultationMonitorStatus]: (state) => {
    clearInterval(state.consultationMonitorStatus.intervalId);
    return state;
  },
}, initialState);
